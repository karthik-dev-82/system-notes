Python itertools: Play With It
=====================================

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
   </style>

``itertools`` is the standard library's toolkit of pre-built lazy
iterator combinators -- the same suspend/produce-on-demand idea from
:doc:`python_generators_interactive`, packaged as ready-made functions
instead of hand-written ``yield`` statements. This page picks three
with genuinely surprising, easy-to-get-wrong behavior, verified against
real CPython output before anything below was built -- not recalled
from memory.

``itertools.groupby``: Only Groups What's Already Adjacent
------------------------------------------------------------------------

The single most common ``groupby`` bug: it does **not** collect every
element with a matching key from anywhere in the sequence. It only
merges a run of *consecutive* equal elements -- the moment the key
changes, even briefly, the next matching element starts an entirely
new group.

.. code-block:: python

   import itertools

   data = ['a', 'a', 'b', 'a', 'a', 'b', 'b']

   [(k, list(g)) for k, g in itertools.groupby(data)]
   # [('a', ['a', 'a']), ('b', ['b']), ('a', ['a', 'a']), ('b', ['b', 'b'])]
   # FOUR groups -- the two 'a' runs never merge

   [(k, list(g)) for k, g in itertools.groupby(sorted(data))]
   # [('a', ['a', 'a', 'a', 'a']), ('b', ['b', 'b', 'b'])]
   # sort first, and now it's exactly one group per key

If you want "every element with this key, wherever it appears," sort
by that key first (or reach for ``collections.defaultdict``/``Counter``
instead) -- ``groupby`` alone is a streaming, single-pass tool, not a
full grouping operation.

``itertools.tee``: Splits One Iterator, Shares One Buffer
------------------------------------------------------------------------

``tee`` gives you *n* independent iterators over the same source
without re-running it *n* times. The catch: only one of them can
actually be "ahead" for free. If one consumer races far past the
other, ``tee`` has to buffer every element the slower one hasn't seen
yet -- confirmed directly against CPython's actual implementation
(``Modules/itertoolsmodule.c``): the buffer is a reference-counted
linked list, and a cached block is only freed once *every* child has
advanced past it. It genuinely grows while one reader leads and
shrinks back down the moment the other catches up -- not a fixed-size
cache, not unbounded forever.

.. code-block:: python

   a, b = itertools.tee(source, 2)
   next(a); next(a); next(a)   # a is now 3 ahead of b
   # those 3 values are held in a shared buffer -- the source itself
   # was only read 3 times, not 6, and b will get them from the buffer,
   # not a fresh read, once it catches up

Play With It
------------------

All three tabs below run the real algorithms live -- including
``groupby``'s consecutive-only grouping and ``tee``'s buffer actually
growing and shrinking as you pull from each reader independently.

.. raw:: html
   :file: _static/py_itertools_widget.html

``itertools.count`` / ``itertools.cycle``: Genuinely Infinite
------------------------------------------------------------------------

Both produce values forever -- there is no length, no natural end.
Always pair them with something that bounds them, like ``islice`` or
``zip`` against a finite iterable:

.. code-block:: python

   itertools.count(10, 5)          # 10, 15, 20, 25, ... forever
   itertools.islice(itertools.count(10, 5), 5)   # stop it at 5 values

   itertools.cycle(['x', 'y', 'z'])   # x, y, z, x, y, z, x, ... forever

``cycle`` has its own quiet cost: since it can't re-read its source a
second time, it has to remember every element from the first pass
through, so it only makes sense on something you're already willing
to hold in memory once.

A Short Aside: ``enumerate`` Is the Same Idea
------------------------------------------------------------------

``enumerate`` isn't part of ``itertools`` -- it's a builtin -- but it's
built from exactly the same idea as ``count``, and the equivalence is
exact, not approximate:

.. code-block:: python

   list(enumerate(['p', 'q', 'r'], start=5))
   # [(5, 'p'), (6, 'q'), (7, 'r')]

   list(zip(itertools.count(5), ['p', 'q', 'r']))
   # [(5, 'p'), (6, 'q'), (7, 'r')]
   # identical, element for element

``enumerate`` is really just "pair each item with a running counter" --
the same pattern ``count`` exists to provide generically, specialized
into one convenient builtin because it's so common.

Remember
------------

#. ``groupby`` merges only *consecutive* equal keys -- sort first if
   you want every occurrence of a key grouped together.
#. ``tee`` shares one buffer across its children; the memory cost is
   the *gap* between the furthest-ahead and furthest-behind reader, not
   the total data ever produced.
#. ``count`` and ``cycle`` never stop on their own -- always bound them
   with ``islice`` or a finite partner in ``zip``.
#. ``enumerate(items, start)`` is exactly ``zip(count(start), items)``,
   just spelled as one builtin for the common case.

See Also
--------------

:doc:`python_generators_interactive` for the ``yield``-based mechanism
every one of these tools is ultimately built on top of.
:doc:`python_hashing_interactive` for ``collections.Counter`` and
``defaultdict``, the tools to reach for when you actually want *every*
occurrence of a key grouped, not just consecutive runs.
