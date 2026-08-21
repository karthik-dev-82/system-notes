VMAs, Page Tables & the Lazy Kernel: Play With It
====================================================

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
