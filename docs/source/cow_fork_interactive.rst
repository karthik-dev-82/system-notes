Copy-on-Write After fork(): Play With It
============================================

``fork()`` looks like it should be expensive -- duplicate a whole
process's memory? -- and yet real programs call it constantly without
a second thought. The trick is that it doesn't duplicate any memory at
all, not at fork time. It duplicates *permission structure*, and lets
a page fault do the actual copying later, one page at a time, only for
the pages that turn out to need it.

* **At fork time:** every writable page in the parent gets marked
  read-only in both parent and child, and both point at the exact same
  physical frame. The frame's reference count goes up. Nothing is
  copied.
* **At write time:** the read-only mark is what makes the very next
  write to that page fault. The fault handler checks who else still
  holds the frame. If nobody else does, it just clears the read-only
  bit in place -- no copy needed, because there was never anyone to
  protect the data from. If someone else still holds it, *that's* the
  moment an actual copy happens.

Play With It
------------------

Fork a process and watch every writable page turn read-only in both
copies, with the same frame ID on both sides -- the fork itself costs
nothing. Then write to a page and watch the fault get resolved two
different ways depending on who else is still holding the frame. Try
writing to the same page from three or four forked siblings, in
different orders, and watch the frame's reference count count down
until the very last write reuses the frame in place instead of
copying it.

.. raw:: html
   :file: _static/cow_fork_widget.html

The Write Fault, Step by Step
-------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 28 36 36

   * - PTE state at the moment of the write
     - What the fault handler does
     - Cost
   * - Writable already
     - Nothing -- this isn't even a fault, it's a normal hardware
       store
     - Free
   * - Read-only, COW, frame refcount 1
     - Clears the read-only bit and the COW flag in place. No other
       process can possibly be looking at this frame, so there's
       nothing left to protect.
     - One page fault, zero copying
   * - Read-only, COW, frame refcount > 1
     - Allocates a fresh frame, copies the page's contents into it,
       repoints this process's page table entry at the new frame, and
       decrements the old frame's refcount
     - One page fault, one real 4 KB copy
   * - Read-only, not COW (a genuinely fixed mapping)
     - Rejects the write outright
     - SIGSEGV -- no amount of forking ever makes this page writable

The middle two rows are both triggered by the identical read-only bit
and the identical page fault. What separates a nearly-free fault from
an actual memory copy is a single reference count check the kernel
runs at the moment of the fault, not anything decided back when
``fork()`` was called.

Why the Kernel Bothers Being Lazy Here Too
------------------------------------------------

This is the same bet the kernel makes with page tables in general:
most of a process's pages, after a ``fork()``, are never written by
either side before one of them calls ``exec()`` or exits -- the
classic case being a shell that forks and immediately execs a new
program. Eagerly copying the whole address space at fork time would
waste every one of those unwritten pages. Deferring the copy until a
write actually happens means a process only ever pays for the pages
it truly diverges on, no matter how much address space it started
with.

See Also
-------------

See :doc:`vma_paging_interactive` for the mechanism this page builds
on directly -- that page's own notes call out copy-on-write by name as
the reason a permission check runs on every access, present or not.
See :doc:`process_memory_layout_interactive` for the address-space
picture whose pages are what's actually getting shared and copied
here.
