Async Generators & Async Context Managers: Play With It
============================================================

``async def`` with a ``yield`` in it, and ``async def`` with
``__aenter__``/``__aexit__`` in it, both answer the same question:
what happens when a generator or a context manager needs to
``await`` something in the middle of its own setup, teardown, or
production of the next value? A plain generator and a plain context
manager both assume everything they do is instant. These two widgets
show what changes once that assumption breaks -- and why nothing else
about the underlying protocol has to.

Async Generator: yield Meets await
------------------------------------------

A regular generator's ``yield`` only ever suspends for its
*consumer*'s next ``next()`` call. An async generator's ``yield`` can
do that *and* the generator can ``await`` something -- a network
call, a sleep -- before it has the next value ready. Step through
production alongside a fully independent sibling task on the same
toy event loop from :doc:`python_coroutines_interactive`, and watch
the sibling finish on schedule regardless of how long the generator
is waiting internally.

.. raw:: html
   :file: _static/py_async_generator_widget.html

This is also why async generators are their own object type rather
than "a generator that happens to live inside an ``async def``":
``await`` inside a plain ``def ...(): yield ...`` body is a
``SyntaxError`` in real Python. The `PEP 525
<https://peps.python.org/pep-0525/>`_ ``async def ...(): yield ...``
form exists specifically to make that combination legal, consumed
with ``async for`` rather than a plain ``for``.

Async Context Manager: __aenter__ and __aexit__ Take Time
------------------------------------------------------------------

:doc:`python_context_managers_interactive` covers the full
suppress-or-propagate decision in detail; that logic doesn't change
here. What's new is that both halves of the protocol are themselves
coroutines -- ``await mgr.__aenter__()`` and
``await mgr.__aexit__(...)`` -- so acquiring or releasing a resource
can take real time without blocking anything else running on the
same event loop. Pick a scenario and watch the sibling task finish on
its own schedule while the resource is still connecting or
disconnecting.

.. raw:: html
   :file: _static/py_async_context_manager_widget.html

``@contextlib.asynccontextmanager`` is the async counterpart to
``@contextmanager`` from the previous page, built the same way --
an async generator with one ``yield``, driven by ``asend()``/
``athrow()`` instead of plain ``send()``/``throw()`` -- for exactly
the same reason ``async def`` generators exist at all: so the setup
and teardown code on either side of that ``yield`` can itself
``await``.

See Also
-------------

:doc:`python_generators_interactive` and
:doc:`python_context_managers_interactive` cover the synchronous
versions of both protocols this page extends.
:doc:`python_coroutines_interactive` is the toy event loop both
widgets on this page run on.
