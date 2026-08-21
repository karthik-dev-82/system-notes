Python Generators: Play With It
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
