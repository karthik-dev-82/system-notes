DNS Resolution: Play With It
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

Typing a hostname into a browser triggers one query from your
machine's point of view -- and a *walk* from the resolver's. A
recursive resolver doesn't know where ``example.com`` lives any more
than you do; it finds out the same way you'd find a person's desk in
an unfamiliar office building: ask the front desk (root) who handles
this floor (the TLD), ask that floor's desk who owns this specific
office (the authoritative server), then finally ask that office for
the answer. The walk is expensive. The reason DNS feels instant is
that almost every layer of it gets cached, and each layer expires on
its *own* clock.

Play With It
------------------

Resolve ``example.com`` cold and watch all three hops happen. Then
resolve ``other-example.com`` -- a *different* domain, but still under
``.com`` -- and watch the root hop get skipped while the TLD and
authoritative hops still fire: the resolver already knows who runs
``.com``, it just doesn't know who runs this particular domain yet.
Resolve ``www.example.com`` next and compare: since that name is in
the *same* zone as the first query, even the TLD hop is now cached,
and only the authoritative hop happens. Advance the virtual clock past
a 300-second answer TTL (but nowhere near the 2-day referral TTLs) and
re-resolve: exactly one hop happens, not three.

.. raw:: html
   :file: _static/dns_resolution_widget.html

Why Caching Has Layers
------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 35 40

   * - Cached record
     - Learned from
     - Typical lifetime
   * - ``.com`` / ``.org`` NS referral
     - The root servers
     - Very long (real root zone data changes on the order of years)
   * - ``example.com`` NS referral
     - The TLD servers
     - Long -- domains rarely change nameservers
   * - The actual ``A`` record
     - The authoritative server
     - Short -- the zone owner sets this, often minutes, precisely
       *because* they may want to repoint it quickly

Those three lifetimes being wildly different is the whole reason a
resolver's first-ever query for a brand-new TLD is slow, its second
query for a *different* domain under a TLD it already knows is
faster, and every subsequent query for a name it's already resolved
is close to free -- right up until that specific answer's short TTL
runs out, at which point only *that* layer gets redone.

The CNAME Case: Following, Not Stopping
------------------------------------------------

``www.example.com`` and ``blog.example.com`` in the widget aren't ``A``
records at all -- they're ``CNAME`` records pointing at
``example.com``. A resolver that returns a cached ``CNAME`` value
as-is, without continuing the resolution to whatever it points at, is
returning an alias instead of an address. The widget's resolver
follows the chain through on every lookup, cached or not, which is
also the reason a warm ``CNAME`` lookup still shows the final IP
address rather than the word "CNAME."

See Also
-------------

:doc:`tls_cert_chain_interactive` is the next thing that happens
after this page resolves a name: the browser connects to that IP and
verifies *who's actually there* before trusting anything it sends
back.
