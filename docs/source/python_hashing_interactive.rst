Python Hashing: Play With It
============================

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
