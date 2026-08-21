Consistent Hashing: Play With It
================================

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

:doc:`hash_load_balancer` establishes the numbers: going from 3 to 4
servers reshuffles 75% of users under naive modulo hashing, but only
about 25% under consistent hashing. This page is the mechanism behind
that second number, made visible -- a real ring, with real servers and
keys placed on it by hashing their names, where you can add and remove
servers yourself and watch exactly which keys move.

Play With It
------------------

Both servers and keys are placed on the same ring by hashing their
names down to a position on it. Every key belongs to whichever server
comes next going clockwise. Add a server and watch only the keys in
its new slice of the ring move to it; remove one and watch only its
former keys get picked up by whoever's next -- everyone else on the
ring never even notices.

.. raw:: html
   :file: _static/consistent_hash_widget.html

Reading the Comparison Panel
------------------------------------

Every time you add or remove a server, the panel on the right computes
*two* numbers for that exact same event: what naive modulo hashing
(``key_hash % server_count``, recomputed from scratch) would have
done, versus what actually happened on the ring -- each measured
against a large hidden sample of keys, not just the handful drawn as
dots, so the numbers are stable across reloads rather than swinging
with which few keys happen to be visible.

The part that reliably holds is the *order of magnitude*: naive
modulo always reshuffles the large majority of keys, consistent
hashing always reshuffles dramatically fewer. The exact
consistent-hashing percentage moves around more than the "~25%"
headline figure suggests, though -- with only a handful of real
servers, exactly how much ring space the new or removed server ends
up owning is genuine variance, not measurement error, and it gets
worse at low virtual-node counts (see below). That's not a canned
statistic -- it's the same comparison from :doc:`hash_load_balancer`
recomputed live, so you're seeing the real spread, not a number
tuned to always land on the textbook figure.

Why the Virtual-Node Slider Matters
--------------------------------------------

Set virtual nodes to 1 and hit Reset a few times: the "keys per
server" bars can come out quite lopsided, purely because of where each
server's single ring position happened to land -- one server might
own a huge arc, another a tiny sliver, entirely by chance of the hash.
That's not a flaw in the demo; it's the real, documented weakness of a
naive one-point-per-server ring. Turn virtual nodes up and each server
gets spread across many small arcs instead of one big one, and the
totals balance out far more reliably -- the same fix real systems
(Cassandra, DynamoDB-style partitioning, most CDNs) actually use, often
with virtual node counts in the hundreds per physical server.

See :doc:`hash_load_balancer` for the modulo-hashing walkthrough this
page builds on, including the exact 75%-vs-25% figures and the
production use cases (sticky sessions, cache routing, CDN edge
selection) that make any of this matter in the first place.

See :doc:`kafka_topic_interactive` for the same "same key, same owner,
every time" hashing idea applied to a message log instead of a server
ring -- Kafka's partition routing is a simpler, fixed-partition-count
cousin of the reshuffling problem this page solves for servers.
