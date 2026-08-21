Raft Consensus: Play With It
===================================

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

Every "quorum" and "leader election" idea on this site so far has
been a simplified stand-in for something -- CAP's 2-node partition
demo, Kafka's ISR-based election. Raft is the real, general thing
those were simplified *from*: a full, provably correct algorithm for
getting a cluster of machines to agree on one consistent sequence of
operations, even while machines crash and restart around it. It was
published in 2014 specifically to be *understandable* -- the paper's
own title is "In Search of an Understandable Consensus Algorithm" --
as an alternative to Paxos, which solves the same problem but is
notoriously hard to reason about correctly.

Raft splits into two mostly-independent pieces, and this page builds
both as separate widgets, the same way the paper separates them into
two sections.

Part 1: Leader Election
------------------------------

At any moment, every node is a **follower**, **candidate**, or
**leader**. Time is divided into **terms**, each with at most one
leader. A follower that stops hearing from a leader for longer than
its own randomized timeout becomes a candidate: it increments the
term, votes for itself, and requests votes from everyone else. A
candidate becomes leader the moment it collects votes from a
**majority** of the cluster.

Play With It: 5 Nodes, Real Randomized Timeouts
---------------------------------------------------------

.. raw:: html
   :file: _static/raft_election_widget.html

Click "Kill the Leader" and watch a real election happen -- some
follower's timeout fires first (randomized, so it's not always the
same one), it requests votes, and wins. Click "Force a 3-Way Split
Vote" to see the failure case the randomization exists to make rare:
three nodes go candidate in the exact same instant, the remaining two
votes split between them, and *nobody* reaches a majority -- keep
ticking and watch it resolve anyway, because each candidate's retry
timeout is freshly randomized too, so a repeat tie becomes
exponentially less likely each round. Click "Kill 3 of 5" to lose
quorum entirely: no candidate can ever collect 3 votes with only 2
nodes reachable, so the cluster simply has no leader until enough
come back -- the exact same majority math as the
:doc:`CAP theorem quorum widget <cap_theorem_interactive>`, just
running the real election protocol instead of an abstract stand-in.

Part 2: Log Replication
------------------------------

Once a leader exists, every client command becomes a new entry in its
log. The leader replicates that entry to followers via
**AppendEntries**, and once a **majority** of the cluster (leader
included) has it, the entry is **committed** -- safe, permanent,
guaranteed to survive any single node's crash from that point on.

Play With It: Replicate, Conflict, Converge
--------------------------------------------------

.. raw:: html
   :file: _static/raft_replication_widget.html

Send a command, then replicate it to just F1 -- watch commitIndex
advance immediately, without F2 ever needing to catch up. That's the
majority rule in action: with 3 nodes, leader + 1 follower is already
enough. Then click "Seed F1 with a Conflicting Entry" (simulating what
a follower's log might look like after a previous leader crash left it
half-updated) and replicate to F1 again -- the first attempt fails a
real consistency check, the leader backs off one entry and retries,
and once it finds a point both logs agree on, everything after that
point on F1 gets truncated and overwritten with the leader's
authoritative entries. Nothing here is hand-waved: the same
(index, term) consistency check and backtrack-then-overwrite mechanic
run in real Raft implementations, not just this widget.

Why the Log's Term Field Matters
---------------------------------------

Two entries only count as "the same" if they agree on both their
index *and* their term -- agreeing on index alone isn't enough,
because two different leaders (in two different terms) could
theoretically have written different commands at the same index. This
is also why a leader may only directly commit an entry from its own
*current* term: an older entry that happens to reach a majority via a
newer leader's replication isn't safe to commit on that basis alone
until a current-term entry after it also commits (Raft paper, Figure
8 -- a genuinely subtle safety hazard the naive "committed once it
hits a majority" rule would otherwise walk into). This widget's model
enforces that rule correctly, even though it doesn't have its own
dedicated step-by-step demo of the specific scenario.

What's Deliberately Out of Scope
---------------------------------------

Two widgets cover leader election and log replication -- the two
pillars the Raft paper itself is organized around, and the two
mechanisms actually worth having internalized. Left out on purpose:
**cluster membership changes** (adding or removing servers from a
live cluster, which needs its own joint-consensus protocol) and **log
compaction / snapshotting** (what happens once a log has grown too
large to replay from scratch). Both are real parts of a production
Raft implementation, and both are bigger, more specialized topics than
fit alongside the core algorithm on one page.

Where This Shows Up
--------------------------

* See :doc:`cap_theorem_interactive` for the abstract version of the
  quorum math this page's election widget runs for real -- and for
  Kafka's ISR-based leader election, a real production system that
  solves a narrower version of the same problem this page solves in
  general.
* See :doc:`kafka_topic_interactive` for the same "leader's log wins,
  a rejoining replica gets truncated" idea, demonstrated a different
  way (whole-log copy) instead of this page's index-by-index
  negotiation -- and for a genuine real-world postscript: modern
  Kafka (KRaft mode) actually replaced its old ZooKeeper dependency
  with a real Raft implementation for cluster metadata, the same
  algorithm this page builds from scratch.
* See :doc:`database_sharding_interactive` and
  :doc:`cache_strategies_interactive` for two more corners of the
  system-design map this "System Design" section has covered --
  Raft is the piece that lets a distributed system agree on
  anything at all in the first place, underneath all of them.
