Threads, Processes & Synchronization in Linux
====================================================

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
