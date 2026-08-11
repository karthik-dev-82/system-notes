Observer Pattern: Play With It
=====================================

A subject keeps a list of observers and calls each one back whenever
something happens. The pattern itself is simple enough to state in a
sentence -- the part that actually bites people in real C++ is
lifetime: what does the subject do when an observer is destroyed
without ever telling it?

.. raw:: html
   :file: _static/cpp_observer_widget.html

Two Ways to Store the Observer List
---------------------------------------------

Unsafe mode above stores each observer as a raw pointer -- exactly
this:

.. code-block:: cpp

   struct Subject {
       std::vector<Observer*> observers;
       void notify(int price) {
           for (auto* o : observers) o->update(price);   // no liveness check
       }
   };

Destroy an observer without unsubscribing it first, and that pointer
is still sitting in ``observers`` pointing at freed memory. The next
``notify()`` walks straight into it. This isn't a hypothetical: the
exact shape of this code, compiled with ``-fsanitize=address`` and run
against that exact sequence, reports a genuine
``AddressSanitizer: heap-use-after-free`` the instant the loop reaches
the destroyed observer -- not a simulated error state, a real one.
Observers earlier in the list still get their update first; observers
later in the list never run at all, because the process is gone by
the time the loop would reach them.

Safe mode replaces the raw pointer with a ``std::weak_ptr``:

.. code-block:: cpp

   struct Subject {
       std::vector<std::weak_ptr<Observer>> observers;
       void notify(int price) {
           for (auto it = observers.begin(); it != observers.end(); ) {
               if (auto sp = it->lock()) { sp->update(price); ++it; }
               else it = observers.erase(it);   // expired -- dropped safely, nothing dereferenced
           }
       }
   };

A ``weak_ptr`` doesn't keep its target alive, and it doesn't go
dangling when the target dies either -- ``lock()`` returns a live
``shared_ptr`` if the object still exists, or an empty one if it
doesn't, with no way to touch freed memory either way. This is the
standard, idiomatic C++ answer to "the subject and its observers don't
agree on who's responsible for lifetime," not a trick specific to this
widget.

The Discipline That Works Without weak_ptr
---------------------------------------------------

Unsubscribing before destroying an observer avoids the bug in *either*
mode -- try it in the widget. The problem was never "raw pointers are
wrong," it's that nothing enforces remembering to unsubscribe, and the
consequence of forgetting is silent until something happens to walk
over that exact pointer. ``weak_ptr`` doesn't make the discipline
unnecessary so much as make it unnecessary to enforce by hand.

See :doc:`cpp_smart_pointers_interactive` for ``weak_ptr`` on its own,
without an Observer's subject/notify machinery around it -- just the
strong-count/weak-count/``lock()`` mechanism by itself, next to
``unique_ptr`` and ``shared_ptr`` for comparison.

See :doc:`cpp_command_interactive`, :doc:`cpp_singleton_interactive`,
:doc:`cpp_strategy_interactive`, and :doc:`cpp_decorator_interactive` for
the other modern-C++ pattern widgets in this series.
