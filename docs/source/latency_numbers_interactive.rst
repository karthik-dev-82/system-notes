Latency Numbers Every Programmer Should Know: Play With It
==============================================================

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

Every layer of a computer is dramatically slower than the layer above
it -- a CPU register, an L1 cache line, RAM, an SSD, another machine
in the same datacenter, a machine on the other side of the planet.
Jeff Dean's 2012 "latency numbers every programmer should know" put
hard nanosecond figures on that hierarchy and became one of the most
cited cheat sheets in software engineering. The relative *shape* of
that hierarchy hasn't changed -- but more than a decade of DDR5,
NVMe, and datacenter networking has moved several of the absolute
numbers by an order of magnitude, while a couple of them, tellingly,
haven't moved at all.

Play With It
------------------

Fourteen operations, plotted on a single logarithmic ruler from a
tenth of a nanosecond to a full second. Toggle between the 2012
baseline and representative 2024 hardware and watch the dots slide --
some barely move, some jump most of a decade. Click any dot (or table
row) to make that operation "1 second" and see every other operation
rescaled onto a human timescale underneath.

.. raw:: html
   :file: _static/latency_numbers_widget.html

Where These Numbers Come From
------------------------------------

The "classic" column is the original Jeff Dean / Peter Norvig list
from 2012, exactly as it has circulated for over a decade. The
"modern" column uses representative figures for a 2024-2025 x86-64
system (AMD Zen 5-class CPU, DDR5 memory, PCIe NVMe SSD) --
order-of-magnitude figures typical of that hardware class, not one
specific benchmark run on one specific machine. Sourced from
`published Zen 5 benchmarks <https://erickguan.me/2024/latency-values>`_
and cross-checked against the actively-maintained
`napkin-math <https://github.com/sirupsen/napkin-math>`_ project's
measured storage and network figures.

What Actually Changed (and What Didn't)
------------------------------------------------

Sort the numbers into three groups and a pattern falls out immediately:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 45 30

   * - Category
     - What's in it
     - Why
   * - **Faster now, substantially** (3x-10x)
     - SSD reads (random and sequential), datacenter round trips,
       sequential disk reads
     - Real engineering progress: NVMe over spinning disks and even
       SATA SSDs, 10/25/100 Gbps datacenter fabrics over 1 Gbps
   * - **Faster now, modestly** (1.4x-1.5x)
     - Main memory, compression
     - DDR5 over DDR3 narrowed end-to-end latency, but not
       dramatically -- most of the win from newer RAM generations is
       in bandwidth, not this kind of single-access latency
   * - **Essentially unchanged**
     - Mutex lock/unlock, HDD seek time, a packet's round trip to
       Europe
     - Two different kinds of physical floor: HDD seek is still
       bound by how fast an actuator arm can physically move, and a
       cross-continent round trip is bound by the speed of light in
       fiber -- neither has a faster substitute
   * - **Slightly *slower* now**
     - L1 cache reference, branch mispredict
     - CPU clock speeds plateaued around 2005 (the "power wall").
       Modern chips get their speedups from more cores and wider
       pipelines, not faster clocks -- so a handful of measured in
       raw nanoseconds actually got a little worse, even though
       *everything downstream of the CPU* got dramatically faster

That last row is the counter-intuitive part: it's tempting to assume
"computers get faster every year" applies uniformly, but the CPU
core's own local operations have been essentially flat -- or slightly
regressed -- for two decades. All of the visible progress in this
list happened one or more layers away from the core, in memory
controllers, storage interfaces, and network fabric.

See Also
-------------

:doc:`page_cache_interactive` puts the SSD-vs-memory gap from this
page to work -- it's the exact latency cliff the page cache exists to
hide. :doc:`docker_packet_journey_interactive` and
:doc:`tcp_congestion_control_interactive` dig into what happens during
that "round trip within same datacenter" / cross-region row once a
packet actually leaves the machine.
