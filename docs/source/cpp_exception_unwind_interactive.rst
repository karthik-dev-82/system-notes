Exception Unwinding Through Destructors: Play With It
=============================================================

Every C++ page in this series so far has shown the same shape of bug:
a cleanup step written as an ordinary statement, sitting after code
that doesn't always reach it -- an early return
(:doc:`cpp_memory_interactive`), a missing ``virtual`` keyword
(:doc:`cpp_vtable_interactive`). Exceptions are the third way to skip
that statement, and the mechanism that saves you is the same one that
made RAII worth building in the first place: when an exception
propagates, every stack frame between the ``throw`` and the matching
``catch`` is destroyed exactly as if each one had returned normally --
same reverse order, same destructor calls, no separate "cleanup path"
to write by hand.

Stack Unwinding + RAII Cleanup
-----------------------------------

.. raw:: html
   :file: _static/cpp_exception_unwind_widget.html

Step through ``main()`` calling ``process()`` calling ``risky()``,
which throws. In the raw-handle version, ``fclose(f)`` was written
immediately after the call that throws -- and is simply never reached;
control jumps straight to unwinding the instant the exception is
thrown, and there is no mechanism that comes back for a skipped
statement. In the ``FileGuard`` version, closing the file isn't a
statement at all -- it's what the destructor does, and destructors run
unconditionally as part of a frame being destroyed, whether that frame
ends by returning or by an exception passing through it.

.. code-block:: cpp

   void process() {
       FileGuard f("data.txt", "r");   // RAII: no cleanup statement needed
       risky();                          // throws
   }   // f's destructor runs right here, during unwinding -- file closed

This is the real, practical reason RAII is treated as the default way
to manage resources in C++ rather than one option among several: it's
the only cleanup strategy that is correct on *every* exit path a scope
can have -- normal return, early return, or an exception blowing
straight through it -- without writing a single line of code for the
exception case specifically.

When a Destructor Itself Throws
--------------------------------------

The second tab covers the one situation where a destructor becomes
actively dangerous instead of just a convenience: throwing from a
destructor that is *itself* being called as part of unwinding another
exception. At that point two exceptions are in flight simultaneously
-- the original one, still propagating, and the new one, just thrown
from the destructor -- and the C++ runtime has no defined way to
handle that. It doesn't pick one, doesn't merge them, doesn't try the
next handler up: it calls ``std::terminate()`` and the program aborts,
immediately, with neither exception ever reaching a ``catch`` block.

.. code-block:: cpp

   struct Guard {
       ~Guard() noexcept { /* cleanup that genuinely cannot throw */ }
   };

A destructor has no reliable way to check whether it's being called
during normal scope exit or while another exception is already
unwinding through it -- which is exactly why the rule isn't "don't
throw from a destructor while unwinding," it's "don't throw from a
destructor, ever." Since C++11, destructors are implicitly
``noexcept`` by default anyway (unless a base class or member's
destructor explicitly isn't), which turns that rule from a convention
programmers have to remember into something the compiler enforces --
throwing from a ``noexcept`` function calls ``std::terminate()``.
Whether the stack is unwound first is left implementation-defined by
the standard, but in practice GCC and Clang both terminate
immediately, before unwinding even begins.

The Theme, One Last Time
------------------------------

Across this whole series -- dangling references, heap leaks,
use-after-free, ownership via smart pointers, move semantics, virtual
dispatch, and now exceptions -- the underlying lesson has been the
same one, seen from different angles: C++ gives you exact, manual
control over resource lifetimes, and RAII is the pattern that makes
that control safe by tying cleanup to something the language
guarantees will happen (a scope ending) instead of something you have
to remember to write on every path that scope might take.
