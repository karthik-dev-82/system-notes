Linux Network Interfaces: Play With It
=============================================

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
