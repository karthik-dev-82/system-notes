TCP vs. UDP: Play With It
=========================

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

     div.document div.admonition {
       background: #f7f6f2;
       border: 1px solid #cdd6cc;
       border-left: 4px solid #a67c1f;
       border-radius: 4px;
       padding: 14px 18px;
       margin: 4px 0 22px;
     }
     div.document div.admonition p.admonition-title {
       font-weight: 700;
       color: #a67c1f;
       margin: 0 0 8px;
       font-size: 0.72rem;
       letter-spacing: 0.06em;
       text-transform: uppercase;
     }
     div.document div.admonition p:last-child { margin-bottom: 0; }
     div.document div.admonition.warning,
     div.document div.admonition.attention,
     div.document div.admonition.caution { border-left-color: #b0432a; }
     div.document div.admonition.warning p.admonition-title,
     div.document div.admonition.attention p.admonition-title,
     div.document div.admonition.caution p.admonition-title { color: #b0432a; }
     div.document div.admonition.tip,
     div.document div.admonition.hint,
     div.document div.admonition.important { border-left-color: #3d5c3d; }
     div.document div.admonition.tip p.admonition-title,
     div.document div.admonition.hint p.admonition-title,
     div.document div.admonition.important p.admonition-title { color: #3d5c3d; }
   </style>

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
