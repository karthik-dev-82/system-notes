Cache Strategies: Play With It
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
   </style>

"Caching" sounds like one idea, but it's really two independent
questions that get tangled together: **who talks to whom when data
moves between the cache and the database**, and **what gets thrown
away when the cache is full**. This page builds both, separately,
each with its own widget.

Part 1: Who Talks to Whom
--------------------------------

Four strategies, each a genuinely different answer to "how does data
get into the cache, and when is a write actually safe":

* **Cache-aside**: the app owns the coordination. On a miss, the app
  reads the DB itself and populates the cache. On a write, the app
  writes the DB and *invalidates* (not updates) the cache entry.
* **Read-through**: the app only ever talks to the cache. On a miss,
  the cache loads from the DB on the app's behalf -- the app never
  touches the DB directly.
* **Write-through**: like read-through, but for writes -- the cache
  commits synchronously to the DB before acknowledging the app's
  write. Exactly as durable as writing the DB directly.
* **Write-back** (write-behind): the app's write is acknowledged the
  instant it lands in the cache. The DB gets updated later, in the
  background.

Play With It: Reads, Writes, and a Cache Crash
---------------------------------------------------------

.. raw:: html
   :file: _static/cache_strategies_widget.html

Pick **write-back**, write a key, and click **Simulate Cache Crash**
before flushing. The write is gone -- not delayed, not recoverable,
just gone, because it was only ever acknowledged by the cache, which
no longer exists. Switch to **write-through** and do the exact same
crash: nothing is lost, because the write was already durable in the
DB before the app ever got its "OK" back. That's the entire trade
write-back makes explicit: faster writes, in exchange for a real
window where an acknowledged write can vanish.

Part 2: What Gets Thrown Away
------------------------------------

Once the cache is full, a policy has to pick who leaves to make room
for someone new:

* **LRU** (Least Recently Used): evict whoever hasn't been touched in
  the longest time. Every access -- read or write -- resets the clock.
* **FIFO** (First In, First Out): evict whoever arrived first, full
  stop. Access never changes anything.
* **LFU** (Least Frequently Used): evict whoever has the smallest
  access *count*, not the longest idle time.
* **TTL** (Time To Live): evict -- really, expire -- whoever's own
  clock has run out, independent of capacity or access pattern.

Play With It: Four Caches, One Access Sequence
---------------------------------------------------------

.. raw:: html
   :file: _static/eviction_policies_widget.html

Click **Run LRU-vs-FIFO Divergence Demo**. It plays A, B, C, D, A, E
against all four caches at once. LRU and FIFO fill identically with
A/B/C/D -- then re-accessing A does something different in each: LRU
moves A to the protected end, FIFO does nothing at all, because FIFO's
rule never looks at access, only arrival order. When E arrives and
something has to go, LRU evicts B (the actual least-recently-touched
entry); FIFO evicts A anyway. Same four keys, same access sequence,
same capacity -- genuinely different answers, which is exactly the
mix-up worth having seen happen once instead of just read about.

Where This Shows Up
--------------------------

See :doc:`page_cache_interactive` for a different layer entirely --
the OS page cache sits between a process and disk, not between an app
and a database, but it makes some of the same durability tradeoffs
(this page's write-back is the same shape of risk as that page's
"crash before fsync() and lose it" scenario, one layer down the
stack).

See :doc:`db_redis_structures_interactive` for a real system's actual
TTL implementation (Redis key expiry), the same mechanism this page's
eviction widget models in miniature.

See :doc:`cap_theorem_interactive` for the same "acknowledge now,
risk it later" shape of tradeoff at the distributed-systems level --
write-back's crash-loses-data risk here is a smaller-scale cousin of
AP mode's willingness to serve (and lose) data during a partition.
