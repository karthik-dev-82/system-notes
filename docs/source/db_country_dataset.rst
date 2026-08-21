The 20-Country Dataset
==========================

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

This is the exact dataset used throughout
:doc:`databases_postgresql_mongodb_redis` and its three interactive
companions (:doc:`db_index_scan_interactive`,
:doc:`db_redis_structures_interactive`,
:doc:`db_acid_transaction_interactive`) -- the same 20 countries, the
same numbers, every time, so results are directly comparable across
all four pages. It's reproduced here in full, since the guide itself
only ever shows a handful of rows at a time.

Fields
----------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 15 20 65

   * - Field
     - Type
     - What it means
   * - ``id``
     - integer
     - The row's primary key -- what a capital or any other related
       row would use to join back to this country.
   * - ``name``
     - text
     - The country's common English name.
   * - ``iso2``
     - text
     - The two-letter ISO 3166-1 country code (``US``, ``DE``, ``JP``).
   * - ``region``
     - text
     - One of ``Asia``, ``Europe``, or ``Americas`` in this dataset --
       the field the index-vs-scan widget filters on.
   * - ``population``
     - integer
     - Total population, most recent estimate available when this
       dataset was put together.
   * - ``gdpPerCapita``
     - number
     - GDP per capita in current US dollars -- a rough, unadjusted
       figure, not a precise or inflation-adjusted one.
   * - ``currency``
     - text
     - ISO 4217 currency code (``EUR``, ``USD``, ``JPY``) -- the field
       the Redis widget groups and intersects on.
   * - ``capital``
     - text
     - The capital city's name. The ACID widget models this as a
       separate ``capitals`` table with a foreign key back to
       ``id``, rather than a plain column, to demonstrate a real
       insert-two-related-rows transaction.

The Full Dataset
--------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 6 16 8 12 14 12 10 16

   * - id
     - name
     - iso2
     - region
     - population
     - gdpPerCapita
     - currency
     - capital
   * - 1
     - China
     - CN
     - Asia
     - 1,439,323,776
     - $12,556
     - CNY
     - Beijing
   * - 2
     - Japan
     - JP
     - Asia
     - 126,000,000
     - $42,928.92
     - JPY
     - Tokyo
   * - 3
     - India
     - IN
     - Asia
     - 1,380,004,385
     - $2,100
     - INR
     - New Delhi
   * - 4
     - Indonesia
     - ID
     - Asia
     - 273,500,000
     - $4,292
     - IDR
     - Jakarta
   * - 5
     - Pakistan
     - PK
     - Asia
     - 220,900,000
     - $1,543
     - PKR
     - Islamabad
   * - 6
     - Bangladesh
     - BD
     - Asia
     - 171,000,000
     - $2,600
     - BDT
     - Dhaka
   * - 7
     - Vietnam
     - VN
     - Asia
     - 98,000,000
     - $4,300
     - VND
     - Hanoi
   * - 8
     - Germany
     - DE
     - Europe
     - 83,000,000
     - $48,000
     - EUR
     - Berlin
   * - 9
     - France
     - FR
     - Europe
     - 65,000,000
     - $40,000
     - EUR
     - Paris
   * - 10
     - Italy
     - IT
     - Europe
     - 60,000,000
     - $34,000
     - EUR
     - Rome
   * - 11
     - Spain
     - ES
     - Europe
     - 47,000,000
     - $27,000
     - EUR
     - Madrid
   * - 12
     - Netherlands
     - NL
     - Europe
     - 17,500,000
     - $55,000
     - EUR
     - Amsterdam
   * - 13
     - Austria
     - AT
     - Europe
     - 9,000,000
     - $50,000
     - EUR
     - Vienna
   * - 14
     - Belgium
     - BE
     - Europe
     - 11,600,000
     - $46,000
     - EUR
     - Brussels
   * - 15
     - Finland
     - FI
     - Europe
     - 5,500,000
     - $48,000
     - EUR
     - Helsinki
   * - 16
     - United Kingdom
     - GB
     - Europe
     - 68,000,000
     - $41,000
     - GBP
     - London
   * - 17
     - United States
     - US
     - Americas
     - 331,900,000
     - $65,298.73
     - USD
     - Washington D.C.
   * - 18
     - Canada
     - CA
     - Americas
     - 38,000,000
     - $52,000
     - CAD
     - Ottawa
   * - 19
     - Mexico
     - MX
     - Americas
     - 128,900,000
     - $10,000
     - MXN
     - Mexico City
   * - 20
     - Brazil
     - BR
     - Americas
     - 212,000,000
     - $8,900
     - BRL
     - Brasília

Worth Noting
----------------

Europe has 9 countries in this dataset, 8 of which use the euro --
the United Kingdom is the one exception, still ``GBP``. It's easy to
misremember this as "Europe = EUR"; this table is the place to check
that assumption against the actual data.
