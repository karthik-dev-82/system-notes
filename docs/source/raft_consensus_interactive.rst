Raft Consensus: Play With It
===================================

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
