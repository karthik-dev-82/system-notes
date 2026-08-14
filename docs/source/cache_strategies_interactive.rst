Cache Strategies: Play With It
=====================================

"Caching" sounds like one idea, but it's really two independent
questions that get tangled together: **who talks to whom when data
moves between the cache and the database**, and **what gets thrown
away when the cache is full**. This page builds both, separately,
each with its own widget.

Part 1: Who Talks to Whom
--------------------------------

Four strategies, each a genuinely different answer to "how does data
get into the cache, and when is a write actually safe":

* **Cache-aside**: the app owns the coordination. On a miss, the app
  reads the DB itself and populates the cache. On a write, the app
  writes the DB and *invalidates* (not updates) the cache entry.
* **Read-through**: the app only ever talks to the cache. On a miss,
  the cache loads from the DB on the app's behalf -- the app never
  touches the DB directly.
* **Write-through**: like read-through, but for writes -- the cache
  commits synchronously to the DB before acknowledging the app's
  write. Exactly as durable as writing the DB directly.
* **Write-back** (write-behind): the app's write is acknowledged the
  instant it lands in the cache. The DB gets updated later, in the
  background.

Play With It: Reads, Writes, and a Cache Crash
---------------------------------------------------------

.. raw:: html
   :file: _static/cache_strategies_widget.html

Pick **write-back**, write a key, and click **Simulate Cache Crash**
before flushing. The write is gone -- not delayed, not recoverable,
just gone, because it was only ever acknowledged by the cache, which
no longer exists. Switch to **write-through** and do the exact same
crash: nothing is lost, because the write was already durable in the
DB before the app ever got its "OK" back. That's the entire trade
write-back makes explicit: faster writes, in exchange for a real
window where an acknowledged write can vanish.

Part 2: What Gets Thrown Away
------------------------------------

Once the cache is full, a policy has to pick who leaves to make room
for someone new:

* **LRU** (Least Recently Used): evict whoever hasn't been touched in
  the longest time. Every access -- read or write -- resets the clock.
* **FIFO** (First In, First Out): evict whoever arrived first, full
  stop. Access never changes anything.
* **LFU** (Least Frequently Used): evict whoever has the smallest
  access *count*, not the longest idle time.
* **TTL** (Time To Live): evict -- really, expire -- whoever's own
  clock has run out, independent of capacity or access pattern.

Play With It: Four Caches, One Access Sequence
---------------------------------------------------------

.. raw:: html
   :file: _static/eviction_policies_widget.html

Click **Run LRU-vs-FIFO Divergence Demo**. It plays A, B, C, D, A, E
against all four caches at once. LRU and FIFO fill identically with
A/B/C/D -- then re-accessing A does something different in each: LRU
moves A to the protected end, FIFO does nothing at all, because FIFO's
rule never looks at access, only arrival order. When E arrives and
something has to go, LRU evicts B (the actual least-recently-touched
entry); FIFO evicts A anyway. Same four keys, same access sequence,
same capacity -- genuinely different answers, which is exactly the
mix-up worth having seen happen once instead of just read about.

Where This Shows Up
--------------------------

See :doc:`page_cache_interactive` for a different layer entirely --
the OS page cache sits between a process and disk, not between an app
and a database, but it makes some of the same durability tradeoffs
(this page's write-back is the same shape of risk as that page's
"crash before fsync() and lose it" scenario, one layer down the
stack).

See :doc:`db_redis_structures_interactive` for a real system's actual
TTL implementation (Redis key expiry), the same mechanism this page's
eviction widget models in miniature.

See :doc:`cap_theorem_interactive` for the same "acknowledge now,
risk it later" shape of tradeoff at the distributed-systems level --
write-back's crash-loses-data risk here is a smaller-scale cousin of
AP mode's willingness to serve (and lose) data during a partition.
