asyncio.gather(): Play With It
=================================

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

``asyncio.gather()`` is how you run several coroutines concurrently
and collect all their results in one place. The mechanics are simple
once you've watched them happen once -- and there's exactly one
detail that trips up almost everyone the first time they read about
it, rather than watch it.

Play With It
------------------

Three real coroutines (not a simplified stand-in -- this is the
actual code, and the actual scheduling behavior of CPython's
``asyncio``), each doing nothing more than printing, sleeping for a
configurable delay, and returning a result. Set each one's delay, run
it, and watch the console output, the per-task line markers, and the
returned list all update in real time.

.. raw:: html
   :file: _static/asyncio_gather_widget.html

Coroutines Use ``await``, Not ``yield``
-------------------------------------------------

If you've seen older asyncio code (or older tutorials) using
``yield`` inside a coroutine, that's a different, now-removed style:

.. code-block:: python

   # Old style (generator-based coroutines) -- removed in Python 3.11
   @asyncio.coroutine
   def old_style():
       yield from asyncio.sleep(1)

   # Current style -- what this page's widget runs
   async def fetch_data(name, delay):
       print(f"{name}: starting, will take {delay}s")
       await asyncio.sleep(delay)
       print(f"{name}: done")
       return f"{name}-result"

``yield`` inside a modern ``async def`` function still means
something in Python -- it turns that function into an **async
generator**, consumed with ``async for``, not ``await``. That's a
related but genuinely different tool from what ``gather()`` operates
on. Every coroutine you pass to ``gather()`` should suspend with
``await``, never ``yield``.

The One Detail Everyone Gets Wrong First
------------------------------------------------

``asyncio.gather()`` always returns results in the order its
**arguments were given**, never in the order the tasks actually
finished:

.. code-block:: python

   async def main():
       results = await asyncio.gather(
           fetch_data("A", 2),   # takes 2s
           fetch_data("B", 1),   # takes 1s -- finishes FIRST
           fetch_data("C", 3),   # takes 3s -- finishes LAST
       )
       print(results)
       # ['A-result', 'B-result', 'C-result']  <- argument order,
       #                                            not 1s/2s/3s finish order

Set B's delay lower than A's in the widget above and watch it happen:
B's "done" print appears first in the console, but its result still
lands in the *second* position of the returned list, exactly where
``fetch_data("B", ...)`` sits in the original call. Getting the order
wrong here is a common source of real bugs -- code that assumes
results arrive in completion order will silently pair the wrong
result with the wrong request once anything finishes out of order.

``asyncio.TaskGroup``: the Modern Alternative
-----------------------------------------------------

Python 3.11 added ``asyncio.TaskGroup`` as the newer recommended way
to run coroutines concurrently and wait for all of them, with better
failure behavior than ``gather()``'s default. If one task raises,
plain ``gather()`` lets its siblings keep running in the background
unless you pass ``return_exceptions=True`` or manage cancellation
yourself; ``TaskGroup`` cancels the remaining tasks immediately and
raises a combined error, which is usually what you actually want:

.. code-block:: python

   async def main():
       async with asyncio.TaskGroup() as tg:
           a = tg.create_task(fetch_data("A", 2))
           b = tg.create_task(fetch_data("B", 1))
           c = tg.create_task(fetch_data("C", 3))
       # by this point every task has finished (or the group raised)
       results = [a.result(), b.result(), c.result()]

The ordering guarantee is identical: ``results`` is built by reading
each task's own ``.result()`` in the order you created them, not the
order they completed.

See Also
-------------

See :doc:`python_concurrency_interactive` for how this same
cooperative scheduling compares to threading and multiprocessing at
the abstract scheduling level -- this page shows the real source code
and console output that scheduling model was built to represent.
