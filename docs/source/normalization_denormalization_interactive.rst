Normalization vs. Denormalization: Play With It
======================================================

Same 20 countries as :doc:`db_country_dataset`, stored two different
ways: **normalized**, where each country references a shared
``currencies`` table by code, and **denormalized**, where the
currency's name and symbol are copied directly onto every country
row. Every number and query plan on this page was captured from a
real PostgreSQL 16 instance loaded with both schemas -- this isn't a
hand-tuned cost formula standing in for a database.

The Real Trade Being Made
--------------------------------

* **Reads.** The normalized schema needs a join to answer "what
  currency does this country use" -- ``EXPLAIN ANALYZE`` shows a real
  Hash Join that scans both the 20-row ``countries`` table and the
  13-row ``currencies`` table. The denormalized schema answers the
  same question with a single scan of ``countries`` alone. At 20 rows
  the difference is trivial; the *shape* of the difference (one table
  touched vs. two) is what scales as either table grows.
* **Writes.** Change the euro's symbol and the normalized schema
  updates exactly **1 row** -- the one row in ``currencies`` that
  every euro-zone country already points at. The denormalized schema
  has to update **every row that copied it**: 8, for this dataset's 8
  EUR-using countries (Germany, France, Italy, Spain, Netherlands,
  Austria, Belgium, Finland -- the same 8 called out in
  :doc:`databases_postgresql_mongodb_redis`). Both numbers below are
  the real row counts PostgreSQL reported, not estimates.

Play With It
------------------

.. raw:: html
   :file: _static/normalization_widget.html

The Anomaly, Made Concrete
----------------------------------

Prepare an update to EUR's symbol, uncheck a couple of the eight
countries in the checklist, then click **Apply Update**. Nothing
errors. Nothing warns you. The denormalized table just quietly ends up
with two different symbols for the same currency, and there's no query
against that table alone that can tell you which one is "right." This
is a real, reproduced anomaly -- the exact same partial update, run
against a real PostgreSQL instance for this page, left Netherlands and
Finland showing the old symbol while the other six euro-zone countries
had already moved to the new one.

The normalized side has no equivalent checklist, and that's the actual
point: there's only one row to update, so there's nothing to partially
forget. Denormalization doesn't just make this anomaly *more likely*
-- normalization makes it *structurally impossible*, because the data
that could go out of sync only exists in one place to begin with.

When Each Side Actually Wins
------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 30 35 35

   * - Situation
     - Favors normalization
     - Favors denormalization
   * - How often the shared value changes
     - Frequently (pricing, inventory counts, status flags)
     - Rarely (currency codes, country names, category taxonomies)
   * - Read vs. write ratio
     - Write-heavy, or reads that must always be fresh
     - Read-heavy, where join cost dominates the workload
   * - Consequence of inconsistency
     - Severe (financial data, anything with a real invariant)
     - Tolerable, or caught by other means (denormalized caches,
       search indexes)
   * - Query pattern
     - Ad-hoc queries across many relationships
     - A small number of known, fixed access patterns worth
       pre-flattening for

Real systems frequently take a third option this widget doesn't model
directly: normalize the source of truth, then maintain a denormalized
read-optimized copy alongside it -- a materialized view, a cache, a
search index -- that gets rebuilt or invalidated on write. That gets
the fast reads without ever hand-editing N duplicated rows by hand,
at the cost of needing an explicit invalidation strategy instead.

See Also
-------------

See :doc:`databases_postgresql_mongodb_redis` and
:doc:`db_country_dataset` for the source dataset this page reuses
exactly, including the original "8 of 9 European countries use EUR"
fact this page's update scenario is built around.

See :doc:`db_acid_transaction_interactive` for the other half of this
neighborhood: what happens when a multi-statement write partially
fails, as opposed to this page's question of what happens when a
write that *should* touch several rows only touches some of them on
purpose (or by mistake).
