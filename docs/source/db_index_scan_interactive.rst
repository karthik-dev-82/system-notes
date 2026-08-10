Index vs. Full Scan: Play With It
=====================================

.. note::

   This page is part of a small series built on the same 20-country
   dataset used throughout :doc:`databases_postgresql_mongodb_redis`
   (see :doc:`db_country_dataset` for the full table)
   -- the "Ultimate Guide" that introduces PostgreSQL, MongoDB, and
   Redis through a kitchen/restaurant analogy. Where that guide
   explains the *idea* of an index with a spice-warehouse story, this
   page lets you run the exact same query two different ways and
   watch the real cost difference for yourself. See
   :doc:`db_composite_index_interactive` for the multi-column version
   of this same idea.

An index isn't a speed boost applied after the fact -- it's a
completely different search strategy, chosen instead of a full scan
*before* the query even runs. A full scan has no shortcuts: it checks
every row's condition, one at a time, no matter how selective the
query is. An index narrows the search first -- a hash lookup for an
exact match, a binary search for a range -- and only fetches the rows
that actually matched.

Play With It
------------------

Run ``WHERE region = 'Europe'`` and watch the index jump straight to
one bucket while eight other rows never get touched at all. Then
switch to range mode and drag the population threshold -- watch the
binary search's actual probe sequence light up on a population-sorted
list, narrowing in on the boundary in a handful of steps no matter
where you drag it.

.. raw:: html
   :file: _static/db_index_scan_widget.html

Two Searches, Two Very Different Costs
-------------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 18 41 41

   * - Strategy
     - Equality: ``WHERE region = 'Europe'``
     - Range: ``WHERE population > X``
   * - Full scan
     - Checks all 20 rows' region field. Cost is always 20, no matter
       how many rows actually match.
     - Checks all 20 rows' population field. Cost is always 20, no
       matter how many rows actually match.
   * - Index
     - One hash lookup into the region bucket, then fetch only the
       matches. Cost is ``1 + matches``.
     - Binary search for the boundary (``log2(20)`` steps), then fetch
       only the matches. Cost is ``log2(20) + matches``.

The scan's cost line never changes -- that's the whole point of a
scan. The index's cost line is a function of how *selective* the
query is: a query that matches almost nothing (or almost everything)
is cheap; a query that matches roughly half the table sits right in
the middle, and can occasionally cost *more* than a scan once the
search overhead stops paying for itself.

Why "Proving a Negative" Is the Clearest Case
----------------------------------------------------

The starkest version of this isn't a query that matches a few rows --
it's a query that matches *none*. Try ``region = 'Antarctica'`` in the
widget above. The scan still has to check all 20 rows before it can
be sure nothing matches -- there's no way to stop early and still be
correct. The index answers in a single hash lookup: the bucket simply
doesn't exist, so there was never anything to search through.

This is also exactly why a real query planner will sometimes *refuse*
to use an available index. If a condition matches nearly every row,
walking the index and then fetching every matched row costs more than
just reading the table straight through. The index in this widget
doesn't pretend otherwise -- push the population threshold down toward
zero and watch its own cost number climb past the scan's.

See Also
-------------

See :doc:`databases_postgresql_mongodb_redis` for the full guide this
page's dataset and index examples come from, including the original
``CREATE INDEX`` statements and the warehouse-shelf-label analogy this
widget makes literal and checkable.
