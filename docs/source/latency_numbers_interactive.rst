Latency Numbers Every Programmer Should Know: Play With It
==============================================================

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
   * - **Faster now** (3x-25x)
     - Main memory, compression, SSD reads, datacenter round trips,
       sequential disk reads
     - Real engineering progress: DDR5 over DDR3, NVMe over spinning
       disks and even SATA SSDs, 10/25/100 Gbps datacenter fabrics
       over 1 Gbps
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
