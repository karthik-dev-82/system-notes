Linux Network Interfaces: Play With It
=============================================

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

:doc:`network_interfaces` covers the full picture -- loopback, veth
pairs, bridges, TUN/TAP, VLANs, NAT -- with analogies and diagrams.
This page is the hands-on companion for three of those interface
types: bridges, TUN/TAP, and VLANs. Each section below has its own
short introduction followed by a real, playable demo of the actual
mechanism, not just an analogy for it.

Bridge Interfaces: A Real Layer-2 Switch, in Software
------------------------------------------------------------

``docker0`` (and any other Linux bridge, ``br0`` included) is not a
simulation of a switch or an approximation of one -- it's a real
implementation of the same forwarding logic a hardware Ethernet
switch uses. It keeps a **MAC learning table** that maps
``MAC address -> port``, built entirely from watching traffic go by:
every frame's *source* MAC teaches the bridge where that device
lives. Forwarding a frame is then a lookup on the *destination* MAC:
known destination -> send to exactly that one port; unknown
destination, or a broadcast -> flood to every other port, because
there's no way yet to know where it should go.

Step through a realistic sequence below -- several containers and the
host talking through ``docker0`` -- and watch the table fill in live,
including what happens when a container effectively "moves" to a new
port (a restart with a fresh veth pair).

.. raw:: html
   :file: _static/net_bridge_widget.html

TUN/TAP Interfaces: Which Layer Does Your App Talk To?
------------------------------------------------------------

TUN and TAP are both ways for a userspace application to inject
traffic directly into the kernel's network stack as if it came from a
real NIC -- the difference is which layer that traffic enters at.
**TUN** hands the kernel bare IP packets (Layer 3, no MAC addresses
anywhere); **TAP** hands the kernel complete Ethernet frames (Layer 2,
MAC headers included). Most VPN software (OpenVPN's default mode,
WireGuard) uses TUN because a VPN only needs to move IP packets
between two points -- there's no Ethernet segment involved, so MAC
headers would just be overhead. TAP exists for the cases that
genuinely need Layer 2, most commonly giving a virtual machine a
virtual NIC that can join a bridge exactly like a physical one would.

Toggle between the two modes below and send a packet through each --
then try attaching the resulting device to a bridge and see exactly
why one works and the other structurally can't.

.. raw:: html
   :file: _static/net_tuntap_widget.html

VLAN Interfaces: One Wire, Several Isolated Networks
------------------------------------------------------------

A VLAN sub-interface (``eth0.10``, ``eth0.20``, ``eth0.30``) doesn't
give a device a second physical connection -- it gives it a filtered
view of the *same* one. Every frame sent out one of these
sub-interfaces gets an extra 4-byte 802.1Q tag inserted (carrying a
12-bit VLAN ID) before it hits the wire, and every device only
processes frames whose tag matches the VLAN it's configured for.
Same cable, same switch port in many setups -- but a device on VLAN 30
structurally cannot see VLAN 10 or VLAN 20 traffic, the way a guest's
phone can't see your security cameras even though every packet
physically passes right by it.

Send a frame from a device on any of the three VLANs below and watch
exactly who receives it -- and confirm, directly, that everyone else
doesn't.

.. raw:: html
   :file: _static/net_vlan_widget.html

Where This Fits
----------------------

These three mechanisms compose with everything else in
:doc:`network_interfaces` and :doc:`kernel_networking_docker_internals`:
a container's veth pair plugs into a bridge (this page's first demo);
that same bridge can also hold a TAP device connecting a VM; and any
of these physical or virtual links can carry multiple VLANs
simultaneously via tagging. None of them are mutually exclusive --
production networks routinely combine all three on the same box.
