Multithreading: RAII Locking & std::scoped_lock
=======================================================

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
   </style>

**Analogy:** a kitchen with several cooks. More cooks means faster --
but if two grab the same knife at once (shared data), you get chaos.
The whole game is coordinating access.

**Core idea:** run code in parallel with ``std::thread``. The danger
is shared mutable data: protect it with a mutex, and use a lock guard
(RAII!) so the lock always releases. The mechanics of race conditions,
semaphores, condition variables, and a manual step-through deadlock
demo already live on :doc:`threads_sync_interactive` -- this page
picks up specifically where that one leaves off: the RAII locking
*types* themselves, and the one mechanism that solves deadlock
structurally rather than by discipline.

Start a Thread
--------------------

.. code-block:: cpp

   #include <thread>

   std::thread t([]{ std::cout << "hello from a thread\n"; });
   t.join();   // wait for it to finish (or t.detach() to let it run free)

A thread must be ``join``\ ed or ``detach``\ ed before it's destroyed,
or the program terminates.

Protect Shared Data With a Mutex (via RAII)
--------------------------------------------------------

.. code-block:: cpp

   std::mutex m;
   int counter = 0;

   void bump() {
       std::lock_guard<std::mutex> lock(m);  // locks now, unlocks at scope end
       ++counter;                            // safe -- only one thread at a time
   }

``lock_guard`` is RAII: it unlocks on every exit path, so you can't
forget -- unlike manual ``m.lock()`` / ``m.unlock()``.

The Two Classic Bugs
--------------------------

**Race condition** -- unprotected shared data, results depend on
timing. **Deadlock** -- two threads each hold a lock the other wants:

.. code-block:: cpp

   // Thread 1 locks A then B; Thread 2 locks B then A -- opposite order
   void thread1() { std::lock_guard<std::mutex> l1(m1); std::lock_guard<std::mutex> l2(m2); }
   void thread2() { std::lock_guard<std::mutex> l1(m2); std::lock_guard<std::mutex> l2(m1); }

:doc:`threads_sync_interactive`'s own deadlock tab lets you step
through exactly this scenario by hand, and contrasts it against
*always acquiring locks in the same order everywhere* -- a real,
correct fix that costs nothing but discipline. The widget below covers
the other real fix: a type that removes the discipline requirement
entirely.

Play With It: Why ``std::scoped_lock`` Can't Deadlock
------------------------------------------------------------------

.. code-block:: cpp

   // Deadlock-free even though the two threads request opposite order
   void safe1() { std::scoped_lock lock(m1, m2); }
   void safe2() { std::scoped_lock lock(m2, m1); }

``std::scoped_lock`` (C++17) doesn't avoid deadlock by enforcing a
consistent order -- it avoids it *algorithmically*. Internally it locks
the first mutex, then *tries* the second with ``try_lock``. If that
fails, it releases the first mutex and retries from scratch. That one
willingness to let go under contention is the entire mechanism -- both
columns below run the identical click sequence against the same
opposite-order setup; only the retry behavior differs.

.. raw:: html
   :file: _static/cpp_scoped_lock_widget.html

More Gotchas
------------------

.. code-block:: cpp

   // Holding a lock during slow work blocks everyone
   void bad() {
       std::lock_guard<std::mutex> lock(m);
       expensiveComputation();   // others wait the whole time
       shared = result;
   }
   // Do the slow part outside the lock instead
   void good() {
       auto r = expensiveComputation();   // no lock held
       std::lock_guard<std::mutex> lock(m);
       shared = r;                        // lock only the critical section
   }

* Keep critical sections tiny -- lock late, unlock early.
* Lock ordering: acquire multiple mutexes in a consistent order, *or*
  use ``scoped_lock``.
* For thread coordination ("wait until ready"), use a
  ``condition_variable`` with ``unique_lock`` -- see
  :doc:`threads_sync_interactive`'s condition-variable tab for the
  busy-wait-vs-notify comparison.

When NOT To
------------------

* The work is simple async with a result -- ``std::async`` and futures
  (:doc:`cpp_futures_promises_interactive`) are easier and safer.
* The data isn't actually shared, or is read-only -- no locks needed.

Remember
------------

#. ``std::thread`` runs code in parallel; always ``join`` or
   ``detach``.
#. Protect shared mutable data with a mutex.
#. Use ``lock_guard`` / ``scoped_lock`` (RAII) -- never manual
   lock/unlock.
#. Race condition = unprotected shared data; deadlock = bad lock
   ordering, or no fallback when ordering can't be guaranteed.
#. Keep critical sections tiny; lock late, unlock early.
#. ``scoped_lock`` solves multi-mutex deadlock structurally --
   ``try_lock`` the rest, release everything and retry on failure --
   so it doesn't need every caller to agree on an order.

See Also
--------------

:doc:`threads_sync_interactive` for the interactive race-condition,
semaphore, condition-variable, and manual deadlock step-through this
page deliberately doesn't repeat. :doc:`cpp_futures_promises_interactive`
for the higher-level, easier-to-reach-for alternative when you just
need a result back, not fine-grained thread control.
