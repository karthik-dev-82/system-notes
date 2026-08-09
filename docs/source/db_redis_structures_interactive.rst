Redis Data Structures: Play With It
=======================================

.. note::

   Second in a small series built on the same 20-country dataset from
   :doc:`databases_postgresql_mongodb_redis` (full table:
   :doc:`db_country_dataset`). See :doc:`db_index_scan_interactive`
   for the first: index vs. full scan on the PostgreSQL side of that
   guide.

The source guide's fast-food-counter analogy for Redis covers four
genuinely different structures under one roof: hashes (bins), sorted
sets (leaderboards), sets (combos), and expiring keys (cache). They
don't share a mechanism -- a hash is a flat lookup table, a sorted set
is a structure that's kept sorted on every write instead of sorted on
read, a set is real set algebra, and a TTL key is a countdown that,
once it reaches zero, never comes back. This page lets you run all
four against the same data and see exactly what "fast" means in each
case.

Play With It
------------------

Try HGET on a country's capital -- one field, one lookup, nothing else
touched. Switch to the leaderboard and ask for USA's rank -- notice
there's no searching happening, because the structure was already
sorted before you asked. Intersect ``region:Europe`` with
``currency:EUR`` and watch which countries fall out of the overlap.
Then set a key with a 5-tick TTL, advance the clock yourself, and
watch ``GET`` flip to ``nil`` the moment it expires -- permanently, no
matter how many more ticks you advance.

.. raw:: html
   :file: _static/db_redis_structures_widget.html

Four Structures, Four Different Guarantees
-------------------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 16 28 28 28

   * - Structure
     - What's guaranteed
     - Cost of a write
     - Cost of a read
   * - Hash
     - Nothing about order -- just "this field has this value"
     - O(1)
     - O(1) per field
   * - Sorted set
     - Fully sorted, always, even mid-update
     - O(log n) to find the right slot
     - O(1) for rank/top-N -- the sort already happened
   * - Set
     - No duplicates, real membership semantics
     - O(1) per member
     - O(size of the smaller set) for an intersection
   * - TTL key
     - Once expired, never resurrected
     - O(1)
     - O(1), but may trigger a lazy delete

The sorted set row is the one worth sitting with: the *work* of
sorting happens at write time (``ZADD``), not read time. That's the
opposite of a typical in-memory array you'd sort right before reading
it. Every ``ZREVRANGE`` and ``ZREVRANK`` in the widget above is reading
off a structure that was already correct the instant before you asked
-- there's no sorting step hiding inside the read.

Why "Proven Empty" Still Costs Something for SINTER
-----------------------------------------------------------

Try intersecting ``region:Europe`` with ``currency:USD`` in the
widget. The result is empty -- no European country uses the US
dollar in this dataset -- but that's not a free answer the way an
index miss was on the :doc:`index-vs-scan page
<db_index_scan_interactive>`. ``SINTER`` still has to walk the smaller
of the two sets and check each member against the other, because a
set has no way to know in advance whether two collections overlap.
That's the real trade-off sets make: membership checks and
intersections are cheap and predictable, but never quite as free as a
hash's "does this exact key exist" lookup.

The TTL Clock Is Virtual, on Purpose
-------------------------------------------

The widget's clock advances only when you click "Advance 1 tick," not
on a wall-clock timer. That's a deliberate choice, not a
simplification of the mechanism: real Redis keys really do expire
lazily, checked against the actual clock only when something reads
them (plus a background sweep that isn't modeled here) -- the tick
button just makes that moment something you can trigger exactly when
you want to see it, instead of waiting through real seconds to watch
a number count down.

See Also
-------------

See :doc:`databases_postgresql_mongodb_redis` for the guide this
dataset and all four Redis structures come from, and
:doc:`db_index_scan_interactive` for the PostgreSQL half of this
series -- same countries, same population and GDP numbers, a
completely different set of guarantees.
