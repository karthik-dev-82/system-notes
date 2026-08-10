Python Coroutines: Play With It
===================================

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
