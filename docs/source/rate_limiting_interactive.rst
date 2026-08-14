Rate Limiting: Play With It
==================================

"Rate limiting" sounds like one idea, but there are five genuinely
different algorithms hiding behind that one word, and interviewers
love asking which one you'd pick and why. The honest answer is that
they don't just differ in implementation difficulty -- fired at the
exact same burst of requests, they disagree about which ones to let
through. This page makes that disagreement visible instead of
theoretical.

The Five Algorithms
--------------------------

* **Token bucket.** A bucket holds up to ``capacity`` tokens and
  refills continuously at a fixed rate. Every request costs one
  token; no token, no request.
* **Leaky bucket.** The mirror image: a bucket "fills" toward
  ``capacity`` with incoming requests and continuously "leaks" at a
  fixed rate. Full bucket, no request.
* **Fixed window counter.** Count requests in the current clock-aligned
  window (e.g. every wall-clock second); reset the count to zero the
  instant a new window starts.
* **Sliding window log.** Keep the actual timestamp of every recent
  request; a new one is allowed only if fewer than the limit fall
  within the trailing window, measured from *right now*, not from a
  clock boundary.
* **Sliding window counter.** An O(1)-memory approximation of the
  sliding log: blend a weighted fraction of the previous window's
  count into the current one instead of storing every timestamp.

Play With It
------------------

.. raw:: html
   :file: _static/rate_limit_widget.html

Reading the Comparison
------------------------------

All five are configured to the same nominal budget -- the same
``limit`` per ``window`` -- so the comparison is apples to apples.
Click **Boundary Burst** first: it fires ``limit`` requests right
before a window boundary and ``limit`` more right after. Fixed
window's count resets exactly at that boundary, so it happily allows
close to *double* the configured limit within a handful of
milliseconds -- not a tuning mistake, a structural property of resetting
on a clock edge instead of on elapsed time. Sliding log, which measures
from the actual current instant instead of a clock boundary, catches
almost all of the second wave. Sliding counter lands in between: much
closer to the log's true answer than to fixed window's blown budget,
because its weighted-average formula approximates the same fix in
constant memory instead of the log's per-timestamp storage.

Token bucket and leaky bucket, configured with matching capacity and
rate here, make *identical* allow/deny decisions on every burst you
throw at them -- try any preset and check their columns. That's not a
coincidence baked into this demo; it's a real mathematical duality
(worked out and verified in the widget's own test suite before it
shipped): headroom in one bucket is exactly capacity minus fill in the
other, at every instant. The practical difference between them in
production isn't the admission decision at all -- it's what happens to
the requests that get in. Token bucket just gates admission and lets
accepted requests through immediately, in whatever burst pattern they
arrived in. Leaky bucket is usually implemented as an actual queue
that releases admitted requests at the constant leak rate, which
smooths the *output* traffic even when the input was bursty, at the
cost of adding queueing latency.

Suggested Experiments
----------------------------

1. Reset, then click **Steady (within limit)** a few times in a row.
   Everything should stay green -- you're sending exactly at the
   configured rate.
2. Click **Sudden Burst**. Watch which algorithms have "room" saved up
   (token/leaky bucket, if the clock has been idle) absorb it
   instantly, versus which ones start denying right away.
3. Click **Idle, then Burst**. This fast-forwards the clock first --
   watch the token/leaky bucket "room" bars refill to full during the
   idle gap, then get spent by the burst that follows.
4. Click **Boundary Burst** and compare the request-by-request table
   for Fixed Window against Sliding Log side by side -- same requests,
   same instants, different verdicts.

Where This Shows Up
--------------------------

* See :doc:`cap_theorem_interactive` for a different kind of
  "do I answer or refuse" decision -- there, the trigger is a network
  partition rather than a request budget, but the shape of the
  decision (serve immediately vs. hold back for correctness) rhymes
  with the token-bucket-vs-strict-window tension here.
* See :doc:`bloom_filter_interactive` for another classic "gate in
  front of an expensive resource" primitive -- often used *alongside*
  rate limiting in the same request path (bloom filter to skip
  obviously-invalid keys cheaply, rate limiter to cap how many
  requests get through at all).
