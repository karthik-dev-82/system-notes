Index vs. Full Scan: Play With It
=====================================

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

     div.document div.admonition {
       background: #f7f6f2;
       border: 1px solid #cdd6cc;
       border-left: 4px solid #a67c1f;
       border-radius: 4px;
       padding: 14px 18px;
       margin: 4px 0 22px;
     }
     div.document div.admonition p.admonition-title {
       font-weight: 700;
       color: #a67c1f;
       margin: 0 0 8px;
       font-size: 0.72rem;
       letter-spacing: 0.06em;
       text-transform: uppercase;
     }
     div.document div.admonition p:last-child { margin-bottom: 0; }
     div.document div.admonition.warning,
     div.document div.admonition.attention,
     div.document div.admonition.caution { border-left-color: #b0432a; }
     div.document div.admonition.warning p.admonition-title,
     div.document div.admonition.attention p.admonition-title,
     div.document div.admonition.caution p.admonition-title { color: #b0432a; }
     div.document div.admonition.tip,
     div.document div.admonition.hint,
     div.document div.admonition.important { border-left-color: #3d5c3d; }
     div.document div.admonition.tip p.admonition-title,
     div.document div.admonition.hint p.admonition-title,
     div.document div.admonition.important p.admonition-title { color: #3d5c3d; }
   </style>

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
