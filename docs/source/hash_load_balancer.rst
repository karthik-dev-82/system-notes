Hash Load Balancer
========================

The Big Idea
------------------

Imagine you have 3 cashiers at a grocery store. Instead of letting
customers pick any line randomly, you use a smart rule:

"Look at the last digit of your phone number. If it's 0-3, go to
cashier 1. If it's 4-6, go to cashier 2. If it's 7-9, go to cashier
3."

Now customers are evenly spread out, *and* the same customer always
goes to the same cashier!

That's hash-based load balancing.

Why Do We Need This?
--------------------------

Problem Without Load Balancing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor "1000 Users" as Users
   cloud "Internet" as Internet
   rectangle "Single Server" as Server #red

   Users -> Internet
   Internet -> Server: ALL traffic goes here!
   note right: Server explodes!

One server can't handle 1000 people at once. It crashes!

Solution 1: Random Load Balancing (Not Hash)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor User1
   actor User2
   actor User3
   rectangle "Load Balancer" as LB
   rectangle "Server A" as SA
   rectangle "Server B" as SB
   rectangle "Server C" as SC

   User1 -> LB: Request #1
   LB -> SA: Go here (random)
   User1 -> LB: Request #2
   LB -> SC: Go here (random, different!)
   note right: Same user, different server
   User2 -> LB
   LB -> SB
   User3 -> LB
   LB -> SA

Problem with random: a user logs into Server A, but their next
request goes to Server B. Server B doesn't know who they are! They
have to log in again. Annoying!

Solution 2: Hash Load Balancing (Smart!)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor "User: alice@email.com" as Alice
   rectangle "Load Balancer\n(Hash Function)" as LB
   rectangle "Server A" as SA #lightgreen
   rectangle "Server B" as SB
   rectangle "Server C" as SC

   Alice -> LB: Request #1\nHash(alice@email.com)
   LB -> LB: Calculate: hash(alice) = 47
   LB -> LB: 47 mod 3 = 2
   LB -> SC: Always go to Server C
   note right: Server C remembers Alice!
   Alice -> LB: Request #2\nHash(alice@email.com)
   LB -> LB: Calculate: hash(alice) = 47
   LB -> LB: 47 mod 3 = 2
   LB -> SC: Same user → Same server!
   note right: Still Server C!

Alice always goes to Server C because her email always produces the
same hash number!

How Hash Load Balancing Works
------------------------------------

Step-by-Step
~~~~~~~~~~~~~~~~

Input: a user identifier (IP address, email, session ID, etc.)

**Step 1 -- hash it:** turn the identifier into a number.

.. code-block:: text

   hash("alice@email.com") = 47
   hash("bob@email.com") = 193
   hash("carol@email.com") = 8

**Step 2 -- modulo magic:** divide by the number of servers, take the
remainder.

.. code-block:: text

   47 mod 3 = 2  → Server C (servers: 0, 1, 2)
   193 mod 3 = 1 → Server B
   8 mod 3 = 2   → Server C

**Step 3 -- route consistently:** same hash = same server, every
time!

The Math (Simple Version)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   Server Number = hash(user_id) % number_of_servers

``%`` means "remainder after division". Examples:

.. code-block:: text

   10 % 3 = 1 (because 10 ÷ 3 = 3 remainder 1)
   47 % 3 = 2 (because 47 ÷ 3 = 15 remainder 2)
   99 % 3 = 0 (because 99 ÷ 3 = 33 remainder 0)

**Analogy:** it's like sorting colored candies into jars. Red candies
*always* go in jar 1, blue in jar 2, green in jar 3. The color (hash)
determines the jar (server).

Real-World Use Case: Shopping Cart
------------------------------------------

The Problem
~~~~~~~~~~~~~~~

You're building Amazon. Users add items to their shopping cart:

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor Alice
   rectangle "Server A" as SA
   rectangle "Server B" as SB
   rectangle "Server C" as SC
   database "Session Data" as Session

   Alice -> SA: Add iPhone to cart
   SA -> Session: Save cart on Server A
   Alice -> SB: Add AirPods to cart
   SB -> SB: Where's Alice's cart?
   note right: Server B doesn't have it!\nIt's on Server A!

Alice's cart is split across multiple servers! Some items look lost!

The Solution: Hash by User ID
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor "Alice\n(User ID: 12345)" as Alice
   rectangle "Load Balancer" as LB
   rectangle "Server A" as SA
   rectangle "Server B" as SB #lightgreen
   rectangle "Server C" as SC

   Alice -> LB: Add iPhone
   LB -> LB: hash(12345) % 3 = 1
   LB -> SB: Route to Server B
   SB -> SB: Save cart
   Alice -> LB: Add AirPods
   LB -> LB: hash(12345) % 3 = 1
   LB -> SB: Same user → Same server B!
   SB -> SB: Update cart
   Alice -> LB: View cart
   LB -> LB: hash(12345) % 3 = 1
   LB -> SB: Same server B again!
   SB -> Alice: Here's your complete cart!

All of Alice's requests go to Server B. Her cart is complete!

The Code (Simplified)
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   import hashlib

   class HashLoadBalancer:
       def __init__(self, servers):
           self.servers = servers  # ['ServerA', 'ServerB', 'ServerC']

       def get_server(self, user_id):
           # Hash the user ID with a *stable* hash function. Python's
           # built-in hash() is randomized per-process for strings
           # (a security feature against hash-flooding attacks), so
           # the same user would land on a different server every
           # time the load balancer restarts -- exactly the problem
           # we're trying to avoid. hashlib.md5 gives the same output
           # every time, on every run, on every machine.
           hash_value = int(hashlib.md5(user_id.encode()).hexdigest(), 16)

           # Use modulo to pick a server
           server_index = hash_value % len(self.servers)

           return self.servers[server_index]

   # Usage
   lb = HashLoadBalancer(['ServerA', 'ServerB', 'ServerC'])

   # Alice always goes to the same server
   print(lb.get_server('alice@email.com'))  # ServerC
   print(lb.get_server('alice@email.com'))  # ServerC (same!)
   print(lb.get_server('alice@email.com'))  # ServerC (same!)

   # Carol goes to a different server, but also consistently
   print(lb.get_server('carol@email.com'))  # ServerB
   print(lb.get_server('carol@email.com'))  # ServerB (same!)

More Real Use Cases
-------------------------

Use Case 1: Multiplayer Game (Chat Rooms)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Problem: players in the same game room need to be on the same server
to see each other's messages.

Solution: hash by room ID!

.. code-block:: python

   lb = HashLoadBalancer(['GameServer1', 'GameServer2', 'GameServer3'])

   # All players in Room 'abc123' go to the same server
   server = lb.get_server('room_abc123')

   # Alice joins room abc123 -> that server
   # Bob joins room abc123   -> same server!
   # Carol joins room abc123 -> same server!
   # They can all see each other because they're on the same server!

Benefit: players in the same room always connect to the same game
server, so they can interact.

Use Case 2: Distributed Cache Routing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Problem: you have 100 servers, each caching database query results.
You don't want every server caching the same thing!

Solution: hash by query!

.. code-block:: python

   # Hash based on the SQL query itself
   cache_server = lb.get_server("SELECT * FROM users WHERE id=5")

   # The same query always checks the same cache server
   # Different queries spread across cache servers

Benefit: better cache hit rate! The same query always checks the same
cache instead of each server keeping its own separate (and mostly
redundant) copy.

Use Case 3: Video Streaming (CDN)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Problem: Netflix has millions of users watching different videos.
Where should each user download from?

Solution: hash by video ID!

.. code-block:: python

   # User wants to watch "Stranger Things Episode 1"
   video_id = "stranger_things_s1e1"
   cdn_server = lb.get_server(video_id)  # e.g. cdn-server-42

   # All users watching the same video get the same CDN server
   # That server caches the video after the first request
   # Other users get fast delivery from cache!

Benefit: popular videos are cached on specific servers. Less bandwidth
used!

The Big Problem: Adding/Removing Servers
------------------------------------------------

The Nightmare Scenario
~~~~~~~~~~~~~~~~~~~~~~~~~~~

You start with 3 servers:

.. code-block:: text

   servers = ['A', 'B', 'C']  # 3 servers
   # Alice's hash = 47
   # 47 % 3 = 2 → Server C

Business is booming! Add a 4th server:

.. code-block:: text

   servers = ['A', 'B', 'C', 'D']  # 4 servers now
   # Alice's hash = 47 (same!)
   # 47 % 4 = 3 → Server D (different!)

Alice's session was on Server C, but now she goes to Server D. She
has to log in again! Her cart is lost!

This is called the "reshuffling problem" -- when you add or remove
servers, most people end up moving to a different server.

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "Before: 3 Servers" as Before {
     rectangle "Server A\n(Users 1,4,7...)" as BA
     rectangle "Server B\n(Users 2,5,8...)" as BB
     rectangle "Server C\n(Users 3,6,9...)" as BC
   }
   rectangle "After: 4 Servers" as After {
     rectangle "Server A\n(Users 1,5,9...)" as AA #pink
     rectangle "Server B\n(Users 2,6,10...)" as AB #pink
     rectangle "Server C\n(Users 3,7,11...)" as AC #pink
     rectangle "Server D\n(Users 4,8,12...)" as AD #lightgreen
   }
   Before -down-> After: Add Server D
   note right: Most people move!\nSessions lost!

Solution: Consistent Hashing (Advanced Topic)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* **Regular (modulo) hashing:** going from 3 to 4 servers reshuffles
  **75%** of users -- every key whose hash didn't already happen to
  agree mod 3 and mod 4 moves to a new server.
* **Consistent hashing:** going from 3 to 4 servers reshuffles only
  about **25%** of users -- exactly the share that the new 4th server
  takes over, and nothing else moves.

**Analogy:** instead of redrawing all the lines when you add a new
checkout lane, you only adjust the people near that new lane.

This is an advanced topic -- just know that consistent hashing solves
the reshuffling problem. (One caveat worth knowing: a naive
consistent-hashing ring, with one point per server, doesn't
automatically give an *even* distribution either -- real
implementations place many "virtual nodes" per physical server around
the ring to smooth that out.)

Comparison Chart
----------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 25 25 25

   * - Type
     - Same User -> Same Server?
     - Even Distribution?
     - Handles Server Changes?
   * - Random
     - No
     - Yes
     - Yes
   * - Round-Robin
     - No
     - Yes
     - Yes
   * - Hash-based
     - Yes
     - Yes
     - No (reshuffles)
   * - Consistent Hash
     - Yes
     - Yes, with virtual nodes
     - Yes (minimal reshuffle)

Quick Decision Guide
--------------------------

**Use hash load balancing when:**

* Users need to maintain session data (shopping carts, logged-in
  state)
* You want cache efficiency (same requests -> same cache)
* The number of servers is relatively stable
* You need predictable routing (same input -> same server)

**Don't use hash load balancing when:**

* You frequently add/remove servers (unless using consistent hashing)
* Servers have different capacities (hash doesn't consider server
  load)
* You need perfect load distribution (one user might generate 1000x
  traffic)

Summary
------------

Hash load balancing is smart grocery-store line assignment. Instead
of randomly picking which server handles your request, we use a
mathematical function (hash) to:

1. Turn your user ID into a number
2. Use that number to always pick the same server
3. Spread users evenly across all servers

The magic: same user -> same hash -> same server, every time!

The catch: adding/removing servers reshuffles everyone, unless you
use consistent hashing.

Real-world wins:

* Shopping carts don't disappear
* Game players stay in the same room
* Cache hits improve
* Users stay logged in
