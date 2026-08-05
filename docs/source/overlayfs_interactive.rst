OverlayFS: Play With It
=======================

:doc:`linux_fs_basics_interactive` establishes that the VFS lets many
different kinds of filesystem coexist under one directory tree.
OverlayFS is one of them, and its particular trick is combining
*several other directories* into a single view: one or more read-only
``lowerdir``s stacked underneath a single writable ``upperdir``, with
the result presented as one ``merged`` directory. This is exactly what
makes a Docker container's filesystem work -- see
:doc:`kernel_networking_docker_internals` for the full ``iptables`` and
namespace picture this fits into.

Play With It
------------------

Two shared, read-only lower layers (an "ubuntu base" and an "nginx
install"), and two containers that each get their own private,
writable upperdir on top of those exact same lower layers. Pick a
file, then Read, Write, or Delete it, and watch precisely which layer
does the work -- including a copy-up the first time you modify a file
that only exists in a lower layer.

.. raw:: html
   :file: _static/overlayfs_widget.html

The Three Operations, Precisely
--------------------------------------

* **Read** always checks the upperdir first, then the lower layers
  from most-recently-added to oldest. First match wins -- exactly like
  flipping through transparent sheets and seeing whatever mark is
  topmost.
* **Write** to a file already in the upperdir just overwrites it
  directly. Write to a file that's only in a lower layer, and the
  *entire file* gets copied into the upperdir first -- only then does
  the write actually happen, to that new upper copy. The lower layer
  itself is never touched.
* **Delete** can't really remove anything from a read-only lower
  layer, so instead a *whiteout* -- a special marker -- goes into the
  upperdir at that path. The merged view treats a whiteout as "this
  file doesn't exist," even though the original is still sitting
  untouched in the lower layer the whole time. Delete something that
  only ever existed in the upperdir, though, and there's nothing
  underneath to hide -- so that one's just a normal, real deletion.

Try switching to Container B after modifying a file in Container A --
Container B still sees the original, unmodified version, because the
two containers share the lower layers but never the upperdir. That
isolation, on top of that sharing, is the entire reason this design
lets hundreds of containers reuse one base image safely at once.

See :doc:`linux_fs_basics_interactive` for the inode/mounting
foundation this builds on, and
:doc:`kernel_networking_docker_internals` for the full OverlayFS
reference -- the exact ``mount`` output Docker produces, the whiteout
implementation detail (a character device with major/minor ``0/0``),
and why write-heavy workloads inside a container should use a volume
instead of writing straight into it.
