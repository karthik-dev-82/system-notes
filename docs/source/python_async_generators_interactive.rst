Async Generators & Async Context Managers: Play With It
============================================================

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
