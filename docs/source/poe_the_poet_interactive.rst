Poe the Poet: Play With It
================================

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
