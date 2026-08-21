A Process's Address Space: Play With It
==========================================

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

Every running program gets its own private **virtual address space**
-- a range of addresses that looks the same shape every time,
regardless of what the program actually does. Different kinds of data
always end up in different, well-defined regions of it, called
**segments**. This is the classic picture taught in every operating
systems course, and it's still exactly how Linux (and Windows) lay
out a process today.

Play With It
------------------

Click through a tiny annotated C program and watch each line light up
the segment it actually lands in. Then grow the heap, load a library,
and push a stack frame to watch those segments actually move -- and
toggle ASLR to see which addresses stay fixed and which ones reshuffle
on every run.

.. raw:: html
   :file: _static/process_memory_layout_widget.html

The Segments, What Lives In Each One
-------------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 18 42 20 20

   * - Segment
     - What lives here
     - Grows?
     - Writable?
   * - Text
     - Compiled machine code, string literals, anything read-only
       baked into the binary
     - No, fixed size
     - No (read + execute only)
   * - Data
     - Global/static variables that have an initial value in source
       code
     - No, fixed size
     - Yes
   * - BSS
     - Global/static variables with **no** initial value -- zero-filled
       at load time, not stored in the binary at all
     - No, fixed size
     - Yes
   * - Heap
     - Everything ``malloc()``/``new`` hands back
     - Upward, via ``brk()``
     - Yes
   * - Memory Mapping Segment
     - Shared libraries (``.so`` files) and any file the program
       maps directly with ``mmap()``
     - Downward, as more libraries/files are mapped
     - Depends per-mapping
   * - Stack
     - Local variables and function call frames, one stack per thread
     - Downward, one call frame at a time
     - Yes

Why ASLR Matters
----------------------

Before Address Space Layout Randomization existed, the stack, the
shared-library region, and the heap started at the *exact same
address* on every single run of a program, on every machine running
that OS. An attacker who found a buffer overflow didn't need to guess
where anything useful lived in memory -- they could hardcode the
address of a known library function (like ``system()``) directly into
their exploit, because it would be at the same place every time.

ASLR breaks that assumption by adding a random offset to those three
regions' starting addresses on every run. The widget's "Run Program
Again" button makes this concrete: with ASLR on, the stack/library/heap
addresses are different every time you click it; with it off, they're
identical, run after run -- which is also exactly the pre-ASLR world
those classic exploits depended on.

See Also
-------------

This page shows *where* each segment lives in the address space. It
doesn't show what's actually backing that space with real memory --
:doc:`vma_paging_interactive` picks up exactly there, and
:doc:`cpp_memory_interactive` covers the language-level bugs (dangling
pointers, leaks, use-after-free) that happen *within* these segments.
