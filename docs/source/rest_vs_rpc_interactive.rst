REST vs. RPC: Play With It
================================

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
here retry-safety) has to be designed in rather than assumed.
