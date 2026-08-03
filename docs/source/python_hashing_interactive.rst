Python Hashing: dict & set
================================

``dict`` and ``set`` both answer "is this here, and can I get it in
O(1)?" using the same family of trick -- an *open-addressing hash
table* -- but they are two genuinely different implementations in
CPython, not one data structure wearing two hats. This page verifies
every number and formula below directly against CPython's own source
(``Objects/dictobject.c`` and ``Objects/setobject.c``), rather than
stating the usual textbook generalities about hash tables.

* **Both start at 8 slots** (``PyDict_MINSIZE`` / ``PySet_MINSIZE``)
  and both resize by rehashing every element into a bigger power-of-2
  table once they get too full.
* **Both resolve collisions with probing, not chaining** -- there's no
  linked list hanging off a bucket the way introductory hash table
  diagrams often show it. A collision means "try a different slot",
  computed from the key's hash.
* **They differ in exactly how full is "too full", exactly when they
  check, and exactly how they probe** -- and one of them remembers
  insertion order while the other flatly does not.

Play With It
------------------

Two tabs. Insert real keys one at a time and watch the actual
CPython probing sequence run -- including a real collision, a real
resize, and (in the set tab) a genuine before/after comparison of
insertion order vs. iteration order that will not match.

.. raw:: html
   :file: _static/py_hashing_widget.html

Why dict Keeps Insertion Order and set Doesn't
------------------------------------------------------

This is the single most consequential difference between the two, and
it comes from a real design change: since Python 3.6 (a language
guarantee since 3.7), ``dict`` is what CPython calls a *compact dict*
-- it keeps two structures instead of one: a sparse table that maps
``hash -> position``, and a dense array holding the actual
``(hash, key, value)`` entries in the order they were inserted.
Iterating a dict just walks the dense array -- insertion order falls
out for free, by construction.

``set`` was never rebuilt this way. It's a single flat table of slots,
and iterating it just walks that table from slot 0 upward. Where an
element lands depends on its hash and how many collisions it had to
probe past -- which has nothing to do with when it was added. The
widget's two order lists make this concrete: for the dict tab they are
always identical; for the set tab they diverge the moment a collision
or resize reshuffles anything.

.. code-block:: python

   d = {'z': 1, 'a': 2, 'm': 3}
   list(d)          # ['z', 'a', 'm']  -- always insertion order

   s = {'z', 'a', 'm'}
   list(s)          # order depends on hash values -- don't rely on it

Where dict and set Genuinely Diverge Internally
------------------------------------------------------

.. list-table::
   :header-rows: 1
   :widths: 25 37 38

   * -
     - ``dict``
     - ``set``
   * - Starting size
     - 8
     - 8
   * - Resize threshold
     - fill would exceed 2/3 of table size
     - ``fill * 5 >= mask * 3`` (~60%)
   * - When the check happens
     - **Before** inserting the item that would exceed it
     - **After** inserting the item that crosses it
   * - Growth target
     - smallest power of 2 >= ``used * 3``
     - smallest power of 2 > ``used * 4`` (or ``* 2`` past 50,000 elements)
   * - Collision probing
     - pure pseudo-random jump every step (``perturb`` recurrence)
     - up to 9 consecutive slots checked first, *then* the same jump
   * - Iteration order
     - insertion order, always (compact dict, 3.7+ guarantee)
     - table/slot order -- unspecified, can change across a resize

None of this is a simplification for teaching purposes -- it's what
the source actually does. The practical takeaway is simpler than the
mechanism: **both give you O(1) average membership testing**, which is
why ``x in my_set`` and ``key in my_dict`` don't scan; **only dict**
promises you'll get keys back in the order you put them in.

Set Algebra Is the Other Half of the Story
------------------------------------------------

The payoff for building a hash table that answers "is X in here?"
instantly is that set operations become genuinely cheap, not just
convenient syntax: ``a | b`` (union), ``a & b`` (intersection), and
``a - b`` (difference, order matters) all boil down to repeated O(1)
membership checks against the smaller of the two sets, rather than any
kind of nested scan. The bottom section of the ``set`` tab lets you
run all four against two small overlapping sets and see exactly which
elements qualify.

See :doc:`python_sequences_interactive` for the sequence-shaped half
of this reference -- ``list``, stack, queue, and ``deque`` -- which
covers the other common Python data structures using the same
source-verified approach.
