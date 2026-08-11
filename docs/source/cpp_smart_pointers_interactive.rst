unique_ptr vs. shared_ptr vs. weak_ptr: Play With It
===========================================================

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
