Databases: The Ultimate Guide for Young Engineers
=======================================================

What's a Database Anyway?
-------------------------------

Think of a database as a super-organized filing system for
information. Just like you might organize your:

* Books by author and genre
* Art supplies by type and color
* Science experiments by date and result

Databases do the same thing, but for computers!

Our Practice Dataset: World Countries
-------------------------------------------

Throughout this guide, we'll use example data about 20 countries from
around the world. Think of it as a digital encyclopedia that includes:

What we know about each country:

* **Demographics:** how many people live there? What languages do
  they speak?
* **Geography:** how big is it? Which continent? What countries
  border it?
* **Economy:** how wealthy? What currency? What do they produce?
* **Capital City:** where is it? What's its population? What
  timezone?

Example countries in our dataset:

* United States (331 million people, Americas region)
* China (1.4 billion people, Asia region)
* Germany (83 million people, Europe region)
* Brazil (212 million people, Americas region)
* And 16 more!

See :doc:`db_country_dataset` for the full table -- all 20 countries,
every field, in one place.

This dataset is useful for learning because it:

* Uses realistic, relatable numbers
* Shows different types of information (numbers, text, lists,
  locations)
* Demonstrates relationships (countries -> capitals, regions ->
  countries)
* Stays the same across all three databases, so you can compare them
  directly

Now let's see how each database type stores this country information
differently...

The Three Database Types: A Kitchen/Restaurant Analogy
-------------------------------------------------------------

Imagine three different types of food establishments, each organized
for different purposes:

PostgreSQL = Professional Kitchen with Recipe Cards
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Everything measured, organized by station, recipes cross-reference
ingredients.

.. uml::

   !theme plain
   package "Professional Kitchen (PostgreSQL)" #LightGreen {
     rectangle "Recipe Cards Station\nCountries Table" as countries #GreenYellow
     rectangle "Ingredients Station\nCapitals Table" as capitals #GreenYellow

     countries -down-> capitals : Recipe references\ningredients list
   }
   note right of capitals #LightBlue
     Kitchen Rules:
     Every ingredient must
     belong to a valid recipe
   end note
   note bottom of countries #LightSalmon
     Contains: ID, Name,
     Population, Region
   end note
   note bottom of capitals #LightSalmon
     Contains: ID, Country_ID,
     Name, Population
   end note

Why it's like a professional kitchen:

* Every ingredient (data) has a precise measurement and location
* Recipe cards (indexes) help chefs find things instantly
* Strict food safety rules (constraints) about what goes where
* Different stations work together (joins) to create the final dish
* If one step fails, the whole dish is remade (transactions)

Real-world example with our data:

.. code-block:: sql

   -- Find all Asian countries and their capitals
   SELECT countries.name, countries.population, capitals.name AS capital
   FROM countries
   JOIN capitals ON countries.id = capitals.country_id
   WHERE countries.region = 'Asia';

MongoDB = Food Truck Menu
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each dish is complete on its own, flexible daily specials.

.. uml::

   !theme plain
   package "Food Truck (MongoDB)" #LightBlue {
     rectangle "USA Special Board" as usa #GreenYellow
     rectangle "Japan Special Board" as japan #GreenYellow
   }
   note right of usa #LightSalmon
     Country: USA
     Population: 331M
     Region: Americas
     Capital: Washington DC
     Languages: English, Spanish
   end note
   note right of japan #LightSalmon
     Country: Japan
     Population: 126M
     Region: Asia
     Capital: Tokyo
     Extra: Island nation
   end note

Why it's like a food truck:

* Each menu board tells you everything about one dish
* No two dishes need the same recipe format
* Easy to add new ingredients or change the dish daily
* Self-contained -- you don't need to check multiple stations
* Great for creative, flexible menus that change often

Real-world example with our data:

.. code-block:: json

   // One document = one complete "dish" (country)
   {
     "name": "Germany",
     "demographics": {
       "population": 83000000,
       "languages": ["German", "Turkish", "Kurdish"]
     },
     "capital": {
       "name": "Berlin",
       "population": 3600000
     },
     "economy": {
       "currency": "EUR",
       "major_industries": ["Automotive", "Engineering", "Chemicals"]
     }
   }

Redis = Fast Food Counter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Everything's in quick-grab bins, optimized for speed, popular items
ready.

.. uml::

   !theme plain
   package "Fast Food Counter (Redis)" #LightSalmon {
     rectangle "Quick-Grab Bins" as bins #GreenYellow
     rectangle "Customer Leaderboard" as leaderboard #GreenYellow
     rectangle "Combo Meals" as combos #GreenYellow
   }
   note right of bins #LightBlue
     USA: pop=331M
     Japan: pop=126M
     Germany: pop=83M
   end note
   note right of leaderboard #LightBlue
     1. China (1.4B)
     2. India (1.4B)
     3. USA (331M)
     4. Japan (126M)
   end note
   note right of combos #LightBlue
     Americas: USA, Brazil
     Asia: China, Japan
     Europe: Germany, France
   end note

Why it's like a fast food counter:

* Everything designed for speed -- customers want food *now*
* Popular items kept ready in warming trays (cache)
* Simple menu boards show rankings and combos instantly
* Items expire (TTL) if they sit too long
* Great for high-volume, quick service

Real-world example with our data:

.. code-block:: text

   # Instant lookup - like grabbing a burger
   HGET country:US population  # -> 331000000 (in <1 millisecond!)

   # Check the popularity leaderboard
   ZREVRANGE population_ranking 0 4  # -> Top 5 countries instantly

   # Is Germany in the Europe combo?
   SISMEMBER region:Europe DE  # -> YES! (instant answer)

Quick Comparison Table
------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 18 27 27 28

   * - Aspect
     - Professional Kitchen (PostgreSQL)
     - Food Truck (MongoDB)
     - Fast Food (Redis)
   * - Organization
     - Separate stations, strict recipes
     - Complete dishes on boards
     - Quick-grab bins
   * - Flexibility
     - Fixed recipes
     - Daily specials vary
     - Limited menu
   * - Speed
     - Takes time to plate (10-50ms)
     - Moderate (5-20ms)
     - Lightning fast (<1ms)
   * - Best For
     - Complex multi-course meals
     - Creative, flexible dishes
     - Popular items, quick service
   * - Our Data Example
     - Countries + Capitals tables
     - Complete country documents
     - Country lookups + rankings

How Data is Organized: The Kitchen Systems Analogy
-----------------------------------------------------------

PostgreSQL: Like a Michelin-Star Kitchen (Precise & Planned)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In a professional kitchen, everything is organized in stations that
work together:

.. uml::

   !theme plain
   entity "Countries Table\n(Main Recipes)" as countries #LightGreen {
     * id : number (PK)
     --
     name : text
     population : number
     region : text
     currency_code : text
   }
   entity "Capitals Table\n(Special Ingredients)" as capitals #LightBlue {
     * id : number (PK)
     --
     * country_id : number (FK)
     name : text
     population : number
     latitude : number
     longitude : number
   }
   countries ||--o{ capitals : "country owns\ncapital"
   note right of capitals #LightSalmon
     Foreign Key (FK):
     Like a recipe instruction that says
     "Use ingredients from Container #5"
     It points to another table!
   end note
   note left of countries #GreenYellow
     Primary Key (PK):
     Like a unique container number
     No two containers can have
     the same ID
   end note

Key concepts (kitchen translation):

* **Primary Key (PK):** the container number -- each recipe has a
  unique ID
* **Foreign Key (FK):** a reference note saying "use ingredients from
  container #5"
* **Index:** like labels on shelves -- helps find ingredients fast
* **View:** a combined menu showing dishes with their full ingredient
  lists
* **Transaction:** either the whole dish succeeds or gets thrown out
  -- no half-cooked meals!

Real example from our dataset:

.. code-block:: text

   -- Countries table (20 recipes)
   id | name    | population | region   | currency_code
   1  | USA     | 331900000  | Americas | USD
   2  | China   | 1439323776 | Asia     | CNY
   3  | Germany | 83000000   | Europe   | EUR

   -- Capitals table (20 special ingredients, each linked to a country)
   id | country_id | name          | population
   1  | 1          | Washington DC | 692683
   2  | 2          | Beijing       | 21540000
   3  | 3          | Berlin        | 3600000

MongoDB: Like a Food Truck Menu (Flexible & Complete)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each menu board shows a *complete* dish with all its components:

.. code-block:: json

   {
     "name": "United States",
     "iso_code": "US",

     "capital": {
       "name": "Washington D.C.",
       "coordinates": {"lat": 38.9, "lng": -77.0},
       "population": 692683,
       "timezone": "America/New_York"
     },

     "demographics": {
       "population": 331900000,
       "primary_language": "English",
       "languages": ["English", "Spanish", "Chinese"]
     },

     "geography": {
       "area_km2": 9833517.00,
       "region": "Americas",
       "borders": ["CA", "MX"]
     },

     "economy": {
       "currency": {"code": "USD", "name": "US Dollar"},
       "gdp_per_capita": 65298.73,
       "major_industries": ["Technology", "Finance", "Healthcare"]
     }
   }

Think of it like:

* Each country is a complete menu board describing one special dish
* You can add new ingredients (fields) to any dish without changing
  others
* No need to check multiple stations -- everything's on one board
* Perfect for when each "dish" (country) is unique

Real structure from our dataset:

* 20 complete documents (one per country)
* Each includes demographics, geography, economy, and capital -- all
  nested inside
* Capital info is embedded (not in a separate collection)
* Arrays store lists: languages, borders, industries

Redis: Like a Fast Food Counter (Speed-Optimized Bins)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Everything organized in quick-access structures for instant service:

**Bins (Hashes) -- quick facts:**

.. code-block:: text

   country:US -> {name: "USA", pop: 331000000, capital: "DC", region: "Americas"}
   country:CN -> {name: "China", pop: 1439323776, capital: "Beijing", region: "Asia"}
   country:DE -> {name: "Germany", pop: 83000000, capital: "Berlin", region: "Europe"}

**Leaderboard (sorted set) -- rankings by score:**

.. code-block:: text

   population_ranking -> [CN: 1439323776, IN: 1380004385, US: 331900000, ...]
   gdp_ranking -> [CH: 81867.46, NO: 75420.35, US: 65298.73, ...]

**Combos (sets) -- groupings:**

.. code-block:: text

   region:Europe -> {DE, GB, FR, IT, ES, NL}
   region:Asia -> {CN, JP, IN, ID, PK, BD, VN, TH}
   language:English -> {US, GB, CA, AU, IN}
   currency:EUR -> {DE, FR, IT, ES, NL, AT, BE, FI}

**Queue (list) -- ordered items:**

.. code-block:: text

   capitals:all -> ["Washington D.C.", "Beijing", "Tokyo", "Delhi", ...]

**Cached values (strings with expiration):**

.. code-block:: text

   stats:total_countries -> "20"
   cache:euro_countries_count -> "10" (expires in 1 hour)

Think of it like:

* **Hashes:** quick-grab bins with country facts
* **Sorted Sets:** popularity rankings (updated in real-time)
* **Sets:** meal combos (Europe combo, Asia combo, etc.)
* **Lists:** order queues (first in, first out)
* **TTL (Time To Live):** like food that expires -- cached data
  auto-deletes

See :doc:`db_redis_structures_interactive` to run hashes, sorted
sets, sets, and a TTL cache yourself against the live country data --
including watching a key actually expire and confirming it never
comes back.

When to Use Each Database
--------------------------------

.. uml::

   !theme plain
   start
   :Need to store data?;
   if (Need SUPER SPEED?) then (yes)
     :Use REDIS;<<#LightSalmon>>
     note right
       Examples:
       - Game leaderboards
       - Shopping cart
       - Recently viewed items
     end note
     stop
   else (no)
     if (Data has lots of\nconnections?) then (yes)
       :Use POSTGRESQL;<<#LightGreen>>
       note right
         Examples:
         - School records
         - Banking systems
         - Social networks
       end note
       stop
     else (no)
       :Use MONGODB;<<#GreenYellow>>
       note right
         Examples:
         - Blog posts
         - Product catalogs
         - User profiles
       end note
       stop
     endif
   endif

Real-World Examples Using Our Country Data
--------------------------------------------------

Example 1: Finding Countries by Region (Professional Kitchen)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**The scenario:** a chef needs to make dishes from all European
countries. That means combining data from *both* stations shown
earlier -- ``countries`` and ``capitals`` -- via a ``JOIN``.

.. code-block:: sql

   -- PostgreSQL query (combining two stations)
   SELECT
       c.name AS country,
       c.population AS country_pop,
       cap.name AS capital,
       cap.population AS capital_pop
   FROM countries c
   JOIN capitals cap ON c.id = cap.country_id
   WHERE c.region = 'Europe'
   ORDER BY c.population DESC;

   -- Results from our dataset:
   -- Germany (83M) -> Berlin (3.6M)
   -- United Kingdom (68M) -> London (9M)
   -- France (65M) -> Paris (2.2M)
   -- Italy (60M) -> Rome (2.8M)

Why PostgreSQL? Countries take an ingredient (the capital) from a
separate station, so the query needs to cross-reference stations
(``JOIN``) -- and the foreign key means there's no risk of a capital
with no matching country.

Example 2: Complete Country Profile (Food Truck)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**The scenario:** a customer wants to know everything about Japan --
all on one menu board!

.. code-block:: json

   {
     "name": "Japan",
     "iso_code": "JP",

     "capital": {
       "name": "Tokyo",
       "coordinates": {"lat": 35.6, "lng": 139.7},
       "population": 14000000,
       "timezone": "Asia/Tokyo"
     },

     "demographics": {
       "population": 126000000,
       "primary_language": "Japanese",
       "languages": ["Japanese"]
     },

     "geography": {
       "area_km2": 377975.00,
       "region": "Asia",
       "subregion": "Eastern Asia",
       "borders": [],
       "coastline_km": 29751
     },

     "economy": {
       "currency": {"code": "JPY", "name": "Japanese Yen"},
       "gdp_per_capita": 42928.92,
       "major_industries": ["Automotive", "Electronics", "Robotics"]
     }
   }

.. code-block:: javascript

   // Simple query - grab the whole menu board!
   db.countries.findOne({ name: "Japan" })

   // Or find all Asian countries with their complete info
   db.countries.find({ "geography.region": "Asia" })

Why MongoDB? Everything about Japan is on one menu board -- easy to
grab and display the complete "dish" with no need to visit multiple
stations. Perfect for APIs that return complete objects.

Example 3: Population Rankings (Fast Food Counter)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**The scenario:** show me the top 5 most populous countries
*instantly*!

.. code-block:: text

   # Redis query (instant!)
   ZREVRANGE population_ranking 0 4 WITHSCORES

   # Results (in milliseconds!):
   1. China -> 1,439,323,776
   2. India -> 1,380,004,385
   3. United States -> 331,900,000
   4. Indonesia -> 273,500,000
   5. Pakistan -> 220,900,000

   # What's USA's rank?
   ZREVRANK population_ranking US
   # Answer: 2 (3rd place, 0-indexed)

   # Countries with population between 100M-500M?
   ZRANGEBYSCORE population_ranking 100000000 500000000
   # -> [Pakistan, Indonesia, USA, ...]

Why Redis? The leaderboard is pre-computed and ready to serve -- no
calculation needed at query time. Perfect for dashboards and
real-time displays, with sub-millisecond response time.

Example 4: Currency Analysis (Combining Stations vs Complete Boards)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**PostgreSQL way (Professional Kitchen):**

.. code-block:: sql

   -- Count countries per currency (needs aggregation)
   SELECT
       currency_code,
       COUNT(*) as country_count,
       AVG(gdp_per_capita) as avg_gdp
   FROM countries
   GROUP BY currency_code
   ORDER BY country_count DESC;

   -- Results:
   -- EUR -> 8 countries (Germany, France, Italy, Spain, etc.)
   -- USD -> 1 country (United States)

**MongoDB way (Food Truck):**

.. code-block:: javascript

   // Aggregation pipeline - like preparing a combo meal
   db.countries.aggregate([
     {
       $group: {
         _id: "$economy.currency.code",
         countries: { $push: "$name" },
         count: { $sum: 1 },
         avg_gdp: { $avg: "$economy.gdp_per_capita" }
       }
     },
     { $sort: { count: -1 } }
   ])
   // Results show complete country lists per currency

**Redis way (Fast Food Counter):**

.. code-block:: text

   # Pre-built currency combos
   SMEMBERS currency:EUR
   # -> {DE, FR, IT, ES, NL, AT, BE, FI}

   SCARD currency:EUR
   # -> 8 (count instantly!)

   # Is Germany in the EUR combo?
   SISMEMBER currency:EUR DE
   # -> 1 (yes!)

ACID vs Speed vs Flexibility: The Trade-offs
------------------------------------------------------

Think about different types of food service and what they prioritize:

.. uml::

   !theme plain
   rectangle "Michelin Restaurant\n(PostgreSQL)" as pg #LightGreen {
     note
       1. Check ingredients
       2. Reserve ingredients
       3. Cook dish
       4. Plate beautifully
       ..
       ALL steps must succeed!
       If any fails, undo everything
     end note
   }
   rectangle "Food Truck\n(MongoDB)" as mongo #LightBlue {
     note
       Serve custom orders quickly
       Flexible recipes
       ..
       Speed & Flexibility wins!
     end note
   }
   rectangle "Fast Food Counter\n(Redis)" as redis #LightSalmon {
     note
       Grab from warming tray
       Serve in seconds
       ..
       SPEED IS EVERYTHING!
     end note
   }

Understanding ACID (Professional Kitchen Rules)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ACID is the set of rules a Michelin-star kitchen follows:

* **Atomicity** = all or nothing cooking. Either the *whole* dish
  succeeds, or you start over. Example: if you burn the sauce, throw
  out the whole plate, don't serve it half-done.
* **Consistency** = correct recipes always followed. Every dish
  follows food safety rules. Example: chicken must reach 165F -- no
  exceptions.
* **Isolation** = independent chef stations. Two chefs can work
  simultaneously without interfering. Example: Chef A making pasta
  doesn't mess up Chef B's steak.
* **Durability** = dishes survive kitchen crashes. Once a dish is
  served, the order is permanently recorded. Example: even if the
  kitchen catches fire, the receipt shows what you ordered.

Real example with our data:

.. code-block:: sql

   -- Add a new country and its capital together (must both succeed!)
   BEGIN TRANSACTION;
     INSERT INTO countries (id, name, population, region, currency_code)
       VALUES (21, 'Kenya', 53800000, 'Africa', 'KES');
     INSERT INTO capitals (id, country_id, name, population)
       VALUES (21, 21, 'Nairobi', 4397073);
   COMMIT;

   -- If EITHER insert fails, BOTH are cancelled!
   -- No capital left pointing at a country that doesn't exist.

See :doc:`db_acid_transaction_interactive` to run this exact Kenya +
Nairobi example yourself -- force the capital insert to fail on
purpose, with and without the transaction, and watch what's left
behind either way.

Flexibility Over Perfection (Food Truck Style)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

MongoDB is like a creative food truck:

* Recipes can vary (flexible schema)
* Quick to adapt the menu (no strict rules)
* Sometimes takes a moment to update the menu board (replica lag, if
  you're reading from a secondary)
* Great for rapid changes and experimentation

Trade-off: speed and flexibility vs. strict, enforced structure.

Speed Over Everything (Fast Food)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Redis is like a fast food counter:

* Everything in memory (warming trays) for instant access
* Pre-computed rankings (leaderboards ready to display)
* Items might expire (TTL) if they sit too long
* If power goes out, some data could be lost (unless saved to disk)

Trade-off: ultimate speed vs. some data-persistence risk.

The Index Magic Trick (Finding Ingredients Fast!)
------------------------------------------------------------

Imagine you're a chef looking for paprika in a huge warehouse kitchen:

**Without an index (no labels on shelves):**

.. uml::

   !theme plain
   rectangle "Warehouse Kitchen with 10,000 ingredient bins" {
     actor "Chef" as chef
     rectangle "Bin 1: Salt" as p1
     rectangle "Bin 2: Pepper" as p2
     rectangle "..." as dots
     rectangle "Bin 9,999: Cumin" as p9999
     rectangle "Bin 10,000: Paprika" as paprika #LightGreen

     chef -down-> p1 : "Check bin 1..."
     p1 -down-> p2 : "Not here..."
     p2 -down-> dots : "Keep looking..."
     dots -down-> p9999 : "Still searching..."
     p9999 -down-> paprika : "Finally found!"
   }
   note bottom
     Checked ALL 10,000 bins!
     Takes 30 minutes!
     Chef is exhausted!
   end note

**With an index (alphabetical shelf labels):**

.. uml::

   !theme plain
   actor "Chef" as chef
   rectangle "Spice Directory" as map #GreenYellow
   rectangle "Paprika\nAisle 4" as paprika #LightGreen
   chef -down-> map : Looking for\nPaprika
   map -down-> paprika : Found instantly!
   note right of map #LightBlue
     A-C: Aisle 1
     D-K: Aisle 2
     L-O: Aisle 3
     P-R: Aisle 4
     S-Z: Aisle 5
   end note
   note bottom of paprika #LightSalmon
     Checked ONLY Aisle 4
     Found in 30 seconds!
   end note

How Indexes Work in Our Database
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: sql

   -- Without index: scans all 20 countries (slow)
   SELECT * FROM countries WHERE region = 'Europe';

   -- Create an index (like adding shelf labels)
   CREATE INDEX idx_countries_region ON countries(region);

   -- Now queries are instant! Goes straight to the "Europe shelf"
   SELECT * FROM countries WHERE region = 'Europe';
   -- 25x faster!

The trade-off:

* Finding ingredients is much faster (``SELECT`` queries)
* Organizing takes time when adding new items (``INSERT``/``UPDATE``
  slower)
* Takes up storage space (like having a directory book)

Kitchen analogy: an index is the alphabetical directory on the wall.
Without one, you're searching every bin one by one. The directory
helps you find things fast, but you have to keep it updated whenever
items move.

See :doc:`db_index_scan_interactive` to run this exact trade-off
yourself against the live 20-country dataset -- same query, both
ways, with the real step counts side by side.

Types of Indexes in Our Dataset
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: sql

   -- Our PostgreSQL database has these "directories":
   CREATE INDEX idx_countries_region ON countries(region);
   -- -> Quick lookup: "All Asian countries"

   CREATE INDEX idx_countries_population ON countries(population);
   -- -> Quick lookup: "Countries with >100M people"

   CREATE INDEX idx_countries_gdp ON countries(gdp_per_capita);
   -- -> Quick lookup: "Wealthiest countries"

Real-world performance:

* Without indexes: find all European countries -> 50ms
* With indexes: find all European countries -> 2ms
* That's 25x faster!

Query Examples (Like Asking Questions)
--------------------------------------------

PostgreSQL: Structured Questions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: sql

   -- "Show me all European countries with over 50 million people,
   --  sorted by population"
   SELECT name, population, capital
   FROM countries
   WHERE region = 'Europe'
     AND population > 50000000
   ORDER BY population DESC;

Think of it like:

* ``SELECT`` = "I want to know about..."
* ``FROM`` = "Look in this section..."
* ``WHERE`` = "But only if..."
* ``ORDER BY`` = "Sort them by..."

MongoDB: Flexible Questions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: javascript

   // "Find all Asian countries, and for each one,
   //  show me all their languages"
   db.countries.find(
     { 'geography.region': 'Asia' },
     { name: 1, 'demographics.languages': 1 }
   )

Think of it like: the first ``{}`` is "where to look" (the filter),
and the second ``{}`` is "what to show me" (the fields).

Redis: Lightning Questions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   # "What's the USA's rank in population?"
   ZREVRANK population_ranking US
   # Answer: 2 (3rd place, 0-indexed)

   # "Is Germany in Europe?"
   SISMEMBER region:Europe DE
   # Answer: 1 (yes!)

   # "Get Japan's GDP instantly"
   HGET country:JP gdp_per_capita
   # Answer: 42928.92 (in milliseconds!)

The Performance Olympics
------------------------------

.. uml::

   !theme plain
   participant "PostgreSQL\n(The Analyst)" as pg #LightGreen
   participant "MongoDB\n(The Flexible Athlete)" as mongo #LightBlue
   participant "Redis\n(The Sprinter)" as redis #LightSalmon

   == Simple Lookup ==
   pg -> pg : 10-50ms\n(Need to join tables)
   mongo -> mongo : 5-20ms\n(Grab document)
   redis -> redis : <1ms\nINSTANT!

   == Complex Analysis ==
   pg -> pg : Fast!\n(Built for this)
   mongo -> mongo : OK\n(Aggregation pipeline)
   redis -> redis : Not ideal\n(Keep it simple)

   == Flexibility ==
   pg -> pg : Rigid\n(Schema required)
   mongo -> mongo : Super flexible!\n(Any structure)
   redis -> redis : Simple structures\n(Speed focus)

Learning Path: Level Up Your Database Skills!
------------------------------------------------------

.. uml::

   !theme plain
   start
   :Level 1: Beginner Explorer;<<#GreenYellow>>
   note right
     Learn basic queries
     - SELECT, find(), GET
   end note
   :Level 2: Data Detective;<<#LightGreen>>
   note right
     Master filtering
     - WHERE, conditions
     - Pattern matching
   end note
   :Level 3: Relationship Mapper;<<#LightBlue>>
   note right
     Understand connections
     - JOINs, nested docs
     - References
   end note
   :Level 4: Speed Racer;<<#LightSalmon>>
   note right
     Optimize performance
     - Indexes
     - Query plans
   end note
   :Level 5: Architecture Wizard;<<#LightGreen>>
   note right
     Choose the right tool
     - Design patterns
     - Trade-offs
   end note
   stop

Practice Challenges with Our Country Data!
--------------------------------------------------

Challenge 1: The Region Counter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Question:** how many countries are in each region? Think: like
counting dishes on each menu section.

**PostgreSQL (Professional Kitchen):**

.. code-block:: sql

   SELECT region, COUNT(*) as country_count
   FROM countries
   GROUP BY region
   ORDER BY country_count DESC;

   -- Expected results from our 20-country dataset:
   -- Asia: 8 countries
   -- Europe: 6 countries
   -- Americas: 4 countries
   -- Africa: 2 countries

**MongoDB (Food Truck):**

.. code-block:: javascript

   db.countries.aggregate([
     {
       $group: {
         _id: "$geography.region",
         count: { $sum: 1 },
         countries: { $push: "$name" }
       }
     },
     { $sort: { count: -1 } }
   ])

**Redis (Fast Food Counter):**

.. code-block:: text

   # If pre-built combos exist:
   SCARD region:Asia     # -> 8
   SCARD region:Europe   # -> 6
   SMEMBERS region:Asia  # -> [CN, JP, IN, ID, PK, BD, VN, TH]

Challenge 2: The Population Detective
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Question:** find all countries with more people than Japan (126M).
Think: which dishes serve more portions than the "Japan special"?

**PostgreSQL:**

.. code-block:: sql

   SELECT name, population
   FROM countries
   WHERE population > 126000000
   ORDER BY population DESC;

   -- Answer: China, India, USA, Indonesia, Pakistan, Brazil

**MongoDB:**

.. code-block:: javascript

   db.countries.find(
     { "demographics.population": { $gt: 126000000 } },
     { name: 1, "demographics.population": 1 }
   ).sort({ "demographics.population": -1 })

**Redis:**

.. code-block:: text

   ZRANGEBYSCORE population_ranking 126000000 +inf

Challenge 3: The Capital Finder
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Question:** show all European countries with their capitals. Think:
list the European menu items with their special ingredients.

**PostgreSQL (best for this!):**

.. code-block:: sql

   SELECT
       c.name AS country,
       c.population,
       cap.name AS capital,
       cap.population AS capital_pop
   FROM countries c
   JOIN capitals cap ON c.id = cap.country_id
   WHERE c.region = 'Europe'
   ORDER BY c.population DESC;

**MongoDB (also good!):**

.. code-block:: javascript

   db.countries.find(
     { "geography.region": "Europe" },
     {
       name: 1,
       "demographics.population": 1,
       "capital.name": 1,
       "capital.population": 1
     }
   ).sort({ "demographics.population": -1 })

Challenge 4: The Currency Counter
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Question:** which currency is used by the most countries? Think:
which payment method do most restaurants accept?

**PostgreSQL:**

.. code-block:: sql

   SELECT
       currency_code,
       COUNT(*) as country_count
   FROM countries
   GROUP BY currency_code
   ORDER BY country_count DESC
   LIMIT 3;

   -- Answer: EUR used by 8+ countries (Germany, France, Italy, Spain...)

**MongoDB:**

.. code-block:: javascript

   db.countries.aggregate([
     {
       $group: {
         _id: "$economy.currency.code",
         count: { $sum: 1 },
         countries: { $push: "$name" }
       }
     },
     { $sort: { count: -1 } },
     { $limit: 3 }
   ])

Challenge 5: Top GDP Countries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Question:** which 5 countries have the highest GDP per capita?
Think: which are the most expensive restaurants?

**PostgreSQL:**

.. code-block:: sql

   SELECT name, gdp_per_capita, currency_code
   FROM countries
   ORDER BY gdp_per_capita DESC
   LIMIT 5;

**MongoDB:**

.. code-block:: javascript

   db.countries.find(
     {},
     { name: 1, "economy.gdp_per_capita": 1, "economy.currency.code": 1 }
   ).sort({ "economy.gdp_per_capita": -1 }).limit(5)

**Redis (best for leaderboards!):**

.. code-block:: text

   # Top 5 instantly!
   ZREVRANGE gdp_ranking 0 4 WITHSCORES

Memory Tricks
------------------

Remember the database types:

* **PostgreSQL** = professional kitchen (precise recipes, everything
  measured)
* **MongoDB** = mobile food truck (menu boards, flexible daily
  specials)
* **Redis** = restaurant express counter (ready-to-serve, lightning
  fast)

Remember ACID:

* **Atomicity** = all ingredients or throw out the dish (complete or
  nothing)
* **Consistency** = chef follows food safety rules (always valid)
* **Isolation** = independent chef stations (no interference)
* **Durability** = dishes survive kitchen fires (permanent records)

Quick Reference Card
--------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 30 20 50

   * - Need
     - Use
     - Because
   * - Banking, financial transactions
     - PostgreSQL
     - Money must be exact (ACID)
   * - Blog posts, product catalogs
     - MongoDB
     - Flexible content, complete objects
   * - Leaderboards, session data
     - Redis
     - Need it now (sub-millisecond)
   * - Reports, complex analytics
     - PostgreSQL
     - Multi-table joins, aggregations
   * - API responses
     - MongoDB
     - Return complete documents
   * - Cached data, counters
     - Redis
     - Temporary, ultra-fast access

You're Ready to Explore!
------------------------------

Now you know:

* Three main database types (professional kitchen, food truck, fast
  food counter)
* When to use each one for your country data
* How data is organized (tables vs. documents vs. key-value)
* Basic queries for each database
* Trade-offs (speed vs. safety vs. flexibility)
* Real examples with a 20-country dataset

Next steps:

1. Start the databases: ``./start_databases.sh``
2. Connect and explore: ``./connect_databases.sh``
3. Try the practice challenges above
4. Experiment! Break things! Learn!
5. Compare how each database handles the same data

Quick test yourself:

* Need to find all European countries with capitals? -> PostgreSQL
  (``JOIN`` tables)
* Need complete info about one country instantly? -> MongoDB (one
  document)
* Need top 5 most populous countries ranked? -> Redis (sorted set,
  instant!)

**Remember:** every database is a kitchen tool. Just like you wouldn't
use a whisk for everything, you pick the right database for each job!
