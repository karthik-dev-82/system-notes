VMAs, Page Tables & the Lazy Kernel: Play With It
====================================================

The kernel tracks a process's memory with two genuinely different
data structures, and mixing them up is the single most common source
of confusion about how memory allocation actually works:

* A **VMA** (virtual memory area) is a *contract* -- "this range of
  addresses is valid, here's what it's for, here are its permissions."
  Creating or extending one costs almost nothing.
* A **page table entry (PTE)** is *proof of work already done* -- "this
  specific 4 KB page is backed by this specific physical frame, right
  now." Creating one means a real physical page frame just got
  claimed.

``malloc()`` and ``brk()`` only ever touch the first kind. The second
kind doesn't get created until the program actually reads or writes
that memory for the first time -- a page fault forces the issue.

Play With It
------------------

Grow the heap's VMA and watch the physical frame pool not move at
all. Then touch a page inside it and watch a real page fault get
resolved, a frame get claimed, and a PTE get created. Try touching a
page with no VMA at all, and try writing to the read-only text
segment -- both fault instantly, for two different reasons.

.. raw:: html
   :file: _static/vma_paging_widget.html

The Four Outcomes of Touching a Page
-------------------------------------------

Every memory access a program makes resolves to exactly one of these,
in this order:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 28 36 36

   * - Outcome
     - Condition
     - What happens
   * - Segmentation fault (invalid)
     - No VMA covers this address at all
     - SIGSEGV -- the kernel has no idea what this memory is even
       supposed to be
   * - Segmentation fault (protection)
     - A VMA covers it, but this access violates its permissions
       (e.g. writing to a read-only mapping)
     - SIGSEGV -- same signal, different reason: the *address* is
       legitimate, the *operation* isn't
   * - Page fault, resolved
     - A VMA covers it, permissions are fine, but no PTE exists yet
       (first touch)
     - The kernel allocates a physical frame, creates a PTE, and
       execution resumes as if nothing happened
   * - No fault
     - A VMA covers it, permissions are fine, and a PTE already
       exists
     - Straight hardware memory access -- the fast path, no kernel
       involvement at all

The middle two rows are both "page fault," but only one of them
represents useful work. The kernel calls the first case a "minor
fault," and it's remarkably common -- it's simply how memory that was
promised gets turned into memory that actually exists.

Why the Kernel Bothers Being Lazy
----------------------------------------

It would be simpler for ``brk()`` to just allocate real memory
immediately. The reason it doesn't: programs routinely reserve far
more address space than they end up touching -- a generous heap size,
a large stack limit, a big ``mmap()``'d buffer that's only partially
used. Backing all of that eagerly would waste physical RAM on pages
that might never be read or written. Deferring the real allocation
until the very first access means a process only ever pays for the
memory it actually uses, page by page, no matter how much it
reserved up front.

See Also
-------------

See :doc:`process_memory_layout_interactive` for the address-space
picture this widget's VMAs correspond to, and
:doc:`cpp_memory_interactive` for what happens when C++ code
mismanages the heap this page is allocating for.
