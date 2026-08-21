Packet Journey: Play With It
============================

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

:doc:`network_interfaces` and :doc:`kernel_networking_docker_internals`
cover the pieces of this individually -- veth pairs, the ``docker0``
bridge, the netfilter chains, conntrack. This page puts them together
into one thing: watching a single real connection move through every
one of those pieces, in order, with its own packet headers changing
in front of you.

The one idea worth holding onto going in: **PREROUTING always runs
before the routing decision and FORWARD, and POSTROUTING always runs
after them -- for every packet, on every interface, regardless of
which direction it's travelling.** It's not "outbound traffic uses
POSTROUTING, inbound traffic uses PREROUTING." Every packet passes
through both hooks in that fixed order; which one (if either) actually
rewrites anything depends entirely on which rule matches.

Play With It
------------------

Two directions to try:

* **Outbound** -- a container makes an ordinary request out to the
  internet (the ``NAT Mode`` scenario from :doc:`network_interfaces`).
  Watch ``MASQUERADE`` hide the container behind the host's address on
  the way out, and watch conntrack undo that automatically when the
  reply comes back -- with no separate rule needed for the return trip.
* **Inbound** -- what actually happens on ``docker run -p 8080:80``.
  Watch ``DNAT`` redirect an external connection to the container
  before the kernel even decides where to route it, and watch
  conntrack reverse that on the way out too.

.. raw:: html
   :file: _static/docker_packet_journey_widget.html

Reading the conntrack Table
------------------------------------

The single most important thing to notice while playing with this:
the *reply* leg never consults a NAT rule at all. NAT rules
(``MASQUERADE``, ``DNAT``) only ever get evaluated for the first
packet of a new connection. The moment that happens, conntrack writes
down the mapping -- that's the entry you see appear in the table. From
then on, every other packet belonging to that connection, in either
direction, gets rewritten straight from that table entry. That's the
whole reason a reply can find its way back to the right container
without Docker having to write a second rule for the return trip --
and it's why the docs describe conntrack as a coat check ticket: you
don't explain yourself again when you come back, the ticket already
has your name on it.

Why This Matters in Practice
--------------------------------------

* If you've ever wondered why a container can reach the internet with
  *zero* explicit configuration but needs an explicit ``-p`` flag to
  be reached *from* the internet -- this is why. Outbound traffic only
  ever needs ``MASQUERADE``, one blanket rule covering the whole
  container subnet. Inbound traffic needs a specific ``DNAT`` rule per
  published port, because the kernel has no way to guess which
  container an unsolicited external connection is meant for.
* ``docker0`` never rewrites anything -- it's a plain Ethernet bridge,
  a virtual switch. Every address translation in this whole journey
  happens at the netfilter hub, nowhere else.
* The container's application never sees any of this. In outbound
  mode, it thinks it has a direct connection to google.com. In inbound
  mode, nginx thinks it's just a webserver listening on port 80.
  Neither one has any way to know NAT happened -- which is exactly the
  point of NAT.

See :doc:`network_interfaces` for the Bridge vs. NAT comparison and
the mailbox/phone-extension analogies, and
:doc:`kernel_networking_docker_internals` for the full netfilter table
and chain reference, real ``iptables`` command examples, and OverlayFS
internals.
