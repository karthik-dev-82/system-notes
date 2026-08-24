Apache Cassandra: Play With It
=====================================

.. raw:: html

   <style>
     div.document {
       background: #eef1ee;
       color: #1c231d;
       font-family: Georgia, "Iowan Old Style", "Times New Roman", serif;
       line-height: 1.68;
       font-size: 17px;
       border: 1px solid #cdd6cc;
       border-radius: 4px;
       padding: 40px 48px 48px;
       margin: 12px 0 24px;
     }
     div.document h1 {
       font-family: inherit;
       font-weight: 400;
       font-size: 2.4rem;
       line-height: 1.12;
       color: #1c231d;
       border-bottom: 1px solid #cdd6cc;
       padding-bottom: 18px;
       margin: 0 0 30px;
     }
     div.document h2 {
       font-family: inherit;
       font-weight: 400;
       font-style: italic;
       font-size: 1.5rem;
       color: #1c231d;
       margin: 44px 0 10px;
       padding-top: 26px;
       border-top: 1px solid #cdd6cc;
     }
     div.document h2:first-of-type { border-top: none; padding-top: 0; margin-top: 30px; }
     div.document h3 {
       font-family: inherit;
       font-weight: 700;
       font-style: normal;
       font-size: 1.14rem;
       color: #7a2f3d;
       margin: 26px 0 8px;
     }
     div.document .headerlink {
       color: #5c675d;
       opacity: 0.5;
       text-decoration: none;
       font-size: 0.7em;
       margin-left: 8px;
     }
     div.document .headerlink:hover { opacity: 1; }
     div.document p { margin: 0 0 17px; }
     div.document strong { color: #1c231d; font-weight: 700; }
     div.document a { color: #7a2f3d; text-decoration: underline; text-decoration-color: #7a2f3d55; text-underline-offset: 2px; }
     div.document a:hover { text-decoration-color: #7a2f3d; }
     div.document ul, div.document ol { margin: 0 0 17px; padding-left: 26px; }
     div.document li { margin-bottom: 7px; }
     div.document hr { border: none; border-top: 1px solid #cdd6cc; margin: 40px 0; }

     div.document code.docutils.literal {
       font-family: ui-monospace, "SF Mono", Menlo, monospace;
       font-size: 0.86em;
       background: #f2f0ea;
       border: 1px solid #d8d4c8;
       color: #4a2f14;
       padding: 1px 5px;
       border-radius: 2px;
     }

     div.document div.highlight {
       background: #f2f0ea;
       border: 1px solid #d8d4c8;
       border-left: 3px solid #7a2f3d;
       border-radius: 0;
       padding: 14px 18px;
       margin: 4px 0 22px;
       overflow-x: auto;
     }
     div.document div.highlight pre {
       background: transparent;
       color: #2a2a24;
       font-family: ui-monospace, "SF Mono", Menlo, monospace;
       font-size: 0.86rem;
       line-height: 1.6;
       margin: 0;
     }
     div.document .highlight .c1 { color: #7a7266; font-style: italic; }
     div.document .highlight .k, div.document .highlight .kn, div.document .highlight .nb { color: #3d5c3d; font-weight: 600; }
     div.document .highlight .s1, div.document .highlight .s2 { color: #7a2f3d; }
     div.document .highlight .gp, div.document .highlight .gh { color: #7a2f3d; font-weight: 700; }
     div.document .highlight .nv, div.document .highlight .ss,
     div.document .highlight .vc, div.document .highlight .vg,
     div.document .highlight .vi, div.document .highlight .vm { color: #4a4470; }
     div.document .highlight .o, div.document .highlight .go { color: #6a6a5e; }
   </style>

Cassandra is the real-world system behind two things already covered
generically on this site: :doc:`consistent_hashing_interactive`'s
virtual nodes are literally how Cassandra partitions data across a
cluster, and :doc:`cap_theorem_interactive`'s AP-leaning,
last-write-wins tradeoff is literally Cassandra's default. This page
is about the two mechanisms that are actually Cassandra's own:
**tunable consistency** and the **LSM-tree** storage engine underneath
every node.

Tunable Consistency: N, W, and R
---------------------------------------

Every keyspace has a **replication factor** N -- each row is stored on
N replicas. Every individual read or write then picks a **consistency
level**, which in practice means a count: how many of those N replicas
must respond before the operation is considered successful.

* **W** -- how many replicas must acknowledge a write.
* **R** -- how many replicas must respond to a read (which are then
  reconciled by timestamp -- the same last-write-wins rule
  :doc:`cap_theorem_interactive` already covers).

The load-bearing fact, provable by simple pigeonhole counting: if
**W + R > N**, the set of replicas a write touched and the set of
replicas a read queries *cannot* be disjoint -- there have to be N
replicas total, and W + R of them (with overlap allowed) is more than
N, so at least one replica has to be in both sets. That replica has
the latest write, so the read is guaranteed to see it. If **W + R <=
N**, disjoint sets are possible, and a read can miss the latest write
entirely.

``ONE`` / ``QUORUM`` / ``ALL`` are just names for replica counts (1,
majority, and N respectively) -- ``QUORUM`` writes plus ``QUORUM``
reads is the classic choice because it satisfies W + R > N while still
tolerating some replicas being down, unlike ``ALL``.

Play With It
------------------

.. raw:: html
   :file: _static/cassandra_widget.html

**Tab 1** runs the actual pigeonhole argument as a live fuzz test: pick
write and read consistency levels, run trials, and watch the overlap
rate match the formula exactly -- 100% whenever W + R > N, and
genuinely less than 100% (about 33% for ``ONE``/``ONE`` on a 3-node
cluster) whenever it isn't. **Tab 2** is the LSM-tree write path,
covered below.

Hinted Handoff and Read Repair
-------------------------------------

Two mechanisms keep replicas from staying permanently out of sync
after the kind of stale read the widget above can produce:

* **Hinted handoff:** if a replica is down or unreachable during a
  write, the coordinator that received the write stores a "hint" --
  essentially a note saying "replay this write here once it's back" --
  and replays it once that replica rejoins. This is why replicas
  converge on their own over time even without a client ever reading
  the missed key.
* **Read repair:** when a quorum read finds that some of the replicas
  it queried returned a stale value, the coordinator writes the
  correct (highest-timestamp) value back to those stale replicas as a
  side effect of the read -- so simply *reading* data that happens to
  be inconsistent is itself a repair mechanism, not just a query.

The LSM-Tree Write Path
------------------------------

Every page on this site that discusses indexing (:doc:`db_index_scan_interactive`,
:doc:`db_composite_index_interactive`) assumes a B-tree, where a write
means finding the right page and updating it in place -- a random I/O.
Cassandra's storage engine is a **Log-Structured Merge-tree** instead,
and it never does that:

#. A write goes straight into an in-memory **memtable** -- an
   append, not a search-then-update, so there's no disk seek on the
   write path at all.
#. When the memtable fills up, it's flushed to disk as an immutable
   **SSTable** ("sorted string table") and a fresh, empty memtable
   takes over.
#. A read has to check the memtable (freshest data) and potentially
   *every* SSTable on disk for that key, newest to oldest, until it
   finds a hit -- this is **read amplification**, and it's the real
   cost LSM-trees trade against their cheap writes. (This is exactly
   where :doc:`bloom_filter_interactive`'s per-SSTable Bloom filters
   earn their keep: a filter miss means a whole SSTable can be
   skipped without ever touching disk.)
#. **Compaction** periodically merges several SSTables into one,
   keeping only the newest version of each key -- collapsing read
   amplification back down and reclaiming space from overwritten data.
#. A delete doesn't remove anything immediately -- it writes a
   **tombstone**, a marker that says "this key is gone as of this
   timestamp." The key's old value(s) are only actually purged once
   compaction processes the tombstone. (Real Cassandra holds
   tombstones for a configurable grace period before that happens, to
   avoid a replica that missed the delete resurrecting the old value
   via replication -- simplified out of the widget above, but worth
   knowing the real system doesn't purge instantly either.)

Switch to **Tab 2** above: write random ops until a few SSTables have
flushed, read a key and note how many SSTables it had to check, then
hit **Compact Now** and read it again -- watch the count collapse to
one merged table (or zero, if the answer is still sitting in the
memtable).

Remember
------------

#. W + R > N guarantees a read overlaps the write's replica set;
   W + R <= N does not -- this single inequality is the entire
   "tunable consistency" story.
#. Hinted handoff and read repair are what make eventual consistency
   *actually* converge, rather than requiring every replica to somehow
   agree instantly.
#. LSM-trees trade cheap, append-only writes for read amplification
   (checking multiple SSTables), and compaction is the mechanism that
   periodically pays that cost back down.
#. A delete is a tombstone, not an erasure -- the data is only
   actually gone once compaction processes it.

See Also
--------------

:doc:`consistent_hashing_interactive` for the virtual-node
partitioning scheme Cassandra actually runs. :doc:`cap_theorem_interactive`
for the AP-leaning, last-write-wins tradeoff Cassandra defaults to.
:doc:`bloom_filter_interactive` for the per-SSTable filters that keep
LSM-tree read amplification from meaning "check every file on disk."
:doc:`db_index_scan_interactive` and :doc:`db_composite_index_interactive`
for the B-tree write path this page's LSM-tree is the alternative to.
