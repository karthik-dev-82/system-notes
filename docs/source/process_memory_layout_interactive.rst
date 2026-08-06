A Process's Address Space: Play With It
==========================================

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
