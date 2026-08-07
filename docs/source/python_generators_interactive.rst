Python Generators: Play With It
===================================

A function with ``yield`` in its body doesn't behave like a function
at all -- calling it doesn't run anything. It hands back a **generator
object**: a paused frame, sitting at the very first line, waiting.
Every other piece of generator behavior -- laziness, memory savings,
``send()``'s two-way communication, ``StopIteration`` -- falls out of
that one fact once it's concrete instead of theoretical.

Two demos below, each with its own introduction directly above it:
one steps through the actual suspend/resume protocol line by line,
the other makes the laziness measurable rather than asserted.

Step Through a Generator
------------------------------

Three small generator functions, one protocol. ``next()`` resumes
execution from exactly where it last stopped and runs until the next
``yield`` -- watch the local variables panel to see that everything
the function was holding onto survives the pause untouched.
``send(value)`` does the same resume, but also hands a value back
*into* the paused ``yield`` expression -- the generator's one real
two-way communication channel. ``throw()`` and ``close()`` interrupt
a suspended generator from the outside: an injected exception the
generator can catch and recover from, or a shutdown signal that still
runs its ``finally`` block on the way out.

.. raw:: html
   :file: _static/py_generator_stepper_widget.html

The control flow driving this widget is genuinely real: native
JavaScript ``function*``/``yield`` objects, whose suspend-resume-send-
throw protocol was deliberately modeled on Python's own generator
protocol -- close enough that porting the state machine over was
mostly a matter of translation, not simulation. One real difference
is enforced explicitly rather than left to chance: Python raises
``TypeError`` if you call ``.send(value)`` with anything other than
``None`` before a generator has been started with a first ``next()``
-- there's no paused ``yield`` expression yet to receive it. JavaScript
doesn't enforce this (it just discards the value), so the widget's
controller checks for it directly, matching Python's actual behavior
rather than JavaScript's more permissive one.

Generator vs. List: Laziness on Demand
--------------------------------------------

The entire point of a generator is captured by one contrast: a list
comprehension computes and stores every value the moment the line
runs; a generator expression computes exactly one value, exactly when
something asks for the next one, and holds nothing else. Set ``N`` to
a million and watch it stop being an abstract claim -- the list side
finishes all at once, and the generator side sits at zero until you
start pulling.

.. raw:: html
   :file: _static/py_generator_laziness_widget.html

Both meters are driven by real objects rather than a simulated
counter: the list side reads an actual array's length after a real
``Array.from()`` call, and the generator side only advances on an
actual ``.next()`` call. This is also the practical reason generator
expressions exist at all -- ``sum(x*x for x in range(10_000_000))``
never holds more than one value in memory at a time; the list-
comprehension equivalent holds all ten million before ``sum()`` even
starts adding them up.

See Also
-------------

:doc:`python_asyncio_gather_interactive` covers ``async def`` and
``await`` -- a *related* but distinct protocol built on the same
suspend/resume idea, driven by an event loop instead of a plain
``for`` loop or manual ``next()`` calls. That page explicitly notes
the ``yield``-inside-``async-def`` case (an async generator) without
explaining plain generators in depth -- this page is that missing
piece.
