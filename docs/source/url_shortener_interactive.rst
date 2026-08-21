Designing a URL Shortener: A System Design Case Study
=============================================================

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

This page is a synthesis, not a new mechanism -- it walks through the
classic "design a URL shortener" interview question end to end, and at
every real design decision it points at (or drops in) the actual
interactive demo already built elsewhere on this site for that piece.
Nothing here contradicts those pages; this is the connective tissue
between them.

The Problem
-----------------

**Functional requirements:** given a long URL, return a short one
(``https://short.ly/aB3xQ1``); given a short URL, redirect to the
original long URL. Optionally let a user pick a custom alias instead
of an auto-generated code.

**Non-functional requirements, and why they shape everything below:**

* **Reads vastly outnumber writes.** Most short links get clicked many
  times after being created once. A commonly used interview assumption
  is a **100:1 read:write ratio** -- used throughout this page's
  numbers below -- which is precisely why caching (not sharding, not
  consensus) is the single highest-leverage piece of this system.
* **A redirect has to be fast.** Nobody tolerates a slow bounce through
  a shortener on the way to the page they actually wanted.
* **Short codes must never collide.** Two different long URLs must
  never resolve from the same short code -- see :doc:`bloom_filter_interactive`-
  adjacent territory: this is the same "avoid a false positive" shape
  of problem as a bloom filter, but with a *correctness* consequence
  instead of a false-positive-rate tradeoff, so it can't be
  probabilistic.

**A worked capacity estimate** (assumptions stated explicitly, numbers
computed from them, not eyeballed):

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Assumption
     - Value
   * - New short URLs created per month
     - 100,000,000
   * - Average write throughput
     - 100,000,000 / (30 x 86,400 s) ≈ **38.6 writes/sec**
   * - Read:write ratio
     - 100:1
   * - Average read throughput
     - 38.6 x 100 ≈ **3,858 reads/sec**
   * - Records after 5 years
     - 100M/month x 12 x 5 = **6.0 billion**
   * - Storage at ~500 bytes/record
     - 6.0B x 500 B ≈ **3.0 TB**

That 6-billion-record figure is what the short-code length actually
has to be sized against -- not guessed, checked: base62 with *n*
characters has :math:`62^n` possible codes.

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Code length
     - Possible codes (:math:`62^n`)
     - Enough for 6 billion records?
   * - 4
     - 14,776,336
     - No -- 400x too few
   * - 5
     - 916,132,832
     - No -- ~6.5x too few
   * - 6
     - 56,800,235,584
     - Yes, ~9.5x headroom
   * - 7
     - 3,521,614,606,208
     - Yes, ~587x headroom -- the conventional choice

Real shorteners land on 6-7 characters for exactly this reason. The
widget below defaults its hash-based code length to **2** characters
instead of 7 -- deliberately undersized, purely so a collision is
something you can actually trigger and watch resolve in a few clicks,
not something you'd wait an astronomical number of tries to see at a
realistic 62\ :sup:`7` code space.

Short-Code Generation
-----------------------------

There are two structurally different ways to turn "the Nth URL we've
ever shortened" into a short code, and they trade off differently:

* **Counter-based**: keep one monotonically increasing counter, base62-encode
  it. Every code is unique *by construction* -- there is no collision
  case to handle at all. The cost moves elsewhere: a single shared
  counter is a coordination point, so a real implementation needs
  either one centralized ID service or a **block allocation** scheme
  (each application server reserves, say, IDs 40,000-40,999 from a
  central store up front and hands them out locally without a
  round-trip per request).
* **Hash-based**: derive the code directly from the long URL itself
  (a real hash function, truncated to the target code length). This
  needs *no* shared coordination state at all -- any server can compute
  a code independently -- but it genuinely can collide, and the system
  has to detect and resolve that itself: check whether the candidate
  code is already taken by a *different* URL, and if so, salt the
  input and rehash.

Play With It -- both strategies below are the real algorithm running in
your browser: genuine base62 encoding, and genuine FNV-1a hashing (the
same hash family already used in :doc:`bloom_filter_interactive`), not
a simulated stand-in.

.. raw:: html
   :file: _static/url_shortener_widget.html

Storage, and Why Sharding Fits This Problem Cleanly
----------------------------------------------------------------------

The core table is about as simple as schemas get: ``short_code`` (the
primary lookup key), ``long_url``, ``created_at``, optionally
``user_id`` and an expiry. At 6 billion rows and 3 TB, it's well past
what one machine should hold, and the lookup is always **by
``short_code``** -- there's no query pattern that ever needs "find
every URL created in March" as a range scan across the whole dataset.
That combination -- one dominant key, no meaningful range queries on
it -- is exactly the profile :doc:`database_sharding_interactive`
identifies as favoring **hash-based sharding**: scatter by
``hash(short_code) % numShards`` and every server ends up with a
roughly even write load, with no hot-shard risk from monotonically
increasing keys the way a naive range-sharded-by-creation-order scheme
would have.

.. raw:: html
   :file: _static/sharding_widget.html

Caching: the Highest-Leverage Piece of This Design
----------------------------------------------------------------

Go back to the 100:1 read:write ratio. At ~3,858 reads/sec against
~38.6 writes/sec, the redirect path is what actually determines
whether this system feels fast, and it's also the most cacheable
workload imaginable: a given short code's target URL essentially never
changes after creation. This is squarely a **cache-aside, read-through**
shape, with an **LRU** eviction policy (recently-clicked links are
disproportionately likely to be clicked again -- a viral link gets
hammered for days, then goes cold) -- both strategies, and the other
three (FIFO/LFU/TTL) they're worth contrasting against, are covered
directly in :doc:`cache_strategies_interactive`:

.. raw:: html
   :file: _static/cache_strategies_widget.html

Rate Limiting: Protecting the Write Path From Abuse
----------------------------------------------------------------

The write path has a very different threat model from the read path:
nobody abuses a redirect, but a "create short URL" endpoint is a
tempting target for spam -- someone scripting thousands of shortened
links per second to abuse the redirect as an open forwarding service,
or just to exhaust the ID/hash space. Rate limiting the shorten
endpoint per API key or per IP is the standard mitigation, and which
algorithm you pick changes the failure mode at the edges (bursty
traffic, exact-boundary requests) -- all five compared directly, fired
at an identical burst, in :doc:`rate_limiting_interactive`:

.. raw:: html
   :file: _static/rate_limit_widget.html

Scaling Beyond One Region
--------------------------------

Everything above still assumes one data center. Two real-world
questions show up the moment there's more than one:

* **If the store is replicated across regions and a network partition
  happens, do writes keep working (availability) or stay perfectly
  consistent (consistency)?** You cannot have both during the
  partition -- this is exactly :doc:`cap_theorem_interactive`'s subject,
  and for a URL shortener the practical answer usually leans **AP**: a
  short code resolving to a URL that's a few seconds stale after a
  rare failover is a non-event, while refusing every redirect during a
  partition is a real, visible outage.
* **If the ID-generation service itself needs a single leader (e.g.
  the counter-based strategy's centralized counter, or the block
  allocator handing out ID ranges), how does the system agree on who
  that leader is, and survive that leader dying?** That's a real
  leader-election problem, not a detail -- see
  :doc:`raft_consensus_interactive` for the actual mechanism (randomized
  election timeouts, terms, majority votes) that a real ID-allocation
  service or metadata store would lean on.

Putting It All Together
------------------------------

**Write path** (shorten a URL):

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor Client
   participant "API Server" as API
   participant "Rate Limiter" as RL
   participant "ID / Hash\nGenerator" as GEN
   database "Sharded Store\n(by short_code)" as DB
   participant Cache

   Client -> API: POST /shorten {long_url}
   API -> RL: check quota
   RL --> API: allowed
   API -> GEN: generate short_code
   GEN --> API: short_code (base62, collision-checked)
   API -> DB: INSERT (short_code -> long_url)
   API -> Cache: populate short_code -> long_url
   API --> Client: 201 { short_url }

**Read path** (resolve a short URL):

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor Client
   participant "API Server" as API
   participant Cache
   database "Sharded Store\n(by short_code)" as DB

   Client -> API: GET /{short_code}
   API -> Cache: get(short_code)
   alt cache hit (the common case, ~100x more likely than a write)
     Cache --> API: long_url
   else cache miss
     API -> DB: SELECT long_url WHERE short_code = ?
     DB --> API: long_url
     API -> Cache: populate short_code -> long_url
   end
   API --> Client: 301/302 Location: long_url

Every box in those two diagrams is a page (or widget) that already
exists on this site -- this page's only real job was choosing which
of them a URL shortener actually needs, in what order, and why.

See Also
--------------

* :doc:`bloom_filter_interactive` -- a related but structurally
  different "does X exist" question: a bloom filter tolerates false
  positives for speed/space, short-code uniqueness cannot.
* :doc:`consistent_hashing_interactive` -- a different, more dynamic
  answer to "which server owns this key" than the sharding widget's
  fixed hash-mod-N, worth contrasting once you're adding/removing
  shards routinely rather than provisioning them up front.
* :doc:`hash_load_balancer_interactive` -- the same "same key, same
  destination" idea as sharding, one layer up the stack, applied to
  routing client connections to backend servers instead of rows to
  shards.
