Page Cache, the Affair Between Memory and Files: Play With It
==================================================================

Two problems, one solution. Disks (even fast NVMe ones) are orders of
magnitude slower than RAM, and multiple programs routinely need the
same file's contents at once -- every process on your machine that
uses a shared library needs its code in memory, but nobody wants 100
separate copies of ``libc.so`` sitting in RAM. Linux solves both with
one mechanism: the **page cache**, a single, system-wide, page-sized
cache of file contents that every process's file I/O goes through,
whether that process asked for it or not.

Play With It
------------------

Two processes, one shared file, one shared page cache. Access a chunk
cold and pay a real (simulated) disk-latency cost; access it again --
from either process -- and it's instant. Switch a process to
``mmap()`` and watch it skip the extra copy entirely. Write something
and watch it "succeed" instantly while it's still only in RAM -- then
hit the crash button before calling ``fsync()`` and watch that data
disappear for good.

.. raw:: html
   :file: _static/page_cache_widget.html

Latency Model Used In This Widget
-----------------------------------------

The 2008 source material this page is adapted from measured a
spinning hard drive's seek time at roughly 13.7 ms and called it "a
4-minute walk down the hall." Storage has changed more than almost
anything else in that time, so this widget uses representative
numbers for a 2020s x86-64 or Apple Silicon machine instead --
order-of-magnitude figures typical of that hardware class, not one
specific chip's datasheet:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 40 25 35

   * - Operation
     - Typical latency
     - What determines it
   * - Page cache &rarr; user buffer copy (4 KB)
     - ~0.2 &micro;s
     - RAM bandwidth, not latency -- this is "free" by comparison
   * - NVMe SSD, 4 KB random read/write
     - ~80-120 &micro;s
     - Flash access time + the NVMe/PCIe protocol round trip
   * - SATA SSD, 4 KB random read
     - ~100-200 &micro;s
     - Same flash, slower interface
   * - Spinning hard disk seek (2008-era, for scale)
     - ~10,000 &micro;s
     - Physically moving a read/write head across a spinning platter

The relative story hasn't changed even though the absolute numbers
have: a page cache hit is still on the order of *tens of thousands of
times* faster than going to storage, whatever that storage is. NVMe's
big contribution is shrinking the penalty for a *miss* -- roughly
100x faster than the spinning disks this mechanism was originally
designed around -- which is also why the page cache matters slightly
less than it used to, and considerably more than "slightly less"
still implies.

Why This Is the Answer to "Why Does I/O Block?"
-----------------------------------------------------------

:doc:`python_concurrency_interactive` shows *how* threading and
asyncio avoid wasting CPU time while a task waits on I/O. This page
shows *what that wait actually is*: a page-cache miss on the file (or
socket buffer) the program is reading from. The wait is real, it's
measured in real microseconds to milliseconds, and it happens whether
or not your code is written to cooperate with it -- concurrency
primitives don't make the disk faster, they just make sure the CPU
has something else to do while it catches up.

See Also
-------------

See :doc:`vma_paging_interactive` for how the page cache's pages get
backed by physical frames in the first place -- the page fault
mechanism there and the cache-population step here are the same
underlying machinery, and :doc:`process_memory_layout_interactive`
for where the memory-mapping segment that ``mmap()`` uses sits in a
process's address space.
