Hash Load Balancer: Play With It
=======================================

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
