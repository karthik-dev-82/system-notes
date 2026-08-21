RAII & Smart Pointers: Play With It
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
safe: it cannot be copied, only moved. ``std::move`` itself doesn't
transfer anything -- it just marks the source as movable so the move
constructor can steal its pointer and leave the old variable empty
(see :doc:`cpp_move_semantics_interactive` for exactly how that
split works). Either way, "two owners, one block" (the
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

See :doc:`cpp_smart_pointers_interactive` for all three ownership
models -- including ``weak_ptr`` with its own dedicated demo instead
of just the code block above -- side by side.
