Database Sharding: Play With It
======================================

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

     div.document table.docutils {
       width: 100%;
       border-collapse: collapse;
       background: #ffffff;
       border: 1px solid #cdd6cc;
       margin: 6px 0 24px;
       font-size: 0.92rem;
       font-family: -apple-system, "Segoe UI", sans-serif;
     }
     div.document table.docutils th.head {
       text-align: left;
       padding: 9px 14px;
       font-size: 0.72rem;
       letter-spacing: 0.06em;
       text-transform: uppercase;
       color: #7a2f3d;
       border-bottom: 2px solid #7a2f3d;
       font-weight: 700;
     }
     div.document table.docutils td {
       padding: 9px 14px;
       border-bottom: 1px solid #cdd6cc;
       vertical-align: top;
     }
     div.document table.docutils tr.row-even { background: #f7f6f2; }
     div.document table.docutils tr.row-odd { background: transparent; }
     div.document table.docutils tr:last-child td { border-bottom: none; }

     div.document p.plantuml { text-align: center; margin: 30px 0; }
     div.document p.plantuml img {
       max-width: 100%;
       height: auto;
       background: #ffffff;
       border: 1px solid #cdd6cc;
       padding: 20px;
     }
   </style>

Sharding splits one logical table across several physical databases so
no single machine has to hold (or answer queries against) the whole
thing. The question that actually matters isn't *whether* to shard --
it's **which key decides where a row lives**, because that one choice
determines everything else: how evenly writes spread out, how cheap it
is to add capacity later, and whether a range query touches one shard
or all of them.

Two Ways to Answer "Which Shard Owns This Key"
------------------------------------------------------

* **Hash-based**: ``shard = hash(key) % numShards``. Scatters keys
  pseudorandomly, so writes spread evenly almost no matter what the
  keys look like.
* **Range-based**: each shard owns a contiguous slice of the key
  space (``id 1-1000`` on shard 0, ``1001-2000`` on shard 1, and so
  on). Keeps related keys physically close together, which matters a
  lot for range queries.

Play With It
------------------

.. raw:: html
   :file: _static/sharding_widget.html

The Hot-Shard Problem, Not a Contrived Edge Case
---------------------------------------------------------

Click "Insert Next 25 Keys" a few times and watch both sides look
fine at first -- the range shards were sized to exactly fit the first
batch. Keep clicking, simulating a primary key that keeps
auto-incrementing the way real primary keys actually do, and only the
range-based side starts dumping everything on its last shard, because
that shard's range was always open-ended to begin with. This is a
real, well-documented failure mode for range sharding on
monotonically increasing keys (auto-increment IDs, timestamps) -- not
a scenario invented to make a point.

Two Different Rebalancing Operations
-------------------------------------------

Click "Add a Shard" and watch both sides react completely
differently:

* **Hash-based** has to recompute ``hash(key) % N`` for every single
  key, because changing the modulus changes almost every key's
  answer. The reshuffled fraction here is the same
  ``(N-1)/N``-shaped cost already demonstrated with real numbers on
  :doc:`hash_load_balancer_interactive` and made cheap by
  :doc:`consistent_hashing_interactive` -- this widget deliberately
  uses the *naive* version so the cost is visible; a production
  hash-sharded system would use consistent hashing here for exactly
  the reason that page exists.
* **Range-based** splits whichever shard is currently busiest --
  usually the hot last shard -- into two contiguous halves. Every
  other shard is provably untouched, because a split only ever moves
  keys that were already inside the shard being split.

Range Queries Are the Other Half of the Trade
------------------------------------------------------

Run the default range query (keys 10-20). Range-based touches exactly
the one shard whose range covers that window. Hash-based has to ask
*every* shard, because keys 10 through 20 could have hashed anywhere
-- this is genuine scatter-gather, provably required, not a
pessimistic assumption about how hashing works.

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 30 35 35

   * - Question
     - Hash-based
     - Range-based
   * - Write distribution
     - Even, regardless of key pattern
     - Even only while keys stay inside the initial ranges
   * - Sequential-key hot spot risk
     - None -- hashing destroys the ordering that causes this
     - Real and well-documented -- the open-ended last shard absorbs
       all future growth
   * - Adding a shard
     - Reshuffles most keys (unless using consistent hashing)
     - Splits one shard; every other shard untouched
   * - Range query cost
     - Scatter-gather across every shard
     - Touches only the overlapping shard(s)

See Also
-------------

See :doc:`consistent_hashing_interactive` for the fix to hash-based
sharding's rebalancing cost -- this page uses the naive modulo version
on purpose, to make the cost worth fixing visible before showing the
fix.

See :doc:`hash_load_balancer_interactive` for the exact same
reshuffling math applied to routing live traffic instead of routing
stored rows -- same underlying problem, same ``(N-1)/N`` shape.

See :doc:`cap_theorem_interactive` for what happens once a sharded
system also replicates each shard for durability -- sharding decides
*which* node owns a key; replication and its CP/AP tradeoff decide
what happens when that node can't be reached.
