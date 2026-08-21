Python Sequences: Play With It
==============================

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

``list``, "stack", "queue" and ``deque`` all answer the same question
-- *in what order do things come out?* -- but they differ in exactly
one thing: which end(s) you're allowed to touch cheaply. (``list`` and
``deque`` are both genuine, formally-registered
``collections.abc.Sequence`` types -- checked directly with
``isinstance(collections.deque(), collections.abc.Sequence)``, which
is ``True``, even though a deque can't be sliced; the ABC only
requires ``__getitem__`` and ``__len__``, not slicing. "Stack" and
"queue" aren't separate types at all -- they're just LIFO/FIFO usage
patterns layered on top of those two.) Get that one question right and
the rest follows:

* **A list is a dynamic array.** Under the hood it's one contiguous
  block of memory, over-allocated with spare room at the end so most
  ``append()`` calls don't need to touch every other element -- but
  ``insert(0, x)`` still has to shift everything else out of the way,
  because there's no spare room *at the front*.
* **A stack is "whatever's on top comes off first" (LIFO).** In Python
  this is just a list used one way: ``append()`` to push,
  ``pop()`` to pop, both at the end, both O(1).
* **A queue is "whoever got here first leaves first" (FIFO).** Using a
  plain list for this is a common trap: popping from the *front* of a
  list (``pop(0)``) is O(n), not O(1), because everything behind index
  0 has to slide left. ``collections.deque`` exists specifically to
  make both ends O(1).

Three separate demos below, one per structure, each with its own
introduction right above it. The numbers and formulas in all three are
not approximations -- they're taken directly from CPython's own source
(``Objects/listobject.c``, ``Modules/_collectionsmodule.c``), verified
against the upstream repository rather than recalled from memory.

List: A Dynamic, Over-Allocated Array
--------------------------------------------

A Python ``list`` is not a linked list and not a fixed-size array --
it's a dynamic array: one contiguous block of memory that CPython
reallocates and copies into a bigger block whenever it runs out of
room, but *not* one slot at a time. That over-allocation is the whole
reason ``append()`` gets to call itself O(1) despite occasionally
having to copy the entire list.

.. raw:: html
   :file: _static/py_list_widget.html

Why Append Is O(1) *Amortized*, Not O(1)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CPython does not grow a list by exactly one slot per ``append()`` --
that would make every single append touch the allocator. Instead it
over-allocates, following (as of Python 3.9+) this exact rule from
``list_resize``:

.. code-block:: text

   new_allocated = (newsize + newsize // 8 + 6) rounded down to a multiple of 4

Appending one element at a time from empty, that produces the capacity
sequence ``0, 4, 8, 16, 24, 32, 40, 52, 64, 76, ...`` -- most appends
land in already-reserved space and cost nothing but a write; only the
rare append that overflows the current capacity pays for a fresh
allocation and a full copy. Average the cheap and expensive appends
together over a long run and you get O(1) *amortized* -- which is a
precise claim, not a hand-wave. (Versions before 3.9 used a different
formula and a different sequence -- the exact numbers have moved
across releases, but the geometric-over-allocation idea itself hasn't.)

The one thing that formula can't fix is ``insert(0, x)``: there's
never spare room *before* index 0, so every existing element has to
physically move one slot to the right, every single time, regardless
of how much capacity is reserved at the end. That's the concrete
reason ``insert(0, x)`` and ``pop(0)`` are O(n) while ``append()`` and
``pop()`` are O(1) amortized -- it's not an arbitrary rule to
memorize, it's a direct consequence of a list being one contiguous
block.

Stack: LIFO, Built From Nothing But a List
--------------------------------------------------

A stack doesn't need a dedicated Python type because it isn't really a
different data structure -- it's a *usage discipline* applied to a
list: only ever touch the end. ``append()`` pushes, ``pop()`` pops, and
because both happen at the end (the amortized-O(1) end, per the list
demo above), a stack built this way is genuinely cheap, not just
convenient syntax.

.. code-block:: python

   stack = []
   stack.append(x)   # push
   top = stack[-1]   # peek, without removing
   stack.pop()        # pop
   is_empty = not stack

LIFO shows up constantly once you know to look for it: **undo/redo**
history in an editor (undo pops the most recent action); **depth-first
search / backtracking** (explore one path fully, then pop back to the
last unexplored branch); matching **nested structure** -- brackets,
quotes, HTML/XML tags, function calls -- anything where "the thing that
opened most recently must close first." That last one isn't just an
analogy: it's *literally* how your CPU tracks function calls, one stack
frame pushed per call and popped on return -- see
:doc:`cpp_memory_interactive` for that exact same stack from the memory
side, watching real stack frames get pushed and destroyed.

The demo below uses the nested-structure case directly: checking
whether parentheses are balanced.

.. raw:: html
   :file: _static/py_stack_widget.html

Queue & Deque: FIFO, and Why the Naive Version Is a Trap
------------------------------------------------------------------

A queue is the LIFO idea flipped: whoever got in line first leaves
first. The trap is reaching for a plain ``list`` the same way you did
for a stack -- ``append()`` still works fine for enqueueing, but
dequeuing means removing from the *front*, and a list has no cheap way
to do that.

.. raw:: html
   :file: _static/py_queue_widget.html

Why Deque Isn't Just "A Faster List"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``collections.deque`` fixes the front-operation problem by not being a
single contiguous block at all -- it's a doubly-linked list of
fixed-size blocks (64 elements per block in CPython, verified against
``Modules/_collectionsmodule.c``). Removing from either end just
detaches an element from its block; nothing else in the structure has
to move, which is exactly why ``popleft()`` is genuinely O(1) instead
of "O(1) most of the time." The tradeoff is that a deque doesn't
support cheap random-access slicing the way a list does -- reaching
element ``N`` in the middle means walking blocks, not doing pointer
arithmetic on one array. Use whichever cost your code actually pays
for: random access and appends at one end favor ``list``; frequent
work at both ends favors ``deque``.

Isn't There Also a ``queue.Queue``?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes -- and it's worth being precise about what it actually is, because
it's easy to assume it's a third, separate implementation. It isn't.
Checked directly against CPython's ``Lib/queue.py``:

.. list-table::
   :header-rows: 1
   :widths: 25 30 45

   * - Class
     - Built on top of
     - What it actually adds
   * - ``queue.Queue``
     - ``collections.deque``
     - a ``Lock`` + ``Condition`` around ``put()``/``get()``, so
       multiple **threads** can safely hand off items, with optional
       blocking until space/an item is available
   * - ``queue.LifoQueue``
     - a plain ``list``
     - the same thread-safety wrapper, over a stack instead of a queue
   * - ``queue.PriorityQueue``
     - a ``list`` + the ``heapq`` module
     - the same wrapper again, over a binary heap ordered by priority

In other words: ``deque`` (this page) and ``list`` are the *underlying
data structures*; the entire ``queue`` module is a **thread-safety and
blocking-coordination layer** on top of exactly those structures, meant
for producer/consumer handoff between threads -- not a faster or
different way to store items. If you're not coordinating between
threads, reach for ``collections.deque`` directly, as this page does.
If you are, see :doc:`threads_processes_synchronization` for the
producer/consumer pattern ``queue.Queue`` is built to support.

Next: Python's Hash-Based Structures
------------------------------------------

``dict`` and ``set`` solve a completely different problem --
answering "is X in here?" without scanning -- using open-addressing
hash tables under the hood. See :doc:`python_hashing_interactive` for
the real collision-probing sequence CPython uses, why ``dict`` keeps
insertion order and ``set`` does not, and where the two implementations
genuinely diverge.
