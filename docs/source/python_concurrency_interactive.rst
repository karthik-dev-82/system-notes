Multiprocessing vs Threading vs AsyncIO: Play With It
========================================================

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

Python gives you three different ways to do more than one thing at
once, and they are not interchangeable -- each one solves a different
kind of waiting. Picking the wrong one doesn't just underperform, it
can fail to help at all, silently.

* **CPU-bound** work is limited by how fast the processor can crunch
  numbers -- summing a list, resizing an image, parsing a huge file.
* **I/O-bound** work is limited by how long you sit around waiting for
  something else -- a network response, a disk read, a database query.
  The CPU is free the entire time; it just has nothing to do.

Play With It
------------------

The same 3 tasks, run four different ways: no concurrency at all
(the baseline), ``multiprocessing``, ``threading``, and ``asyncio``.
Toggle between an I/O-bound workload and a CPU-bound one, hit run, and
watch all four timelines unfold at once, side by side, so the
difference is something you see rather than something you're told.

.. raw:: html
   :file: _static/concurrency_models_widget.html

Why the GIL Changes Everything
--------------------------------------

CPython has a **Global Interpreter Lock (GIL)**: only one thread can
execute Python bytecode at a time, no matter how many CPU cores the
machine has or how many threads the program spins up. A single-process
Python program -- whether it uses 1 thread or 50 -- can never exceed
100% CPU utilization. This single fact explains everything the widget
shows:

.. list-table::
   :header-rows: 1
   :widths: 22 26 26 26

   * -
     - ``multiprocessing``
     - ``threading``
     - ``asyncio``
   * - What actually runs in parallel
     - Separate OS processes, separate interpreters, separate memory
     - Nothing -- the GIL allows exactly one thread at a time
     - Nothing -- one thread, one event loop
   * - Who decides when to switch
     - The OS scheduler, across cores
     - The OS scheduler, pre-emptively, at any point
     - The task itself, only at an ``await``
   * - Good for CPU-bound work?
     - Yes -- the only one of the three that is
     - No -- same total time as no concurrency at all
     - No -- same total time as no concurrency at all
   * - Good for I/O-bound work?
     - Works, but heavier than it needs to be
     - Yes
     - Yes, and scales to far more concurrent tasks

Threading and asyncio both solve I/O-bound waiting by freeing up the
CPU while a task is blocked -- they just differ in *who* decides the
handoff happens. A thread can be interrupted by the OS at essentially
any instruction. A coroutine only ever gives up control at an explicit
``await`` -- which is exactly why a CPU-bound coroutine with no
``await`` in it blocks the *entire* event loop until it's done, a
failure mode threading doesn't have.

Kitchen Analogy
---------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 45 35

   * - Model
     - Setup
     - Kitchen analogy
   * - Multiprocessing
     - Multiple processes, high CPU utilization
     - 10 kitchens, 10 chefs, 10 dishes to cook
   * - Threading
     - Single process, multiple threads, pre-emptive multitasking
     - 1 kitchen, 10 chefs, 10 dishes -- crowded whenever all ten
       chefs are in the kitchen at once
   * - AsyncIO
     - Single process, single thread, cooperative multitasking
     - 1 kitchen, 1 chef, 10 dishes -- efficient only because the chef
       starts dish 2 while dish 1 is in the oven, instead of standing
       and staring at it

Caveat: What ``htop`` Shows You
--------------------------------------

``htop`` will sometimes show a single multi-threaded Python program as
several separate PIDs, making it look like several processes are
running when it's actually one process with several threads. ``top``
doesn't have this problem. Worth knowing before you go looking for a
process leak that isn't there.
