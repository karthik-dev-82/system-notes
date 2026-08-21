Exception Unwinding Through Destructors: Play With It
=============================================================

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
