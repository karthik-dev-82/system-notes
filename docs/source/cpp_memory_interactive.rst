Stack, Heap & Pointers: Play With It
==========================================

Three of C++'s most notorious bug classes -- a dangling reference to a
destroyed stack frame, a heap allocation that outlives every pointer
to it, and a heap block freed twice through two aliased pointers --
all come from the same root cause: a raw pointer is just an address.
It carries no information about who owns the memory it points to, how
long that memory will stay valid, or whether anyone else already freed
it. The compiler will not stop you from reading a pointer after its
target is gone; it will happily compile code that is, at runtime,
undefined behavior.

* **Stack memory is scoped to a function call.** Every local variable
  lives inside that call's *stack frame*, and the frame is destroyed
  the instant the function returns -- automatically, deterministically,
  no matter how the function exits. A pointer to a local variable is
  only meaningful while that frame still exists.
* **Heap memory is scoped to nothing but your own bookkeeping.** A
  block allocated with ``new`` stays allocated until something calls
  ``delete`` on it -- there is no automatic cleanup tied to scope the
  way there is on the stack. Lose the last pointer to a block without
  freeing it, and that memory is gone for the rest of the process's
  life. Free it twice, and you have corrupted the allocator's own
  internal bookkeeping.

Play With It
------------------

Three tabs, each a small piece of code stepped through one line at a
time, with the call stack and heap drawn live as they change. The
first two tabs pair a buggy version against its fix, so you can watch
the exact same shape of code behave completely differently depending
on one choice (return an address vs. return a value; delete before
the frame ends vs. never delete). The third tab has no "fix" toggle --
it exists to show what happens when two raw pointers alias the same
block, one frees it, and the other doesn't know.

.. raw:: html
   :file: _static/cpp_memory_widget.html

The Punchline of Tab 1
------------------------------

``make_dangling()`` declares ``local`` on its own stack frame and
returns ``&local`` -- the *address* of that variable. The moment the
function returns, its frame is destroyed, ``local`` no longer exists,
and the pointer ``p`` in ``main`` is left holding an address that
belongs to nobody. Dereferencing it with ``*p`` is undefined behavior:
it might print ``42`` (nothing has overwritten that stack memory yet),
it might print garbage, it might crash -- and a debug build and an
optimized build can genuinely disagree about which. Switch to "Return
By Value" and watch the same shape of code become completely safe:
``return local;`` copies the *value* out before the frame is
destroyed, so ``result`` in ``main`` is an independent ``int`` that
was never tied to the callee's frame in the first place.

.. code-block:: cpp

   int* make_dangling() {
       int local = 42;
       return &local;      // returning the ADDRESS of a local -- bug
   }

   int make_ok() {
       int local = 42;
       return local;       // returning a COPY of the value -- fine
   }

Why Tab 2 Matters
------------------------

``leaky()`` allocates a block with ``new int(10)`` and never calls
``delete``. When the function returns, the local pointer ``p`` is
destroyed along with the rest of its frame -- but the heap block it
pointed to is not a local variable, and nothing about the frame ending
frees it. Call ``leaky()`` three times and three separate blocks pile
up, unreachable and unfreeable for the rest of the program's life.
``correct()`` does the one thing differently that matters: it calls
``delete p;`` (and, defensively, sets ``p = nullptr;``) *before* the
frame ends, so nothing is ever orphaned no matter how many times it's
called.

This is the general shape of every memory leak: it is never really
about forgetting a keyword, it's about a piece of memory's lifetime
becoming decoupled from anything that will actually clean it up.

Why Tab 3 Is the Dangerous One
------------------------------------

Tabs 1 and 2 both involve a single pointer. Tab 3 shows why *aliasing*
makes this class of bug much harder to reason about: ``q = p;`` gives
two independent pointer variables the same target, and from that point
on, freeing the block through one of them says nothing to the other.
``delete p;`` frees the block; ``p`` is set to ``nullptr`` right after,
which looks responsible -- but ``q`` still holds the old address, has
no idea anything happened, and ``*q = 5`` silently writes through a
pointer to memory that isn't yours anymore (a **use-after-free**).
``delete q;`` compounds it into a **double-free**, corrupting the
allocator's own internal free-list rather than just leaking memory --
which is why real allocators actively try to detect and abort on it
(glibc: ``free(): double free detected in tcache 2``).

.. code-block:: cpp

   int* p = new int(10);
   int* q = p;      // q aliases the SAME block as p
   delete p;        // block freed -- q has no idea
   *q = 5;           // USE-AFTER-FREE
   delete q;         // DOUBLE-FREE

The fix in all three tabs traces back to the same idea: a raw pointer
should not be trusted to communicate ownership. That's exactly the gap
``std::unique_ptr`` and ``std::shared_ptr`` are designed to close --
one enforces "exactly one owner" at compile time, the other makes
shared ownership safe via reference counting instead of by convention.
See :doc:`threads_processes_synchronization` for how the same "shared
mutable state needs an explicit contract" theme shows up again once
multiple threads are involved.
