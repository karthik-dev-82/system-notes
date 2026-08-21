Redis Data Structures: Play With It
=======================================

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
