Python Sequences: List, Stack, Queue & Deque
===================================================

``list``, "stack", "queue" and ``deque`` all answer the same question
-- *in what order do things come out?* -- but they differ in exactly
one thing: which end(s) you're allowed to touch cheaply. Get that one
question right and the rest follows:

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

Play With It
------------------

Three tabs. The numbers and formulas in all three are not
approximations -- they're taken directly from CPython's own source
(``Objects/listobject.c`` and the real, current growth-rate comment
for ``list.append``), verified against the upstream repository rather
than recalled from memory.

.. raw:: html
   :file: _static/py_sequences_widget.html

Why Append Is O(1) *Amortized*, Not O(1)
------------------------------------------------

CPython does not grow a list by exactly one slot per ``append()`` --
that would make every single append touch the allocator. Instead it
over-allocates, following (as of Python 3.11+) this exact rule from
``list_resize``:

.. code-block:: text

   new_allocated = (newsize + newsize // 8 + 6) rounded down to a multiple of 4

Appending one element at a time from empty, that produces the capacity
sequence ``0, 4, 8, 16, 24, 32, 40, 52, 64, 76, ...`` -- most appends
land in already-reserved space and cost nothing but a write; only the
rare append that overflows the current capacity pays for a fresh
allocation and a full copy. Average the cheap and expensive appends
together over a long run and you get O(1) *amortized* -- which is a
precise claim, not a hand-wave. (Versions before 3.11 used a different
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

Why Deque Isn't Just "A Faster List"
------------------------------------------

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

Next: Python's Hash-Based Structures
------------------------------------------

``dict`` and ``set`` solve a completely different problem --
answering "is X in here?" without scanning -- using open-addressing
hash tables under the hood. See :doc:`python_hashing_interactive` for
the real collision-probing sequence CPython uses, why ``dict`` keeps
insertion order and ``set`` does not, and where the two implementations
genuinely diverge.
