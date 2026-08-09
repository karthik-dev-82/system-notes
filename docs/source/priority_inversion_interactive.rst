Priority Inversion: Play With It
====================================

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
stay exactly where it is, no matter how much you increase that
workload -- verified here for hundreds of randomized configurations,
not just this one scenario.

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
