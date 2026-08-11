Command Pattern: Undo/Redo, Play With It
===========================================

A command is just an action packaged up with its own inverse. Undo
doesn't rewind anything -- it runs that stored inverse. Redo re-runs
the original. Add, move, recolor, or delete shapes below, then unwind
and replay the exact history.

.. raw:: html
   :file: _static/cpp_command_widget.html

Every action above -- add, move, recolor, delete -- is exactly this
shape in real C++: a command that captures its own inverse as a
closure at creation time, pushed onto a history stack that a new
action truncates past the current point.

.. code-block:: cpp

   struct Command {
       std::function<void()> doIt;
       std::function<void()> undoIt;
   };

   Command makeMoveCommand(Shape& shape, Point from, Point to) {
       return Command{
           /*doIt=*/   [&shape, to]   { shape.pos = to; },
           /*undoIt=*/ [&shape, from] { shape.pos = from; }   // captured now, not looked up later
       };
   }

   std::vector<Command> history;
   size_t pointer = 0;

   void execute(Command cmd) {
       cmd.doIt();
       history.resize(pointer);         // a new action discards any redo-able tail
       history.push_back(std::move(cmd));
       pointer++;
   }
   void undo() { if (pointer > 0) history[--pointer].undoIt(); }
   void redo() { if (pointer < history.size()) history[pointer++].doIt(); }

See :doc:`cpp_singleton_interactive` for another modern-C++ pattern
widget from the same design-patterns material.
