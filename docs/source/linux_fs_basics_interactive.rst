How Linux Filesystems Work
================================

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
