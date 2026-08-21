Normalization vs. Denormalization: Play With It
======================================================

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
