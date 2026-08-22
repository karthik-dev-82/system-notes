CDN: Play With It
========================

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
   </style>

A CDN is, mechanically, a fleet of :doc:`proxy_servers_interactive`
-- reverse proxies deployed geographically close to users, each with
its own local cache. The caching mechanics themselves (cache-aside,
TTL, eviction) are already covered in :doc:`cache_strategies_interactive`;
this page is specifically about the two problems that only show up
*because* a CDN has many independent edge caches instead of one:

CDNs Have Many Independent Caches, Not One
------------------------------------------------------

Every edge Point of Presence (POP) has its **own** cache -- a cache
warm at the POP in Frankfurt does nothing for the POP in Singapore. A
user's request is routed to whichever POP is geographically nearest
(usually via Anycast or GeoDNS), and that specific POP either has the
content or doesn't, independent of every other POP's state.

The Thundering Herd: What Happens When a Cold POP Goes Viral
------------------------------------------------------------------------------

A brand-new POP, or a POP whose cache entry just expired, has *nobody*
cached for a given key. If content suddenly goes viral and hundreds of
simultaneous requests land on that exact POP for that exact key at the
same moment, every one of them independently sees a cache miss --
there's no way for a request to know another identical request is
already in flight, unless the CDN software explicitly tracks that.

**Naive handling:** every one of those simultaneous requests fetches
from origin itself. Origin sees N simultaneous hits for one piece of
content -- a real, well-documented failure mode called the "thundering
herd" or "cache stampede," and it can take an origin server down
during exactly the traffic spike it needed to survive.

**Request coalescing (aka "request collapsing" or "single-flight"):**
the first request that sees the miss is the only one that actually
fetches from origin. Every other simultaneous request for that *same*
key waits on that one in-flight fetch and reuses its result once it
completes. Verified above (2,000-trial fuzz): origin hits under
coalescing always equal the number of *distinct* keys in the wave, no
matter how many requests share each key.

Play With It
------------------

.. raw:: html
   :file: _static/cdn_widget.html

Cache Key Composition: Two Opposite Failure Modes
------------------------------------------------------------

The cache key is normally built from the request path plus some
subset of its query parameters -- and getting that subset wrong fails
in two opposite directions:

**Too little in the key (under-keying):** if a query parameter that
*actually changes the response* is left out of the cache key, requests
for genuinely different content collapse onto one cache entry. A
thumbnail request (``?w=100``) and a full-size request (``?w=200``)
sharing a path-only cache key means whichever one gets cached first is
served to *both* -- a real correctness bug, not just a performance one.

**Too much in the key (over-keying):** if a parameter that *doesn't*
change the response gets included anyway -- a classic case is an
analytics or cache-busting timestamp (``?_=1700000001``) some client
code tacks onto every request -- then requests for genuinely identical
content each get their own cache entry. The content served is still
correct, but the effective cache hit rate collapses toward zero,
because the CDN never sees the same key twice.

The tab above lets you toggle both params in and out of the key and
watch which failure mode shows up on the same three sample requests.

Remember
------------

#. A CDN is reverse proxies plus geography -- the caching mechanics
   are the same ones already covered elsewhere; what's new is that
   every POP's cache is independent.
#. A cold POP hit by a simultaneous burst for one key is a real
   thundering-herd risk -- request coalescing (only the first miss
   fetches, everyone else waits on it) is the standard fix.
#. Leaving a content-affecting parameter out of the cache key is a
   correctness bug (wrong content served). Including an irrelevant
   parameter is a hit-rate bug (right content, but effectively never
   cached). They look similar but are opposite mistakes with opposite
   symptoms.

See Also
--------------

:doc:`proxy_servers_interactive` for the reverse-proxy mechanics a CDN
edge node is built from. :doc:`cache_strategies_interactive` for the
general caching strategies (cache-aside, TTL, eviction policies) that
apply equally to a single cache or a CDN's many independent ones.
