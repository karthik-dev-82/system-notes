Linux Filesystem Basics: Play With It
=====================================

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

Two ideas do almost all of the heavy lifting in how Linux thinks about
files, and once they click, a lot of otherwise-confusing behavior
(hard links, symlinks, why ``/proc`` can coexist with a real disk,
why mounting a USB drive doesn't destroy whatever used to be in that
folder) stops being a pile of separate facts and becomes one
consistent picture.

* **A file is not its name.** A file is an *inode* -- a number, with
  metadata and data blocks attached to it. A directory is just a list
  of (name, inode number) pairs. Names are cheap and disposable;
  inodes are the actual thing.
* **The directory tree you see is not one filesystem.** It's several
  different filesystems, each with their own idea of how to store
  data, grafted together at *mount points* -- and the kernel's VFS
  layer is what makes ``open()``/``read()``/``write()`` work the same
  way no matter which one you're actually talking to.

Play With It
------------------

Two tabs. The first lets you create a hard link and a symlink to the
same file, then delete the original name and watch what happens to
each -- one survives, one doesn't, for a reason that becomes obvious
once you're looking at the inodes directly. The second lets you mount
and unmount a few filesystem types onto a small directory tree, and
trace exactly which driver handles a given path and why.

.. raw:: html
   :file: _static/linux_fs_basics_widget.html

The Punchline of Tab 1
------------------------------

Create ``backup.txt`` as a hard link to ``report.txt``, and separately
create ``shortcut.txt`` as a symlink to it. Then delete ``report.txt``.
Read ``backup.txt`` -- it still works, with the exact same content, as
if nothing happened. Read ``shortcut.txt`` -- it's now a broken,
dangling reference. Same starting point, same deleted name, opposite
outcome. The reason is right there in the inode panel: ``backup.txt``
was always a second name for the *same* inode, so removing the first
name just lowered its link count -- the data was still reachable.
``shortcut.txt`` was always a completely different inode, one whose
entire content is just the text ``"report.txt"``, so once that text no
longer resolves to anything, there's nothing left to follow.

Why Tab 2 Matters for Everything Else
------------------------------------------------

Once you've mounted procfs at ``/proc`` and tmpfs at ``/tmp`` in the
widget, notice that reading a path under either one gets routed to a
completely different kind of driver than reading something under
``/`` -- one that doesn't touch a disk at all. That's the exact same
mechanism behind :doc:`the live /proc explorer <proc_filesystem_interactive>`
and it's also the exact same mechanism :doc:`OverlayFS <overlayfs_interactive>`
uses to make a container's merged view work: OverlayFS is, from the
VFS's point of view, just one more mountable filesystem type, whose
particular trick is combining several other directories into one
view instead of reading a disk or generating data on the fly.

See :doc:`kernel_networking_docker_internals` for how this all comes
together with namespaces and ``iptables`` to make a full container.
