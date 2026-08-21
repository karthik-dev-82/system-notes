Hash Load Balancer: Play With It
=======================================

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

:doc:`hash_load_balancer` covers the concept -- same input always
hashes to the same server, which is what makes shopping carts and
logged-in sessions survive across requests. This page is the
hands-on companion: click real clients, watch a real (if
deliberately simplified) routing decision happen, and see the one
subtlety that conceptual explanations usually skip -- what exactly
is being hashed, and what that choice does and doesn't guarantee.

What Exactly Is a "Flow"?
--------------------------------

A **flow** is the standard way networking identifies "one connection,"
independent of what's inside it. It's five values, together:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Field
     - Example
   * - Source IP
     - ``10.0.0.7`` (the client)
   * - Destination IP
     - ``203.0.113.10`` (the load balancer's public address)
   * - Source port
     - ``51422`` (chosen essentially at random by the client's OS for
       this connection)
   * - Destination port
     - ``443`` (HTTPS)
   * - Protocol
     - ``TCP``

Two packets belong to the same flow if and only if all five values
match. The one field worth paying attention to is the **source
port**: every time a client opens a *new* connection -- a page
reload, a new tab, a browser reconnecting after a network blip --
the OS hands it a fresh, effectively random source port. Same
client, same server, same everything else -- but a genuinely
different flow, because that one number changed.

Play With It
------------------

10 clients, 3 servers, one load balancer. Click a client to send a
request (a new connection = a new source port = a new flow). Click
the *same* client again and watch closely -- it can land on a
*different* server than last time, even though nothing about the
client changed.

.. raw:: html
   :file: _static/hash_load_balancer_widget.html

Connection-Level Stickiness, Not User-Level Stickiness
------------------------------------------------------------

This is the subtlety most introductions skip. Flow-hash load
balancing gives you exactly one guarantee: **the same flow always
goes to the same server.** Click "Resend Last Flow" in the widget
above and watch it -- identical 5-tuple in, identical server out,
every single time. That's real, and it's useful: it means a single
TCP connection never gets its packets split across multiple
backends mid-stream.

What it does *not* guarantee is that the same **user** always lands
on the same server, because a user is not a flow. A user might open
a new tab, and that new tab is a new TCP connection with a new
source port -- a new flow, with a hash that has no relationship to
the previous one. That's exactly what you'll see if you click the
same client box twice in the widget: two different, valid,
consistently-computed routing decisions, that can point at two
different servers.

This is why the use cases in :doc:`hash_load_balancer` -- shopping
carts, logged-in sessions -- are described as hashing a *user ID or
session cookie*, not a raw flow tuple: an application-layer identifier
stays the same across separate connections from the same person,
which is the actual property those use cases need. Flow hashing lives
one layer down, at L3/L4, and solves a different, narrower problem:
keeping one connection's packets together and letting a load balancer
route without ever having to inspect application data.

.. code-block:: python

   # This demo, in one function -- deliberately naive, see the note below
   def route(src_ip, src_port, dst_ip, dst_port, proto, num_servers):
       flow = f"{src_ip}:{src_port}-{dst_ip}:{dst_port}-{proto}"
       return hash(flow) % num_servers

Why "Naive Modulo" Is Labeled as Such
--------------------------------------------

The widget's badge isn't hedging -- ``% num_servers`` is a real,
genuine problem, and it's the entire reason the next page exists.
Change the number of servers (scale up, scale down, one crashes and
gets replaced) and the modulus changes, which silently reroutes a
large fraction of *every* existing flow, not just the ones that
actually needed to move. That reshuffling problem, and the fix, is
covered in full in :doc:`consistent_hashing_interactive` -- this page
is deliberately the simpler prerequisite that gets the "what's a flow,
what does hashing it actually guarantee" foundation in place first.
