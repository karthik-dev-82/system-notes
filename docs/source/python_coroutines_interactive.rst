Python Coroutines: Play With It
===================================

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

:doc:`python_concurrency_interactive` shows *what order* things happen
in when ``asyncio`` runs several coroutines together, and states the
rule plainly: "a coroutine only ever gives up control at an explicit
``await``." This page builds the thing that makes that rule true --
a working event loop, from scratch, small enough to read start to
finish. There's no framework magic underneath ``async``/``await``:
just a generator-shaped suspend/resume protocol (see
:doc:`python_generators_interactive` for that protocol on its own)
and a loop dumb enough to be worth showing in full.

A Toy Event Loop, Ticking
------------------------------

Three coroutines, each doing nothing but a sequence of
``await asyncio.sleep(n)`` calls. The scheduler on the right is real,
runnable code, not a diagram of one -- every tick, it checks who's
done waiting and lets them run one step. Change one task's sleep
pattern and watch it finish exactly when its *own* waits add up to,
never sooner or later because of what the other two are doing.

.. raw:: html
   :file: _static/py_event_loop_widget.html

That independence is the entire content of "asyncio runs things
concurrently" -- there's no parallelism happening (see
:doc:`python_concurrency_interactive` for why the GIL guarantees
that), just a scheduler that never lets one task's wait hold up
another task's turn. A CPU-bound coroutine with no ``await`` in its
body breaks this completely: this loop has no way to interrupt code
that never yields, which is exactly why that failure mode exists in
real ``asyncio`` too.

await Chains Through
--------------------------

The three coroutines here aren't independent -- ``outer`` calls
``middle``, which calls ``inner``, and each one uses ``await`` on the
next.
Step through it and the wording "``await`` blocks" turns out to be
backwards: nothing blocks. ``outer`` and ``middle`` both go idle
almost immediately, and the loop is free to run other work (there
just isn't any here) while ``inner`` sleeps.

.. raw:: html
   :file: _static/py_await_chain_widget.html

Here's the part that's easy to get backwards: chaining bare ``await``
calls like this costs *nothing* extra. ``outer``, ``middle``, and
``inner`` are not three separately-scheduled tasks taking turns --
only ``inner``'s ``asyncio.sleep()`` is ever a real suspension point.
The moment that sleep resolves, control unwinds straight back up
through ``middle`` and ``outer`` synchronously, in a single step, all
on the same tick -- confirmed directly against real ``asyncio``
(tracing a concurrently-running sibling task shows it gets zero
chances to interleave between ``inner`` finishing and ``outer``
returning; they all happen back-to-back in one event-loop callback).
This is exactly what ``yield from``-style generator delegation looks
like under the hood, and it's why "await delegates, it doesn't block"
is the accurate way to describe nesting -- not "each layer adds
latency."

See Also
-------------

:doc:`python_generators_interactive` is the suspend/resume protocol
this page's coroutines are built directly on top of -- the ``yield``
points in both toy event-loop widgets are standing in for ``await``.
:doc:`python_asyncio_gather_interactive` shows the same underlying
loop running real ``asyncio`` coroutines and the specific guarantee
``gather()`` adds on top (results in argument order, not completion
order) -- a detail this page's toy scheduler doesn't attempt to model.
