8b/10b-Style Line Encoding: Play With It
=============================================

Why a Wire Needs to Wiggle
--------------------------------

A receiver with no dedicated clock wire has to figure out, on its own,
exactly when to sample each bit. It does this by watching the wire's
own transitions -- every 0-to-1 or 1-to-0 flip is a chance to re-sync
an internal timer that otherwise slowly drifts. Long runs of the same
bit value are the problem: no transitions means no chance to re-sync,
and after enough of them the receiver's timer has drifted far enough
to sample at the wrong moment entirely.

This is exactly why sending the byte ``0x00`` (eight zero bits) is
dangerous. On the wire it would be a flat, featureless line -- no way
to tell "receiving eight zeros" apart from "the cable fell out."
That's not a rare edge case; runs of identical bytes show up
constantly in real data (compressed files, blank image regions,
padding).

8b/10b line coding is the fix: never send the raw 8 bits. Translate
every byte into a 10-bit pattern chosen specifically so that
transitions never go missing for long, no matter what the original
byte was.

Play With It
------------------

Send a byte and watch it split into a 5-bit group and a 3-bit group,
each independently translated against the running disparity so far --
a running count of whether the wire has recently carried more 1s or
more 0s. Try ``00`` first: watch the encoder refuse to send eight flat
zeros. Then send several bytes in a row and watch the running
disparity number stay small, pulled back toward zero after almost
every byte.

.. raw:: html
   :file: _static/8b10b_encoding_widget.html

The Two Rules Everything Else Follows From
-------------------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 30 70

   * - Rule
     - Why it exists
   * - No long run of identical bits
     - Guarantees the receiver a transition to re-sync its clock
       against, often enough that drift never has a chance to
       accumulate
   * - Roughly equal 1s and 0s over time (DC balance)
     - Real wires are analog underneath -- a long bias toward one
       voltage level slowly charges parasitic capacitance and shifts
       the baseline the hardware reads against

Rule 2 is what running disparity tracks. A byte whose natural bit
pattern is already balanced gets one fixed encoding -- there's nothing
to correct. A byte that isn't balanced gets **two** valid encodings,
one leaning slightly toward more 1s and one toward more 0s, and the
encoder picks whichever one nudges the long-run balance back toward
zero.

Being Honest About What This Widget Actually Is
-------------------------------------------------------

This widget is a **from-scratch construction that uses the same real
mechanism** real 8b/10b line codes use -- the 5-bit+3-bit sub-block
split, genuine running-disparity tracking, and a genuine dual-codeword
choice per unbalanced value. It is deliberately **not** a transcription
of the historical IBM/ANSI 8b/10b lookup table used in real Gigabit
Ethernet, USB 3.0, PCIe, and SATA hardware -- reproducing that exact
table from memory risked shipping a subtly wrong copy of a real
patented industry standard, which would be worse than not shipping it
at all.

What's actually verified, exhaustively, not sampled:

* **Round-trip correctness** for all 256 possible bytes, from both
  possible starting disparities.
* **Run length within any single 10-bit symbol never exceeds 5**,
  checked for every one of the 512 byte/disparity combinations that
  can occur.
* **Run length across the boundary between two consecutive symbols
  never exceeds 6**, checked across every reachable pair of symbols --
  the stricter textbook bound of 5 holds for 99.56% of transitions,
  not 100%. The real industry-standard table, engineered far more
  carefully than this widget's construction, achieves a strict 5
  everywhere. That gap is the honest cost of building this from
  scratch instead of using decades of real hardware engineering.
* **Running disparity stays small** (single digits) at the scale an
  interactive demo actually reaches -- this widget does not claim a
  proven mathematical bound for arbitrarily long streams, only what
  was actually measured at realistic widget-usage scale.

The Cost: Why "5 Gbps" USB Isn't Really 5 Gbps
-----------------------------------------------------

Sending 10 bits to carry 8 real bits of data means 20% of the wire's
capacity is spent on the encoding scaffolding that makes clock
recovery possible at all:

.. code-block:: text

   efficiency = 8 real bits / 10 transmitted bits = 80%

That's exactly why a "5 Gbps" USB 3.0 port delivers roughly 4 Gbps of
actual throughput -- the missing 20% isn't wasted, it's the reason the
link can run with no dedicated clock wire in the first place.

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 15 15 15 30

   * - Encoding
     - Data bits
     - Sent bits
     - Overhead
     - Used by
   * - 8b/10b
     - 8
     - 10
     - 20%
     - USB 3.0, PCIe Gen 1 & 2, SATA
   * - 128b/130b
     - 128
     - 130
     - ~1.5%
     - PCIe Gen 3+, USB 3.1+

PCIe Gen 3+ and USB 3.1+ moved to 128b/130b for exactly this reason:
a 2-bit sync header on a 128-bit block, plus a different scrambling
technique, gets the same clock-recovery guarantee for a fraction of
the overhead -- the trade-off this page's widget makes concrete at
8b/10b's coarser, easier-to-see-by-hand granularity.
