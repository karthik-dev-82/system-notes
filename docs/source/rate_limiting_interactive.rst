Rate Limiting: Play With It
==================================

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
