Resilience Patterns: Play With It
========================================

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

:doc:`rate_limiting_interactive` protects a service from its own
*clients* -- too many requests, and the service pushes back. This page
is about the opposite direction: protecting a service from its own
*dependencies* -- what happens when something it calls starts failing,
and how to keep that failure from spreading.

The Circuit Breaker State Machine
----------------------------------------

A circuit breaker wraps a call to a dependency and tracks its recent
failures. It has three states:

* **Closed** -- normal operation. Calls go through; failures are
  counted. Cross a failure threshold, and the breaker trips to Open.
* **Open** -- calls fail immediately, without ever reaching the
  dependency. This is the entire point: a struggling dependency gets a
  chance to recover instead of being hammered by every caller's full
  retry traffic on top of whatever is already wrong with it.
* **Half-Open** -- after a reset timeout, the breaker lets exactly one
  trial call through. Success closes the breaker again; failure sends
  it back to Open for another timeout.

Play With It
------------------

Both tabs below simulate a "Payment Service" dependency that is
healthy, then suffers a 15-tick outage, then recovers -- watched by 8
independent service instances, each running its own breaker.

.. raw:: html
   :file: _static/resilience_patterns_widget.html

**Tab 1** compares a naive client (no protection) against a breaker
with a fixed reset timeout against a breaker with a jittered one.
Naive calls the dependency on every tick of the entire outage --
which, in a real system, is exactly the load pattern that keeps a
struggling dependency from ever getting a chance to recover. Both
breaker variants cut that load dramatically. Click **Run** again to
re-roll the jittered column's random delays and watch the recovery
probe spread change from run to run.

Retry Storms and Why Jitter Matters
------------------------------------------

The fixed-timeout breaker has a subtler problem, visible once you look
at *when* it probes the recovered dependency: since every one of the 8
instances trips at the same failure threshold against the same outage
and waits the exact same fixed delay, they are all still in lock-step
when the dependency comes back -- **all 8 probe it on the identical
tick.** That's a self-inflicted mini thundering-herd, aimed at a
dependency that has *just barely* come back up.

Giving each instance's reset timeout a small random jitter on top of
the fixed base breaks that synchrony. The instances still trip
together (same outage, same threshold), but their individual timers
drift apart, so their recovery probes land across several ticks
instead of one. This is the same idea behind AWS's well-known
"exponential backoff and jitter" guidance for retries in general:
randomizing *when* independent clients retry is what keeps their
retries from re-synchronizing into another spike.

Bulkheads: Isolating Failure
------------------------------------

A circuit breaker protects callers from a *slow* dependency, but only
after it trips. Before that -- and in any system where several
different dependencies share the same resource pool (a thread pool, a
connection pool) -- a dependency that fails *slowly* (hangs until
timeout, rather than failing fast) can hold onto pool slots long
enough to starve calls to a completely unrelated, perfectly healthy
dependency. This is the "noisy neighbor" problem, and a **bulkhead**
fixes it the same way a ship's bulkheads do: by physically dividing
the shared resource so one compartment flooding doesn't sink the rest.

**Tab 2** shares a 6-slot connection pool between the flaky Payment
Service and a completely healthy, unrelated Inventory Service. Toggle
the bulkhead off and watch Inventory Service -- which never itself
fails -- start getting rejected anyway, purely because Payment's slow
failures are holding every slot in the shared pool. Toggle it on, and
Payment gets capped at its own small sub-pool; Inventory's slots are
never touched.

Remember
------------

#. Rate limiting protects a service from its clients; resilience
   patterns protect a service from its dependencies -- the direction
   of the threat is the whole distinction.
#. A circuit breaker's value is in the Open state: failing fast means
   a struggling dependency stops receiving load from you, instead of
   getting hammered on top of whatever's already wrong.
#. A fixed reset timeout can quietly recreate a thundering herd at
   the exact moment a dependency recovers, if enough independent
   callers share the same timeout. Jitter on the reset timeout is
   what prevents that.
#. A bulkhead isn't about the failing dependency at all -- it's about
   protecting *other, healthy* dependencies from a shared resource pool
   one bad dependency is monopolizing.

See Also
--------------

:doc:`rate_limiting_interactive` for the client-facing counterpart to
this page's dependency-facing protection. :doc:`architectural_patterns`
for where a flaky dependency in a microservices call chain creates the
cascading-failure risk these patterns exist to contain.
:doc:`delivery_semantics_interactive` for what happens on the
*producer* side when a retry -- the same mechanism a circuit breaker's
half-open probe uses -- meets a non-idempotent handler.
:doc:`watchdog_timer_interactive` for the hardware-level ancestor of
this page's whole idea -- detect that something stopped responding,
then force a recovery -- one layer down, in a single embedded device
instead of a distributed system.
