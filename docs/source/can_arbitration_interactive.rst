CAN Bus Arbitration: Play With It
=====================================

Every modern car, aircraft, and even SpaceX rockets run on CAN
(Controller Area Network) -- a single shared pair of wires that every
sensor and controller on the bus talks over at once. The obvious
question: what happens when the brakes controller and the seat heater
both need to say something at the exact same instant? Ethernet's
answer is to let them collide, notice the wreckage afterward, and
retry. CAN's answer is stranger and better: it lets them collide *on
purpose*, resolves who wins bit by bit while the collision is still
happening, and never wastes a single bit doing it.

The Two Wire States That Make This Work
---------------------------------------------

CAN's two wires don't encode "0" and "1" symmetrically. One state is
**dominant** (a logical 0) and the other is **recessive** (a logical
1). The bus itself behaves like a wired-AND: if even one node drives
dominant while every other node drives recessive, *the entire bus
reads dominant* -- recessive is the wire's default, resting state, and
dominant physically overrides it the instant both are driven at once.

That single electrical fact is the whole mechanism. A node's message
ID is transmitted bit by bit, most significant bit first, and a
**lower numeric ID means more leading dominant (0) bits** -- which is
exactly why a lower CAN ID is treated as *higher priority*.

Play With It
------------------

Pick which nodes are transmitting at the same instant, then watch the
actual bit-by-bit race: every node drives its own ID bit, then reads
back what the bus actually settled to. The moment a node's own bit
disagrees with the bus, it has already lost -- it stops immediately,
mid-ID, and everyone else keeps going until exactly one node remains.

.. raw:: html
   :file: _static/can_arbitration_widget.html

Why Nothing Is Ever Wasted
--------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 30 35 35

   * - 
     - CAN bus arbitration
     - Ethernet-style CSMA/CD
   * - When is a collision noticed?
     - Immediately, bit by bit, while it's happening
     - Only after the fact, once both frames are already fully sent
   * - What gets thrown away?
     - Nothing -- losing nodes simply stop and wait for this frame to
       finish
     - The entire colliding frame, on every node involved
   * - How does a loser retry?
     - It doesn't need to "retry" anything -- it just tries again on
       the next frame
     - Random backoff, then resend the whole frame, hoping not to
       collide again

This is the detail that makes CAN's arbitration different from a
retry-based scheme in kind, not just in speed: a node that loses
arbitration hasn't wasted any bandwidth at all. Every bit it sent
before losing was a real, correctly-received bit -- it just happened to
lose a priority contest it was allowed to enter every time, for free.

See Also
-------------

See :doc:`8b10b_encoding_interactive` for the other Hardware Protocols
page in this pair -- a completely different real mechanism (line
encoding for clock recovery) living at the same physical layer this
page's bus arbitration operates on.
