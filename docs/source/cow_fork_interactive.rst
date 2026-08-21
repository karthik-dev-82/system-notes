Copy-on-Write After fork(): Play With It
============================================

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
