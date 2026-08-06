asyncio.gather(): Play With It
=================================

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
