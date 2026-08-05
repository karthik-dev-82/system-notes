Packet Journey: Play With It
============================

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
