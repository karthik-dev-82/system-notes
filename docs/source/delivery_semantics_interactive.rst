Idempotency & Delivery Semantics: Play With It
=====================================================

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
   </style>

A producer sends a message. The consumer might run its handler zero
times, once, or several times -- and the business effect that handler
has (charging a card, sending an email, decrementing stock) might get
applied a different number of times than the handler even ran. Getting
these numbers to match is what "idempotency" and "delivery semantics"
are actually about, underneath the vocabulary.

The Three Delivery Guarantees
------------------------------------

**At-most-once:** the producer sends once and never retries. If the
message is lost in transit, it's gone -- simple, but the only policy
that can silently drop a message.

**At-least-once:** the producer retries until it gets an
acknowledgment. This guarantees the message eventually arrives (given
enough retries), but introduces a new failure mode: if the message
*was* delivered and processed, but the **ack** got lost on the way
back, the producer has no way to tell that apart from the original
message never arriving -- so it retries, and the consumer sees the
same logical message twice.

**Exactly-once:** doesn't actually exist as a delivery guarantee. This
is a known, provable result (it reduces to the `Two Generals Problem
<https://en.wikipedia.org/wiki/Two_Generals%27_Problem>`_ -- no amount
of acking over an unreliable channel lets two parties both become
certain the other received the final message). What real systems
achieve instead is **at-least-once delivery plus idempotent
processing**, which produces the same observable effect as
exactly-once -- the message might physically arrive more than once,
but its effect is applied only once. This is usually called
"effectively-once."

Play With It
------------------

.. raw:: html
   :file: _static/delivery_semantics_widget.html

The widget tracks two separate numbers per policy on purpose:
**deliveries** (how many times the consumer's handler ran at all) and
**effects** (how many times the actual business logic -- the charge,
the email, the stock decrement -- fired). Click **Force Ack-Loss
Demo** for a guaranteed, deterministic example: the message is
delivered and its ack is lost, so the producer retries and the message
is delivered a second time. Watch what each column does with that
second delivery.

Why Deliveries and Effects Are Different Numbers
--------------------------------------------------------------

**At-Most-Once** never retries, so deliveries and effects are always
equal -- the only thing that can go wrong is both landing at zero.

**At-Least-Once (naive)** also keeps deliveries and effects equal to
each other, but for the opposite reason: the consumer has no memory of
what it's already processed, so it reapplies the effect on *every*
delivery. A duplicate delivery is automatically a duplicate effect --
a duplicate charge, a duplicate email, a duplicate stock decrement.

**At-Least-Once + Idempotency Key** is the only column where the two
numbers can legitimately diverge: deliveries can climb past 1 (the
transport-level duplicate still happens -- the ack still gets lost,
the producer still retries), but effects stays at 1, because the
consumer recognizes the repeated idempotency key and skips reapplying
the effect while still returning success. The duplicate delivery is
real; the duplicate effect is the thing that's actually prevented.

How This Shows Up in Kafka
---------------------------------

:doc:`kafka_topic_interactive` already covers partitions, consumer
groups, and offsets -- this page's mechanism is exactly what those
offsets are for, from two different angles:

* **Producer side:** Kafka's *idempotent producer* setting attaches a
  producer ID and a per-partition sequence number to every message.
  If a producer retries a send (because it never saw the broker's
  ack), the broker recognizes the repeated sequence number and drops
  the duplicate write to the log -- the idempotency-key pattern above,
  implemented by the broker instead of by hand.
* **Consumer side:** *when* a consumer commits its offset relative to
  processing is a direct choice between at-most-once and at-least-once
  risk. Commit the offset **before** processing and then crash mid-work,
  and that message is skipped forever on restart (at-most-once risk).
  Commit **after** processing and crash mid-work, and the same message
  gets reprocessed on restart (at-least-once risk) -- which is exactly
  why consumer-side handlers that matter are written to be idempotent
  in the first place.

Remember
------------

#. True exactly-once *delivery* isn't achievable over an unreliable
   network -- what's achievable is at-least-once delivery plus an
   idempotent consumer, which looks like exactly-once from the outside.
#. Track deliveries and effects as separate numbers. A duplicate
   delivery is expected and harmless under at-least-once; a duplicate
   *effect* is the actual bug.
#. The idempotency key has to be generated once per logical attempt
   and resent unchanged on every retry of that attempt -- a new key
   per retry defeats the entire mechanism.

See Also
--------------

:doc:`kafka_topic_interactive` for the real system (offsets, consumer
groups, idempotent producer) that this page's mechanism is drawn from.
:doc:`rest_vs_rpc_interactive` for the same idempotency-key idea
applied at the HTTP client-retry layer instead of the message-broker
layer. :doc:`architectural_patterns` for where event-driven delivery
guarantees like these actually sit in a larger system.
