DNS Resolution: Play With It
================================

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

Resolve a name cold and watch all three hops happen. Resolve a
*second* name under the same TLD and watch the root hop get skipped
-- the resolver already knows who runs ``.com``, it just doesn't know
who runs this particular domain yet. Advance the virtual clock past a
300-second answer TTL (but nowhere near the 2-day referral TTLs) and
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
