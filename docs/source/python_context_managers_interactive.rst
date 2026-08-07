Python Context Managers: Play With It
=========================================

``with`` reads like a special-purpose statement, but it isn't -- it's
a plain, four-line protocol any object can opt into: call
``__enter__()``, run the block, and call ``__exit__()`` on the way
out, exception or not. Once ``__exit__()``'s return value decides
whether an exception gets swallowed or re-raised, most of what feels
mysterious about ``with`` -- files that close themselves, locks that
release on error, transactions that roll back -- stops being magic
and becomes one small, readable rule.

Play With It
------------------

The same resource, written two ways: a plain class with
``__enter__``/``__exit__``, and a generator wrapped in
``@contextlib.contextmanager``. Pick a scenario -- a clean exit, an
exception that escapes, an exception that gets swallowed, or
``__enter__`` itself failing -- and watch both implementations reach
the exact same outcome, because they're both compiled down to the
exact same protocol shown above the two columns.

.. raw:: html
   :file: _static/py_context_manager_widget.html

``@contextmanager`` Is Not a Separate Feature
--------------------------------------------------------

This is the payoff for :doc:`python_generators_interactive`:
``@contextlib.contextmanager`` isn't a new mechanism, it's the
generator suspend/resume protocol wearing a different hat. Everything
before the single ``yield`` is ``__enter__``; everything after it is
``__exit__``. And when an exception happens inside the ``with``
block, ``contextlib`` doesn't reach for anything exotic to hand it to
your generator -- it calls ``.throw()`` on it, the exact same method
the generators widget's "throw() & close()" tab already demonstrated
injecting an exception into a suspended generator. A ``try``/``except``
wrapped around the ``yield`` is how a generator-based context manager
catches that exception; not re-raising it is how it gets suppressed.

The One Case Easy to Get Backwards
------------------------------------------

It's tempting to assume ``__exit__`` always runs, no matter what. It
doesn't: if ``__enter__`` itself raises, the ``with`` block's body
never executes and ``__exit__`` is never called -- there's no
resource to release, because nothing was ever acquired. The "enter
fails" scenario in the widget makes this concrete: the execution log
stays completely empty, for both implementations, because neither
gets far enough to log anything.

The Other Case Easy to Get Backwards
------------------------------------------

A generator-based context manager that catches an exception and
raises a *different* one doesn't suppress the original -- the new
exception replaces it and propagates instead. This matches
``contextlib``'s real behavior exactly and is worth knowing before it
surprises you: swallowing an exception requires catching it and
**not** re-raising anything, not catching it and raising something
else by accident (a bare ``logging.exception()`` call inside an
``except`` block is a common way to do this unintentionally).

See Also
-------------

:doc:`python_generators_interactive` covers the ``next()``/``send()``/
``throw()``/``close()`` protocol this page's generator-based column
runs on directly. :doc:`threads_sync_interactive` shows the same
"acquire, use, release, even on the unhappy path" shape applied to a
mutex specifically -- context managers are frequently how that
release actually gets guaranteed in real code (``with lock:`` instead
of manual ``acquire()``/``release()`` pairs that a raised exception
can skip).
