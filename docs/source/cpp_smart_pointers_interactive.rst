unique_ptr vs. shared_ptr vs. weak_ptr: Play With It
===========================================================

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

:doc:`cpp_raii_smart_pointers_interactive` covers ``unique_ptr`` and
``shared_ptr`` each in their own dedicated demo, and mentions
``weak_ptr`` as the fix for one specific bug (a reference cycle). This
page puts all three side by side instead, with ``weak_ptr`` getting
the same first-class interactive treatment the other two already
have -- because the question that actually matters when choosing
between them isn't "which is smarter," it's "who is allowed to keep
this object alive, and who is only allowed to ask about it."

.. raw:: html
   :file: _static/cpp_smart_pointers_widget.html

unique_ptr: No Bookkeeping, Because There's Nothing to Book
-------------------------------------------------------------------------

.. code-block:: cpp

   auto a = std::make_unique<Widget>();
   auto b = std::move(a);   // ownership transfers; a is now empty
   // auto c = b;           // compile error: unique_ptr has no copy constructor

There's no reference count here because there's nothing to count --
exactly one ``unique_ptr`` can ever own the object at a time, and the
compiler enforces it by simply not giving you a copy constructor to
call. Moving is still allowed (and free -- it just steals the pointer
and empties the source), which is why the widget's "Move" button works
in both directions but "Try to copy it" never does.

shared_ptr and weak_ptr: One Control Block, Two Kinds of Reference
-------------------------------------------------------------------------------------

Every ``shared_ptr`` to the same object shares one small piece of
bookkeeping -- the *control block* -- holding two independent counts:

.. code-block:: cpp

   auto sp1 = std::make_shared<Widget>();   // strong count: 1
   auto sp2 = sp1;                          // strong count: 2 (copy)
   std::weak_ptr<Widget> wp = sp1;          // weak count: 1 -- strong count UNCHANGED

   sp1.reset();
   sp2.reset();                              // strong count: 0 -> Widget destroyed
   // wp.expired() is now true

   if (auto locked = wp.lock()) {
       // never runs -- lock() returns an empty shared_ptr once expired
   }

The **strong count** is the only thing that decides whether the
object is alive: it hits zero, the object is destroyed, full stop,
regardless of how many ``weak_ptr``\ s are still watching. The **weak
count** doesn't get a vote -- a ``weak_ptr`` can only ever ask
``.lock()`` for a real, temporary ``shared_ptr`` if the object still
happens to be alive when it asks, and gets a safely empty answer back
if it isn't. That's the entire mechanism the widget's "copy a
shared_ptr" button disabling itself demonstrates: once the strong
count is zero, there is nothing left to copy from -- ``lock()`` is the
only path back to a real owner, and it's built to fail safely rather
than hand back a dangling one.

Which One Do You Actually Reach For?
-------------------------------------------------

* **``unique_ptr`` by default.** If ownership genuinely isn't shared,
  this is the whole answer -- no counting, no control block, nothing
  to get wrong.
* **``shared_ptr`` when ownership is genuinely shared** -- several
  parts of a program each need the object to outlive their own
  individual lifetime, and none of them is uniquely "the owner."
* **``weak_ptr`` when something needs to *observe* an object it
  doesn't own** -- a cache entry, a parent-child back-reference, an
  event subscriber -- specifically so that holding the reference can
  never be the reason the object stays alive. See
  :doc:`cpp_observer_interactive` for exactly this shape of problem,
  solved end to end with a real dangling-pointer bug and its fix.

See :doc:`cpp_raii_smart_pointers_interactive` for the heap-leak and
circular-reference bugs these types exist to close.
