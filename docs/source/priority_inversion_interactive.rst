Priority Inversion: Play With It
====================================

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

The Building Blocks First
--------------------------------

Priority inversion only makes sense once two other embedded-systems
ideas are in place:

* **Preemption**: the scheduler can forcibly pause a running task to
  give the CPU to a higher-priority one, without asking permission --
  like an ambulance behind you on the road. You don't finish your
  turn first; you pull over immediately.
* **Mutex**: a lock that only one task can hold at a time, protecting
  a piece of shared data or hardware the same way a single café toilet
  key does -- whoever has the key is inside, everyone else waits.

Put those two together and something surprising falls out: a
*low*-priority task holding a mutex can end up blocking a
*high*-priority task for far longer than the high-priority task's own
importance should ever allow.

What Actually Goes Wrong
--------------------------------

* A **low-priority** task acquires a mutex and starts its critical
  section.
* A **high-priority** task arrives, needs the same mutex, and blocks.
  So far, expected -- the mutex is doing its job.
* A **medium-priority** task arrives. It has nothing to do with the
  mutex at all. But because it outranks the low-priority task, the
  scheduler preempts the low-priority task to run it.
* The low-priority task never gets the CPU back long enough to finish
  its critical section and release the mutex. The high-priority task
  -- despite being the most important task in the entire system --
  waits for however long the medium-priority work takes. Its priority
  has effectively been inverted to the *lowest* in the system.

This crashed NASA's **Mars Pathfinder** rover on the Martian surface
in 1997: a low-priority bus management task, a high-priority bus
scheduler task, and a medium-priority communications task, in exactly
this configuration. The rover kept hitting a watchdog timeout and
resetting itself. The fix -- enabling priority inheritance, a feature
already present but switched off in the rover's RTOS -- was uplinked
to Mars and resolved it remotely.

Play With It
------------------

Toggle priority inheritance on and off, then drag the medium-priority
task's workload up and down. With inheritance **off**, watch
BusScheduler's completion tick grow right along with how much
unrelated work CommsTask has to do. With inheritance **on**, watch it
stay exactly where it is across that entire workload range -- verified
here by rerunning this exact scenario at every value the slider
allows, not just one anecdotal setting. (That invariance is specific
to workload on the *already-blocked* path; a medium-priority task
that delays BusScheduler *before* it ever reaches the mutex isn't
something priority inheritance protects against, since inheritance
only ever helps once a lower-priority task is actually holding the
contested lock.)

.. raw:: html
   :file: _static/priority_inversion_widget.html

The Fix: Priority Inheritance
------------------------------------

The moment a high-priority task blocks on a mutex, the task currently
holding that mutex temporarily **inherits** the blocked task's
priority. For as long as it holds the mutex, nothing below that
borrowed priority level can preempt it -- which means it gets to
finish its critical section and release the mutex as quickly as its
own work actually requires, immune to however much lower- and
medium-priority work happens to be queued up elsewhere.

This doesn't eliminate waiting. The high-priority task still has to
wait for the mutex holder's critical section to finish -- that part
was always going to happen. What priority inheritance eliminates is
the *unbounded* extra wait caused by unrelated medium-priority work
getting in the way.

Related Terms From the Same Topic
-----------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 75

   * - Term
     - What it means
   * - Interrupt / ISR
     - A signal that pauses normal execution to run a short handler
       function immediately, then resumes exactly where it left off
   * - Polling vs. interrupt-driven
     - Repeatedly asking "is it ready yet?" in a loop (wastes CPU)
       versus being tapped on the shoulder only when something is
       actually ready
   * - Race condition
     - Two tasks read-modify-write the same shared data at once, and
       the result depends on unpredictable timing -- what a mutex
       exists to prevent
   * - Jitter
     - Variation in how consistently a task runs on schedule -- a
       task due every 10ms that actually fires anywhere from 8-13ms
       has high jitter
   * - Hard vs. soft real-time
     - Hard real-time: missing a deadline is a failure (airbags,
       pacemakers). Soft real-time: missing a deadline just degrades
       quality (video streaming, games)
