CAN Bus Arbitration: Play With It
=====================================

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
