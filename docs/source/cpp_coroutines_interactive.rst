C++20 Coroutines: Play With It
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

     div.document div.admonition {
       background: #f7f6f2;
       border: 1px solid #cdd6cc;
       border-left: 4px solid #a67c1f;
       border-radius: 4px;
       padding: 14px 18px;
       margin: 4px 0 22px;
     }
     div.document div.admonition p.admonition-title {
       font-weight: 700;
       color: #a67c1f;
       margin: 0 0 8px;
       font-size: 0.72rem;
       letter-spacing: 0.06em;
       text-transform: uppercase;
     }
     div.document div.admonition p:last-child { margin-bottom: 0; }
   </style>

**Analogy:** a bookmark in a function. A normal function reads the
book cover to cover with no stopping; a coroutine can place a bookmark
(pause), let other code run, then resume exactly where it left off.

**Core idea:** functions that can suspend and resume. They let async
code read top-to-bottom like normal code, and let you produce values
lazily, one at a time.

The Three Keywords
------------------------

Any function using one of these is a coroutine:

.. code-block:: cpp

   co_await   // suspend until something is ready, then resume
   co_yield   // produce one value and suspend (for generators)
   co_return  // finish and optionally return a value

Generator: Values on Demand
-----------------------------------

**Analogy:** a vending machine -- each call dispenses one item.

.. code-block:: cpp

   Generator<int> getNumbers() {
       for (int i = 0; i < 5; ++i)
           co_yield i;        // hand out i, pause, resume on next request
   }

   for (int n : getNumbers())  // 0 1 2 3 4, computed one at a time
       std::cout << n << " ";

Nothing is computed until you ask for the next value -- lazy,
low-memory.

Async Without Callback Hell
-----------------------------------

.. code-block:: cpp

   // traditional callbacks nest into a pyramid
   fetch([](auto a){ process(a, [](auto b){ save(b, [](auto c){ /*...*/ }); }); });

   // a coroutine reads like synchronous code
   Task<int> work() {
       auto a = co_await fetch();
       auto b = co_await process(a);
       co_return b;
   }

Play With It
------------------

Both tabs below are driven by real JS generator functions (the same
suspend/resume primitive C++20 coroutines use under the hood) rather
than a hand-timed animation. Tab 1 makes laziness measurable --
"computed" never runs ahead of "pulled". Tab 2 proves the more
surprising claim: a coroutine awaiting something slow does not block
its siblings from making their own progress on the same scheduler.

.. raw:: html
   :file: _static/cpp_coroutines_widget.html

The Honest Caveat
------------------------

C++20 gives you the keywords but not ready-made ``Generator`` /
``Task`` types -- you (or a library) must supply a ``promise_type``
that defines the coroutine's behavior: when it suspends, what the
caller receives, how values are yielded. It's powerful but the
plumbing is genuinely advanced. In practice, lean on a library (e.g.
``cppcoro``, or your framework's types) rather than writing the
machinery by hand.

Gotchas / When NOT To
------------------------------

* Don't reach for coroutines for simple synchronous code -- a plain
  function or loop is clearer and faster.
* Avoid them in hot loops -- there's a small state-machine overhead
  and a potential heap allocation for the coroutine frame.
* Capture lifetimes carefully -- a coroutine that outlives data it
  references dangles, just like a bad lambda capture.
* Needs a modern compiler with full C++20 support.

Remember
------------

#. Coroutines = pausable, resumable functions.
#. ``co_yield`` for lazy generators, ``co_await`` for readable async,
   ``co_return`` to finish.
#. They replace callback pyramids with straight-line code.
#. Efficient -- no thread per task -- but with a small per-frame cost.
#. C++20 gives keywords, not types -- use a library for
   ``Task``/``Generator``.
#. Skip them for simple synchronous code and hot loops.

See Also
--------------

:doc:`cpp_futures_promises_interactive` for the simpler, non-coroutine
way to get an async result back when you don't need to suspend
mid-function. :doc:`python_coroutines_interactive` and
:doc:`python_generators_interactive` for the same two mechanisms
(suspend/resume scheduling, lazy value production) in a language where
they're not new keywords bolted onto the type system, but native from
the start.
