Multiprocessing vs Threading vs AsyncIO: Play With It
========================================================

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
