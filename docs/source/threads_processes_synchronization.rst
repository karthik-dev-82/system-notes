Threads, Processes & Synchronization in Linux
====================================================

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

Processes vs Threads
--------------------------

**Analogy: restaurant kitchen.**

* **Process** = an entire restaurant kitchen. Has its own space and
  equipment, can't directly share ingredients with other kitchens, and
  is expensive to build a new one of.
* **Thread** = a chef working in that kitchen. Multiple chefs share the
  same kitchen space, share ingredients, tools, and the stove (memory),
  and it's easy to hire more chefs for the same kitchen.

.. uml::

   !theme plain
   package "Process (Kitchen)" #LightBlue {
     rectangle "Thread 1 (Chef)" as t1 #LightGreen
     rectangle "Thread 2 (Chef)" as t2 #LightGreen
     rectangle "Thread 3 (Chef)" as t3 #LightGreen
     note bottom of t1
       All threads share
       the same kitchen
       (memory space)
     end note
   }
   note right of "Process (Kitchen)"
     Contains:
     Memory space (ingredients)
     File handles (equipment)
     System resources
     ..
     Isolated from other processes
   end note

Key differences:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 25 50

   * - Aspect
     - Process
     - Thread
   * - Memory
     - Separate
     - Shared
   * - Creation Cost
     - High
     - Low
   * - Communication
     - Slow (IPC needed)
     - Fast (shared memory)
   * - Crash Impact
     - Isolated
     - Crashes whole process

The Synchronization Problem
---------------------------------

**Why do we need synchronization?**

Imagine 3 chefs (threads) trying to update the same recipe book
(shared variable) at once:

.. code-block:: text

   Chef 1 reads:  salt = 2
   Chef 2 reads:  salt = 2
   Chef 1 writes: salt = 3
   Chef 2 writes: salt = 3

   Result: salt = 3 (should be 4!)

This is called a **race condition** -- the result depends on
unpredictable timing.

Mutex (Mutual Exclusion)
------------------------------

**Analogy: bathroom key.** Only one person can hold the bathroom key.
If someone's using it, you wait.

.. uml::

   !theme plain
   rectangle "Mutex (Key)" #LightSalmon
   rectangle "Thread A" #LightBlue
   rectangle "Thread B" #LightBlue
   rectangle "Thread C" #LightBlue

   "Thread A" --> "Mutex (Key)": lock()
   "Mutex (Key)" --> "Thread A": Got key!
   "Thread B" -right-> "Mutex (Key)": lock()
   "Thread C" -right-> "Mutex (Key)": lock()
   note right of "Thread B"
     Waiting...
     (blocked)
   end note
   note right of "Thread C"
     Waiting...
     (blocked)
   end note

.. code-block:: cpp

   #include <mutex>
   #include <thread>

   std::mutex bathroom_key;
   int counter = 0;

   void increment_safely() {
       bathroom_key.lock();      // Get the key
       counter++;                // Use the bathroom (critical section)
       bathroom_key.unlock();    // Return the key
   }

   // Better: RAII style (auto-unlock)
   void increment_safer() {
       std::lock_guard<std::mutex> guard(bathroom_key);
       counter++;
       // Key automatically returned when guard goes out of scope
   }

Semaphore
--------------

**Analogy: parking lot with N spaces.**

* **Mutex** = 1 parking space (binary: locked/unlocked)
* **Semaphore** = N parking spaces (counting: 0 to N)

.. uml::

   !theme plain
   rectangle "Semaphore (3 spaces)" #GreenYellow
   rectangle "Thread 1" #LightGreen
   rectangle "Thread 2" #LightGreen
   rectangle "Thread 3" #LightGreen
   rectangle "Thread 4" #LightBlue
   rectangle "Thread 5" #LightBlue

   "Thread 1" --> "Semaphore (3 spaces)": wait()
   "Thread 2" --> "Semaphore (3 spaces)": wait()
   "Thread 3" --> "Semaphore (3 spaces)": wait()
   note top of "Semaphore (3 spaces)"
     Spaces: 0 / 3
     (All full)
   end note
   "Thread 4" -down-> "Semaphore (3 spaces)": wait()
   "Thread 5" -down-> "Semaphore (3 spaces)": wait()
   note bottom of "Thread 4"
     Blocked
     (waiting for space)
   end note

.. code-block:: cpp

   #include <semaphore>

   std::counting_semaphore<3> parking_lot(3);  // 3 spaces available

   void park_car() {
       parking_lot.acquire();   // Take a space (blocks if full)
       // ... use parking space ...
       parking_lot.release();   // Free a space
   }

   std::binary_semaphore bathroom(1);  // Like mutex, but simpler

Condition Variable
------------------------

**Analogy: pizza delivery alert.** You don't want to check the door
every second. You wait, and the doorbell rings when pizza arrives.

.. uml::

   !theme plain
   actor "Producer (Pizza Chef)" as P #LightGreen
   actor "Consumer (You)" as C #LightBlue
   rectangle "Condition Variable (Doorbell)" as CV #LightSalmon

   C -> CV: wait()
   note right of C
     Goes to sleep
     (not wasting CPU)
   end note
   P -> CV: notify()
   note left of P
     Pizza ready!
     Ring doorbell
   end note
   CV -> C: Wake up!
   note right of C
     Check for pizza
   end note

.. code-block:: cpp

   #include <condition_variable>
   #include <queue>

   std::mutex mtx;
   std::condition_variable doorbell;
   std::queue<int> pizza_queue;

   // Producer (chef)
   void make_pizza() {
       std::lock_guard<std::mutex> lock(mtx);
       pizza_queue.push(42);
       doorbell.notify_one();  // Ring doorbell!
   }

   // Consumer (you)
   void eat_pizza() {
       std::unique_lock<std::mutex> lock(mtx);
       doorbell.wait(lock, []{ return !pizza_queue.empty(); });  // Sleep until pizza arrives
       int pizza = pizza_queue.front();
       pizza_queue.pop();
   }

Comparison Chart
----------------------

.. uml::

   !theme plain
   rectangle "Mutex" #LightBlue
   rectangle "Binary Semaphore" #LightGreen
   rectangle "Counting Semaphore" #GreenYellow
   rectangle "Condition Variable" #LightSalmon

   note right of "Mutex"
     Use when:
     ..
     Protecting shared data
     One at a time access
     Same thread locks/unlocks
   end note
   note right of "Binary Semaphore"
     Use when:
     ..
     Signaling between threads
     Different threads can signal
     Simpler than mutex
   end note
   note right of "Counting Semaphore"
     Use when:
     ..
     Limited resource pool
     (connection pool, thread pool)
     N simultaneous accesses
   end note
   note right of "Condition Variable"
     Use when:
     ..
     Waiting for event/state change
     Producer-consumer patterns
     Efficient sleeping (no busy-wait)
   end note

Deadlock -- The Deadly Embrace
------------------------------------

**Analogy: two people in a doorway.** Both say "after you" forever, or
both try to push through at once.

.. uml::

   !theme plain
   rectangle "Thread A" #LightBlue
   rectangle "Thread B" #LightSalmon
   rectangle "Lock 1" #GreenYellow
   rectangle "Lock 2" #GreenYellow

   "Thread A" -> "Lock 1": holds
   "Thread B" -> "Lock 2": holds
   "Thread A" --> "Lock 2": wants
   "Thread B" --> "Lock 1": wants
   note bottom of "Thread A"
     Deadlock!
     Both threads stuck forever
   end note

**Prevention:** always lock in the same order.

.. code-block:: cpp

   // BAD - Can deadlock
   void thread_A() {
       lock1.lock();
       lock2.lock();
   }
   void thread_B() {
       lock2.lock();  // Different order!
       lock1.lock();
   }

   // GOOD - Same order everywhere
   void thread_A() {
       lock1.lock();
       lock2.lock();
   }
   void thread_B() {
       lock1.lock();  // Same order
       lock2.lock();
   }

Quick Reference
---------------------

Choose your tool:

* One chef at a time? -> Mutex
* Limited seats? -> Counting Semaphore
* Signal between threads? -> Binary Semaphore or Condition Variable
* Wait for a condition efficiently? -> Condition Variable

Golden rules:

* Always unlock what you lock
* Use RAII (``lock_guard``, ``unique_lock``)
* Lock in consistent order
* Keep critical sections small
