The 20-Country Dataset
==========================

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
