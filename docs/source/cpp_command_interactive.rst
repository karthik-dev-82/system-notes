Command Pattern: Undo/Redo, Play With It
===========================================

A command is just an action packaged up with its own inverse. Undo
doesn't rewind anything -- it runs that stored inverse. Redo re-runs
the original. Add, move, recolor, or delete shapes below, then unwind
and replay the exact history.

.. raw:: html
   :file: _static/cpp_command_widget.html

See :doc:`cpp_singleton_interactive` for another modern-C++ pattern
widget from the same design-patterns material.
