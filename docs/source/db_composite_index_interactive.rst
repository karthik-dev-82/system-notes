Composite Indexes & the Leftmost Prefix Rule: Play With It
==============================================================

.. note::

   Fourth in the small series built on the same 20-country dataset
   from :doc:`databases_postgresql_mongodb_redis` (full table:
   :doc:`db_country_dataset`). See :doc:`db_index_scan_interactive`
   for the single-column version of this same idea.

A composite index on ``(region, currency)`` can serve a query on
``region`` alone, or on ``region`` and ``currency`` together -- but
never on ``currency`` alone. That's the leftmost prefix rule, and it's
not a rule of thumb, it's a direct consequence of how a B-Tree index is
physically sorted.

Play With It
------------------

Build a composite index, build a query against the same country data,
and see exactly which columns the index actually gets to use for
narrowing the search, which ones fall back to row-by-row rechecking,
and whether the query can be answered from the index alone.

.. raw:: html
   :file: _static/db_composite_index_widget.html
