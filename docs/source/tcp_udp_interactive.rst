TCP vs. UDP: Play With It
=========================

TCP and UDP solve the same basic problem -- get data from one
computer to another -- with opposite priorities. TCP guarantees every
byte arrives, in order, even if that means waiting. UDP guarantees
nothing except that it tried once, immediately.

Both run on top of IP, and IP itself makes no delivery promises at
all -- packets can be dropped, duplicated, or reordered anywhere along
the path. TCP and UDP are two different answers to "given that,
what do we do about it?"

Play With It
------------------

Send the same 8 packets over a lossy link in both modes and watch
what actually happens -- the handshake, the retransmits, the gaps.

.. raw:: html
   :file: _static/tcp_udp_widget.html

What TCP Actually Does
------------------------------

* **Three-way handshake first.** SYN, SYN-ACK, ACK -- both sides
  agree the connection exists and agree on starting sequence numbers
  before any application data moves.
* **Every segment is numbered and acknowledged.** The receiver tells
  the sender what it has; the sender knows what still needs resending.
* **Lost data is retransmitted**, detected either by duplicate ACKs
  (fast retransmit) or by a retransmission timeout -- see
  :doc:`tcp_congestion_control_interactive` for exactly how TCP
  decides *how fast* to keep sending while all this is happening.
* **Delivered out of order gets reordered** before the application
  ever sees it.
* **Connection teardown** (FIN/ACK) closes things down cleanly.

None of that is free -- it costs round trips and, under loss, time.
That's the right trade for a file download, a web page, a bank
transfer, or anything where a missing byte is a real problem.

What UDP Actually Does
------------------------------

* **No handshake.** The first packet you send *is* the first data the
  other side might see.
* **No acknowledgments, no retransmission.** A dropped datagram is
  simply gone; UDP itself never finds out and never tells you.
* **No ordering guarantee.** Datagrams can arrive in a different order
  than you sent them, and UDP won't fix that either.
* **Minimal overhead.** The UDP header is 8 bytes, versus TCP's 20+;
  there's no connection state to track at all.

That's exactly right for a video call or a live stream: a dropped
frame from a second ago is *worthless* by the time a retransmit could
arrive, so paying the cost to recover it would only make the lag
worse. Skip it and move on. It's also why DNS defaults to UDP for
ordinary lookups -- a single small request/response doesn't need
connection setup at all, and if it's lost, the resolver just asks
again itself, at the application layer, if there's no answer within
its own timeout.

Quick Comparison
------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 35 40

   * - Feature
     - TCP
     - UDP
   * - Connection setup
     - Three-way handshake required
     - None -- send immediately
   * - Delivery guarantee
     - Every segment, retransmitted until acknowledged
     - Best-effort; lost datagrams are simply gone
   * - Ordering
     - Reassembled in order for the application
     - Delivered in whatever order it arrives
   * - Header overhead
     - 20+ bytes, connection state on both ends
     - 8 bytes, no state
   * - Typical uses
     - File transfer, web (HTTP), email, databases
     - Video/voice calls, live streaming, DNS, gaming

.. note::
   Neither protocol is "better" -- they're tuned for opposite failure
   modes. TCP treats *late* as acceptable and *wrong/missing* as not.
   UDP treats *late* as unacceptable and tolerates *missing*. Pick
   based on which failure your application can actually live with.
