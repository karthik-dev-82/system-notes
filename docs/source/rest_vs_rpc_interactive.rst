REST vs. RPC: Play With It
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

:doc:`rest_api_interactive` already covers what REST is and how its
methods/status codes work. This page assumes that and asks a narrower,
very practical question: **what actually happens when a client's
request times out and it retries?** The answer depends heavily on
which style the API uses -- and getting it wrong is a real, common way
production systems double-charge customers.

What RPC Actually Means
------------------------------

RPC (**R**\ emote **P**\ rocedure **C**\ all) is the older, simpler
idea: calling a function on another machine looks just like calling a
function locally. There's no resource, no URI-as-noun, no fixed verb
set -- just a method name and arguments, e.g. ``cancelOrder(orderId)``
or ``retryPayment(paymentId)``. Concretely, over HTTP this almost
always means:

* One HTTP verb for everything, usually ``POST``.
* The method name lives in the URL path or the request body, not in
  the HTTP verb: ``POST /cancelOrder``, ``POST /retryPayment``, not
  ``DELETE /orders/1``.
* Real-world examples: gRPC, JSON-RPC, Thrift, SOAP, and honestly most
  "REST APIs" that only use ``GET``/``POST`` are RPC in practice --
  using the verb doesn't automatically make an API RESTful.

Neither style is "more correct." RPC tends to fit naturally when the
operation genuinely isn't about a resource (``sendPasswordResetEmail``,
``recalculatePricing``) -- forcing every action into a noun+verb shape
can get awkward. REST tends to fit naturally when the domain really is
made of addressable things (books, orders, users) that get
created/read/updated/deleted. Most real backends use both: resource
CRUD over REST, and RPC-style endpoints for actions that don't map to
a resource cleanly.

The One Difference That Actually Bites: Retry Safety
----------------------------------------------------------------

Here's the practical difference that matters most in an interview (and
in production incidents): **what is a client allowed to assume when a
request times out?**

REST's fixed verb set carries a built-in, standardized answer, from
:doc:`rest_api_interactive`'s safe/idempotent table:

.. list-table::
   :header-rows: 1

   * - Method
     - Idempotent?
     - Safe to blindly retry?
   * - ``GET``
     - Yes
     - Yes
   * - ``PUT``
     - Yes
     - Yes
   * - ``DELETE``
     - Yes
     - Yes
   * - ``POST``
     - No
     - **No** -- may create a duplicate

Any HTTP client, proxy, or load balancer -- code that has never seen
your API's business logic -- can look at the verb alone and know
``PUT``/``DELETE`` are safe to retry and ``POST`` isn't. That
guarantee comes from the *protocol*, not from any individual team
remembering to implement it correctly.

RPC has no equivalent signal. Every RPC call is (usually) a ``POST``.
The transport can't tell a naturally-idempotent action
(``cancelOrder``) apart from a genuinely dangerous one
(``retryPayment``, i.e. "charge the customer again"). Whether a retry
is safe depends entirely on whether *that specific handler's author*
thought to add protection -- typically an **idempotency key**: the
client generates a unique token once per logical attempt and resends
the same token on every retry of that attempt, and the server
remembers which tokens it has already processed.

Play With It
------------------

.. raw:: html
   :file: _static/rest_vs_rpc_widget.html

Both scenarios run the exact same "flaky network" simulation against
all three columns at once, so the input is identical -- only the
handler differs:

* **Cancel Order** is a pure status assignment ("set status =
  cancelled"). That's naturally idempotent no matter how it's exposed,
  so watch all three columns stay safe here regardless of how many
  times the request is retried. This is the control case.
* **Retry Payment** means "charge the customer" -- a counting,
  side-effecting action. REST's ``PUT`` handler checks "already
  charged?" before acting, so it converges to exactly one charge. The
  naive RPC handler just charges on every call with no such check --
  click "Run Flaky Retry Storm" and watch its charge count climb past
  1 while the other two columns stay at 1. Switch to the third column
  and see the fix: the *exact same* ``POST``-everything RPC style,
  with one addition (an idempotency key), recovers REST's safety
  guarantee.

The lesson isn't "REST is safe, RPC is dangerous" -- it's that REST's
verb vocabulary makes the safe choice the path of least resistance
(you'd have to go out of your way to make ``PUT`` non-idempotent),
while RPC makes safety something every handler author has to
deliberately add back in, one endpoint at a time.

See Also
--------------

See :doc:`rest_api_interactive` for the full REST method/status-code
reference this page builds on. See :doc:`rate_limiting_interactive`
for another case where a client-visible contract (rate-limit headers,
here retry-safety) has to be designed in rather than assumed. See
:doc:`long_poll_vs_ws_interactive` for another transport-mechanics
comparison, this time about delivery latency and connection overhead
rather than retry safety.
