RAII & Smart Pointers: Play With It
==========================================

:doc:`cpp_memory_interactive` ended with three bugs that all trace
back to the same root cause: a raw pointer carries no information
about who owns the memory it points to, or for how long. This page is
the fix -- two separate demos, one per smart pointer type, because
they solve genuinely different ownership problems.

* **``unique_ptr`` says "exactly one owner."** Copying one is a
  compile error, not a runtime rule you have to remember. Its
  destructor deletes whatever it owns automatically, on every exit
  path -- which directly closes the heap-leak bug from the previous
  page.
* **``shared_ptr`` says "however many owners, until the last one
  leaves."** A reference count tracks how many copies of a
  ``shared_ptr`` point at the same block; it's only freed when that
  count hits zero. That
  flexibility is genuinely useful -- and has exactly one well-known way
  to go wrong, covered in the second demo below.

unique_ptr: Exclusive Ownership
--------------------------------------

.. raw:: html
   :file: _static/cpp_unique_ptr_widget.html

The first tab replays the heap-leak scenario from the memory page,
side by side with its fix: a raw pointer only gets freed on whichever
exit path happens to contain ``delete``, so an early return above it
is a leak waiting to happen. A ``unique_ptr``'s destructor runs no
matter which path leaves the function -- there's no line to forget.

The second tab is about the other half of what makes ``unique_ptr``
safe: it cannot be copied, only moved. ``std::move`` doesn't duplicate
anything -- it transfers the underlying pointer to the new owner and
leaves the old variable empty, so "two owners, one block" (the
use-after-free/double-free bug from the previous page) becomes a
state the type genuinely cannot represent, not a rule you have to
remember to follow.

shared_ptr: Reference-Counted Shared Ownership
--------------------------------------------------------

.. raw:: html
   :file: _static/cpp_shared_ptr_widget.html

The first tab is the mechanism itself: every copy increments a shared
count, every destruction decrements it, and the block is freed on
whichever destruction happens to bring the count to zero -- not
necessarily the one you'd expect, and that's fine, because it's
correct regardless of order.

The second tab is the tradeoff that comes with that flexibility.
Reference counting only works if the count can actually reach zero --
and two objects each holding a ``shared_ptr`` to the other guarantee it
never will, even after every external reference is gone. Both objects
become unreachable garbage that the program can never free again, a
real and common leak shape in real codebases (parent/child trees where
the child also points back to the parent are the classic example).
The fix in the demo is the standard one: make the back-reference a
``weak_ptr`` instead. A ``weak_ptr`` observes an object without
extending its lifetime, so it never contributes to the cycle -- the
moment the "real" (``shared_ptr``) owners are gone, the object frees,
exactly like it should.

.. code-block:: cpp

   struct Node {
       std::shared_ptr<Node> next;   // owns the next node
       std::weak_ptr<Node> prev;      // observes the previous node, doesn't own it
   };

The Underlying Theme
--------------------------

Both smart pointers are solving the same problem the raw-pointer bugs
on the previous page exposed -- memory whose lifetime isn't tied to
anything that reliably cleans it up -- just with different ownership
models. ``unique_ptr`` picks the simplest one that works whenever it
can (exactly one owner); ``shared_ptr`` exists for the cases where
ownership is genuinely shared and can't be simplified away. Neither
one is "smarter" than the other in the abstract -- the right choice is
whichever ownership model actually matches what your code is doing.
