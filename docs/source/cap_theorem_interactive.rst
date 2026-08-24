CAP Theorem: Play With It
================================

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

CAP is one of those ideas everyone can recite ("Consistency,
Availability, Partition tolerance -- pick two") and almost nobody can
explain precisely, because the recited version is subtly wrong. This
page builds the correct version, then hands you two small simulators
so the tradeoff isn't a slogan -- it's something you trigger yourself
and watch happen.

What CAP Actually Says
-----------------------------

For a distributed system that replicates data across more than one
node:

* **Consistency** here means *linearizability* -- every read gets the
  most recent write, as if there were only one copy of the data.
* **Availability** means every request to a non-failed node gets a
  response -- not necessarily the *right* response, just *a*
  response, without waiting forever.
* **Partition tolerance** means the system keeps working even when
  network messages between nodes can be dropped or delayed.

The popular phrasing -- "pick two of three" -- implies partition
tolerance is optional, like a feature you could choose to skip. It
isn't. Any system with more than one node, on more than one machine,
*will* eventually experience a partition: a switch fails, a cable gets
cut, a network segment gets congested enough to look cut. You don't
get to opt out of partitions any more than you get to opt out of
hardware eventually failing.

So the real choice CAP describes is narrower and sharper than "pick
two": **when a partition happens, and a node can't confirm it has the
latest data, does it answer anyway (favoring Availability) or does it
refuse to answer (favoring Consistency)?** Without a partition, a
well-built system can give you both C and A at once -- there's nothing
to trade off. The tradeoff is *only* visible during the partition
itself. That's the one thing worth taking away if you take away
nothing else from this page, and it's exactly what the widget below
makes you do.

Play With It: Partition a 2-Node Store
---------------------------------------------

.. raw:: html
   :file: _static/cap_partition_widget.html

Reading What Happened
----------------------------

Two replicas, A and B, hold one key. As long as the link between them
is up, every write to either one replicates immediately to the other
-- reads from either side always agree, regardless of which policy
button is selected. **Nothing about CP vs. AP matters until you
actually break the network.** That's the point made concrete: the
tradeoff is conditional on a partition existing, not a permanent
property of the system.

Once you break it and try writing or reading:

* **CP** rejects every read and write on *both* sides. That surprises
  people expecting "the good side keeps working" -- but with only two
  replicas, neither one can prove it's the one still connected to the
  rest of the system. A strict consistency guarantee has no safe
  choice but to refuse everyone until the link is back. (The next
  widget shows how adding more replicas fixes this.)
* **AP** keeps both sides answering immediately, using whatever local
  data each one has. That's real availability -- but if you write
  different values to A and B while they can't talk to each other,
  they now genuinely disagree, and a client reading from B has no way
  to know it's looking at stale data.

Healing the network does **not** silently fix a disagreement -- notice
the divergence warning stays up until you explicitly click
**Reconcile**. That's not a simplification for the widget; it's the
same reason "eventually consistent" systems need an actual mechanism
(anti-entropy, read-repair, a merge on next write) to converge --
"eventually" doesn't happen for free just because the network came
back. Reconcile here uses last-write-wins by timestamp -- the same
default strategy Cassandra uses -- and it's worth watching closely:
the losing write isn't merged, it's discarded. That's a real,
documented weakness of naive LWW under concurrent writes, not an edge
case invented for this demo. Systems that can't tolerate silently
losing a write use vector clocks or CRDTs instead, which can detect
that two writes genuinely conflict rather than guessing a winner.

This is also the concrete version of **strong vs. eventual
consistency**, a distinction usually taught as pure vocabulary: CP
behavior *is* strong consistency (refuse rather than risk a stale
answer); AP behavior *is* eventual consistency (answer immediately,
converge later). They're not two different features -- they're the
same AP/CP choice, just named from the read side instead of the
partition side.

Suggested Experiments
----------------------------

Try these in order at least once -- each one isolates a different
piece of the theorem:

1. Write ``first`` to Node A with the network connected. Confirm it
   shows up on Node B too, in either mode -- proving the mode toggle
   genuinely does nothing while there's no partition.
2. Break the network. Switch to **CP**. Try writing to A, then reading
   from B. Both refuse. This is the "why does CP take down the whole
   system?" moment -- it doesn't have to, but with two nodes it does.
3. Still partitioned, switch to **AP**. Write ``left`` to A and
   ``right`` to B. Read both sides -- they succeed immediately, with
   different answers. You just watched the C get spent to keep the A.
4. Heal the network. Read either side again *before* clicking
   Reconcile -- the disagreement is still there. Then click Reconcile
   and read the log line explaining which write survived and which
   didn't.
5. Repeat step 3, but write to A first, wait, then write to B --
   giving B's write a later clock value on purpose -- and predict
   which one Reconcile will keep before you click it.

Play With It: Why CP Doesn't Mean Everyone Goes Down
------------------------------------------------------------

The two-node widget above is real, but it hides a detail: strict CP
losing *all* availability during a partition is a two-node problem,
not a fundamental law. Real CP systems use more replicas and a
**quorum** rule, so only the minority side goes dark.

.. raw:: html
   :file: _static/cap_quorum_widget.html

Drag the cluster size and the isolated-group-size sliders and watch
the majority side keep serving while the minority side refuses, in CP
mode -- then set cluster size to an even number and split it exactly
in half to see *both* sides lose quorum at once. That even-split
failure mode is the textbook reason production quorum systems (etcd,
ZooKeeper ensembles, Raft clusters) are run with an odd number of
nodes: an odd total can never split into two equal halves, so there's
always exactly one side that has a majority, and the cluster always
has a definite answer for who's allowed to keep serving.

That quorum rule -- "a majority must agree before anything is
considered official" -- is also the seed of leader election in
**Raft** and **Paxos**, where a node can only become leader after
collecting votes from a majority of the cluster. Consensus algorithms
are a much bigger topic than fits on this page; treat this widget as
the one idea from them worth having solid before tackling the rest.

Where This Shows Up
--------------------------

* See :doc:`databases_postgresql_mongodb_redis` for how PostgreSQL,
  MongoDB, and Redis differ in the replication and transaction model
  each is built around -- the substrate this page's tradeoff plays out
  on top of, even though that page doesn't frame it in CAP terms
  directly.
* See :doc:`consistent_hashing_interactive` and :doc:`hash_load_balancer`
  for what happens to *routing* -- which node owns which key -- when
  the set of nodes changes. That's a related but distinct problem from
  this page's question, which is what a node does when it can't reach
  the *other* node it needs to stay consistent with.
* See :doc:`kafka_topic_interactive` for this exact AP-vs-CP choice
  wearing real production names: Kafka's ``unclean.leader.election.enable``
  flag is this page's CP/AP toggle, and ``min.insync.replicas`` is its
  version of a quorum requirement, both enforced on a real replicated
  log instead of an abstract 2-node store.
* See :doc:`db_acid_transaction_interactive` for the same "serve now
  vs. guarantee correctness" tension shrunk down to a single machine --
  isolation levels are what one transaction can see of another
  in-flight transaction's work, the same shape of question this page
  asks about one node and another.
* See :doc:`cassandra_interactive` for the real system behind this
  page's last-write-wins default, plus the N/W/R quorum mechanism that
  lets Cassandra *tune* how far toward C or A a given read or write
  leans, rather than picking one side of this page's toggle globally.
