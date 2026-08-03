TCP Congestion Control: Play With It
==========================================

TCP has to answer a hard question on every connection: how much data
can I have in flight at once, on a network whose actual capacity I
can't directly measure? Send too little and you waste the link. Send
too much and you cause the very packet loss you're trying to avoid.

The answer is the **congestion window** (``cwnd``) -- roughly, how
many unacknowledged segments the sender is allowed to have in flight
at once. TCP grows it when things are going well and shrinks it when
they're not, using a small set of rules formalized in RFC 5681. See
:doc:`tcp_udp_interactive` for how TCP's reliability guarantees work
first, if you haven't already -- congestion control decides *how
fast* TCP sends; retransmission is what it does when something goes
wrong along the way.

Play With It
------------------

Set a loss rate, hit play, and watch ``cwnd`` actually move through
slow start, congestion avoidance, and recovery -- the graph, the
event log, and the "cars on the highway" panel are all driven by the
same simulation step, so what you read in the log is exactly what you
see plotted.

.. raw:: html
   :file: _static/tcp_congestion_widget.html

The Four Phases
------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 35 20 25

   * - Phase
     - What happens
     - Growth
     - Trigger
   * - Slow Start
     - Probe for the network's capacity fast, starting small
     - Doubles every RTT (1 → 2 → 4 → 8 → ...)
     - Connection start, or after a timeout
   * - Congestion Avoidance
     - Ease up once near the last known limit (``ssthresh``)
     - +1 segment per RTT
     - ``cwnd`` reaches ``ssthresh``
   * - Fast Retransmit
     - React to a loss immediately instead of waiting
     - ``cwnd`` and ``ssthresh`` both drop to half the pre-loss ``cwnd``
     - 3 duplicate ACKs (enough packets were in flight to generate them)
   * - Timeout
     - The heaviest response -- assume the network is in real trouble
     - ``cwnd`` collapses to 1, restart slow start
     - No ACK at all before the retransmission timer expires

Why fast retransmit and timeout react so differently comes down to
one thing: fast retransmit only works if there were enough packets
already in flight *after* the lost one to generate 3 duplicate ACKs
about it. With a small window, there often aren't -- so a timeout,
the slower and much more punishing recovery path, is the only option
left. That's a real reason to care about keeping ``cwnd`` from
collapsing too small, and it's exactly the branch the widget above
simulates (using ``cwnd >= 4`` as the cutoff for "enough packets in
flight").

What This Model Leaves Out
------------------------------------

The classic doubling/halving picture above describes real TCP Reno
and NewReno accurately -- it's not a toy simplification of the
algorithm, it's *an* actual congestion-control algorithm, once (and in
places, still) widely deployed. But it isn't the only one, and a few
details are worth knowing if you're going past the mental model:

* **Linux's default congestion control since kernel 2.6.19 is CUBIC**,
  not Reno. CUBIC grows ``cwnd`` along a cubic function of time since
  the last loss event rather than a strict AIMD line, and it backs off
  less aggressively -- which matters a lot on high-bandwidth,
  high-latency links where Reno-style AIMD recovers too slowly to use
  the available capacity.
* **Google's BBR doesn't use loss as its primary signal at all.** It
  continuously models the bottleneck bandwidth and round-trip time and
  paces sending against that estimate, rather than growing until
  something breaks and backing off when it does.
* **Modern slow start doesn't actually start at cwnd = 1 segment.**
  RFC 6928 raised the typical initial window to around 10 segments,
  specifically so short connections (which is most of them) finish in
  fewer round trips.
* **Real TCP typically uses SACK** (Selective Acknowledgment) rather
  than plain cumulative duplicate ACKs, so the sender learns exactly
  which segments are missing instead of only "still waiting for the
  oldest unacknowledged one."
* **Congestion control is not flow control.** ``cwnd`` is the
  sender's own estimate of what the *network* can handle. The
  receiver separately advertises a window (``rwnd``) representing what
  *it* can handle -- its available buffer space. The amount actually
  in flight at any moment is ``min(cwnd, rwnd)``. This page is only
  about the ``cwnd`` half.

Key Takeaways
------------------

* TCP starts cautiously and speeds up fast (**slow start**, doubling)
  because probing quickly is cheap when you're far below capacity.
* Once it's near the last known limit, it slows its growth to a crawl
  (**congestion avoidance**, +1 per RTT) because now overshooting is
  expensive.
* It reacts to trouble in two different ways depending on how much
  evidence it has: a fast, moderate correction (**fast retransmit** --
  halve and keep going) when there's enough in-flight data to detect
  the loss quickly, or a slow, drastic one (**timeout** -- collapse to
  1 and start over) when there isn't.
* This whole dance exists so that thousands of independent connections
  sharing one link can all back off when it's crowded and speed back
  up when it's not -- without any of them talking to each other.
