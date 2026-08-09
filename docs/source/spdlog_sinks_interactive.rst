spdlog Level-Filtering Cascade: Play With It
=============================================

Each sink having "its own pattern and level" is easy to read past in
the sprinkler analogy, but it's a real, two-stage gate: a log call is
checked against the *logger's* level first -- if it doesn't clear that
bar, no sink is ever consulted at all, no matter how permissive it is
-- and only past that does each attached sink check the message again
against its *own* level, completely independently of every other sink.

Play With It
------------------

One logger, two sinks (console and file), matching this page's own
Quick Start Template defaults. Fire a log call at any level and watch
which sinks actually emit it. Change the logger's level and watch both
sinks go silent together; change just one sink's level and watch the
two feeds start disagreeing about the exact same call.

.. raw:: html
   :file: _static/spdlog_sinks_widget.html

See :doc:`spdlog_sinks_architecture` for the full write-up this widget
is built from, including the rotating file sink mechanism this widget
doesn't cover.
