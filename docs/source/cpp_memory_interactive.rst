Stack, Heap & Pointers: Play With It
==========================================

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
