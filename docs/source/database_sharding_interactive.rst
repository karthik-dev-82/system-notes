Database Sharding: Play With It
======================================

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
