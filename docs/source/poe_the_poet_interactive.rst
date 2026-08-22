Poe the Poet: Play With It
================================

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

Every project accumulates a pile of one-off commands: run the tests,
lint, spin up a dev server, clean build artifacts. Normally these live
scattered across a README, a couple of shell aliases, and people's own
memory. `Poe the Poet <https://poethepoet.natn.io/>`_ (``poe``) gives
them a single name and a single home, so ``poe test`` means the same
thing, run the same way, for everyone on the project -- and shows up
right next to your Python project's own config instead of a separate
Makefile.

Where It Lives
--------------------

Poe reads its task list from a ``[tool.poe.tasks]`` table, normally
inside your project's own ``pyproject.toml``. If you're not using a
``pyproject.toml`` at all, it falls back to a standalone
``poe_tasks.toml`` (or the YAML/JSON equivalents) in the same
directory. Install the CLI with ``pipx install poethepoet``, and it
auto-detects the nearest task file wherever you run it from.

Two Families of Tasks
----------------------------

**Leaf tasks** actually run something:

* ``cmd`` -- runs a command directly as a subprocess, no shell
  involved. This is the *default* type when a task is just a plain
  string: ``test = "pytest"`` means exactly the same thing as
  ``test.cmd = "pytest"``. Fast and predictable, but no pipes or
  ``&&``.
* ``shell`` -- runs the command through a real shell. Reach for this
  specifically when you need shell features: pipes, ``&&``,
  backgrounding with ``&``.
* ``script`` -- calls a Python function directly, e.g.
  ``serve.script = "my_app.service:run(debug=True)"``.
* ``expr`` -- evaluates a Python expression and prints the result.

**Composite tasks** run *other* tasks:

* ``sequence`` -- runs a list of tasks in order. A task written as a
  plain array (``build = ["test", "_build"]``) is shorthand for this.
  By default, one failure stops the rest of the sequence --
  ``ignore_fail`` can change that.
* ``parallel`` -- runs several tasks concurrently.
* ``switch`` -- picks which task to run based on the output of a
  "control" task (a common use: ``control.expr = "sys.platform"``, to
  run a different build command per OS).
* ``ref`` -- an alias pointing at another task, mainly useful inside a
  sequence.

Play With It
------------------

.. raw:: html
   :file: _static/poe_the_poet_widget.html

Type ``poe test -v`` and watch the widget append ``-v`` to ``pytest``
verbatim -- any extra arguments after the task name get passed straight
through to the underlying command. Try ``poe release`` (an array
shorthand for a sequence containing a hidden ``_build`` task), check
"make test fail," and run it again: the sequence stops before
``_build`` ever runs, because a failure halts a sequence by default.
Then try ``poe checkup``, which sets
``ignore_fail = "return_non_zero"`` -- both of its steps run despite
the same failure, but the overall result still reports that something
went wrong.

The Underscore Convention
--------------------------------

Try running ``poe _build`` directly. It gets refused -- not because
this widget invented a restriction, but because that's poe's real,
documented behavior: a task name starting with ``_`` is excluded from
the plain ``poe`` listing and can't be invoked directly from the
command line. It can still run just fine as a step *inside* a sequence
(exactly what ``release`` already does with it), which is precisely
the point: ``_``-prefixed names are how a project marks a task as an
internal implementation detail rather than something a contributor is
meant to reach for on its own.

Two Environment Variables Worth Knowing
------------------------------------------------

Every task has access to ``$POE_ROOT`` (the directory containing the
task file itself) and ``$POE_PWD`` (the directory you actually ran
``poe`` from). They're not always the same directory, and the
distinction matters the moment a task changes its own working
directory mid-run but still needs to know where the invocation
started.

See Also
-------------

See :doc:`developer_commands` for the broader daily-workflow toolbox
(``docker``, ``git``, ``rsync``, ``find``) this page's single-tool
deep dive sits alongside.
