Page Cache, the Affair Between Memory and Files: Play With It
==================================================================

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

Two problems, one solution. Disks (even fast NVMe ones) are orders of
magnitude slower than RAM, and multiple programs routinely need the
same file's contents at once -- every process on your machine that
uses a shared library needs its code in memory, but nobody wants 100
separate copies of ``libc.so`` sitting in RAM. Linux solves both with
one mechanism: the **page cache**, a single, system-wide, page-sized
cache of file contents that every process's file I/O goes through,
whether that process asked for it or not.

Play With It
------------------

Two processes, one shared file, one shared page cache. Access a chunk
cold and pay a real (simulated) disk-latency cost; access it again --
from either process -- and it's instant. Switch a process to
``mmap()`` and watch it skip the extra copy entirely. Write something
and watch it "succeed" instantly while it's still only in RAM -- then
hit the crash button before calling ``fsync()`` and watch that data
disappear for good.

.. raw:: html
   :file: _static/page_cache_widget.html

Latency Model Used In This Widget
-----------------------------------------

The 2008 source material this page is adapted from measured a
spinning hard drive's seek time at roughly 13.7 ms and called it "a
4-minute walk down the hall." Storage has changed more than almost
anything else in that time, so this widget uses representative
numbers for a 2020s x86-64 or Apple Silicon machine instead --
order-of-magnitude figures typical of that hardware class, not one
specific chip's datasheet:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 40 25 35

   * - Operation
     - Typical latency
     - What determines it
   * - Page cache &rarr; user buffer copy (4 KB)
     - ~0.2 &micro;s
     - RAM bandwidth, not latency -- this is "free" by comparison
   * - NVMe SSD, 4 KB random read/write
     - ~80-120 &micro;s
     - Flash access time + the NVMe/PCIe protocol round trip
   * - SATA SSD, 4 KB random read
     - ~100-200 &micro;s
     - Same flash, slower interface
   * - Spinning hard disk seek (2008-era, for scale)
     - ~10,000 &micro;s
     - Physically moving a read/write head across a spinning platter

The relative story hasn't changed even though the absolute numbers
have: a page cache hit is still on the order of *hundreds to
thousands of times* faster than an NVMe or SATA SSD miss, and *tens
of thousands of times* faster than the spinning-disk miss this
mechanism was originally designed around. NVMe's big contribution is
shrinking the penalty for a *miss* -- roughly 100x faster than those
spinning disks -- which is also why the page cache matters slightly
less than it used to, and considerably more than "slightly less"
still implies.

Why This Is the Answer to "Why Does I/O Block?"
-----------------------------------------------------------

:doc:`python_concurrency_interactive` shows *how* threading and
asyncio avoid wasting CPU time while a task waits on I/O. This page
shows *what that wait actually is*: a page-cache miss on the file (or
socket buffer) the program is reading from. The wait is real, it's
measured in real microseconds to milliseconds, and it happens whether
or not your code is written to cooperate with it -- concurrency
primitives don't make the disk faster, they just make sure the CPU
has something else to do while it catches up.

See Also
-------------

See :doc:`vma_paging_interactive` for how the page cache's pages get
backed by physical frames in the first place -- the page fault
mechanism there and the cache-population step here are the same
underlying machinery, and :doc:`process_memory_layout_interactive`
for where the memory-mapping segment that ``mmap()`` uses sits in a
process's address space.
