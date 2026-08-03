The /proc Filesystem
==========================

The Big Idea
------------------

``/proc`` is **not** a real filesystem! It's a magical window into
your computer's brain. The files you see aren't stored on disk --
they're created on-the-fly by the kernel to show you what's happening
inside your computer *right now*.

**Analogy:** imagine your computer has a glass window in its
forehead. Through this window, you can see its thoughts (what
processes are running), its vital signs (CPU usage, memory), and its
memories (system configuration). That window is ``/proc``!

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor "You" as user
   rectangle "/proc\n(Virtual Window)" as proc #yellow
   rectangle "Linux Kernel\n(The Brain)" as kernel #lightblue
   database "Real Disk" as disk #lightgreen

   user -> proc: cat /proc/cpuinfo
   proc -> kernel: "Hey, what's the CPU info?"
   kernel -> proc: "Here's the data!"
   proc -> user: Display CPU information
   note right of proc: NOT reading from disk!\nKernel generates data\non-the-fly!
   note left of disk: /proc files don't\nexist here!

Key points:

* Files in ``/proc`` are virtual (not on disk)
* Created on-demand when you read them
* Show live system information
* Take up 0 bytes on disk (check with ``du -sh /proc`` -- it's normal
  to see a stream of "cannot access" errors while it runs, since
  entries can disappear mid-scan as processes exit; the total at the
  end is still ``0``)

What's Inside /proc?
--------------------------

Process Information (Numbered Directories)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Every running program gets a directory named after its Process ID
(PID).

.. code-block:: text

   /proc/
   ├── 1/          # Init process (first process)
   ├── 1234/       # Process with PID 1234
   ├── 5678/       # Process with PID 5678
   └── 9999/       # Process with PID 9999

**Analogy:** like hospital rooms. Each patient (process) gets a room
number (PID), and their medical chart (process info) is on the door!

**Inside each process directory:**

.. code-block:: text

   /proc/1234/
   ├── cmdline     # The command that started this process
   ├── status      # Process status (running, sleeping, zombie)
   ├── mem         # Process memory
   ├── maps        # Memory maps
   ├── fd/         # Open file descriptors (files the process opened)
   ├── exe         # Link to the actual executable
   ├── cwd         # Current working directory
   └── environ     # Environment variables

Example:

.. code-block:: text

   # What command started process 1234?
   cat /proc/1234/cmdline
   # Output: /usr/bin/python3/home/user/script.py
   # (no space between arguments -- cmdline separates them with NUL
   # bytes, which most terminals just render as nothing)

   # What files does it have open?
   ls -l /proc/1234/fd/
   # Output: 0 -> /dev/stdin
   #         1 -> /dev/stdout
   #         2 -> /dev/stderr
   #         3 -> /home/user/data.txt

Think of it like: each process's room contains their belongings (open
files), what they're doing (status), and where they came from
(cmdline).

System-Wide Information Files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These files show information about the whole computer, not just one
process.

**/proc/cpuinfo -- CPU information**

.. code-block:: bash

   cat /proc/cpuinfo

Shows:

* How many CPU cores you have
* CPU speed (MHz)
* CPU model name
* CPU features (SSE, AVX, etc.)

**Analogy:** like your computer's birth certificate -- tells you what
brain it was born with!

**/proc/meminfo -- memory information**

.. code-block:: bash

   cat /proc/meminfo

Shows:

.. code-block:: text

   MemTotal:       16384000 kB  # Total RAM
   MemFree:         2048000 kB  # Free RAM
   MemAvailable:    8192000 kB  # Actually available
   Buffers:          512000 kB  # Buffer cache
   Cached:          4096000 kB  # Page cache
   SwapTotal:       8192000 kB  # Swap space
   SwapFree:        8192000 kB  # Free swap

**Analogy:** like checking your wallet. How much money (memory) do
you have total? How much is available to spend?

**/proc/uptime -- how long the system has been running**

.. code-block:: bash

   cat /proc/uptime
   # Output: 123456.78 999999.12
   # First number: seconds since boot
   # Second number: idle time, summed across every CPU core -- on a
   # multi-core system this routinely adds up to several times the
   # uptime itself, which is why it looks so much bigger here

Convert to readable:

.. code-block:: bash

   uptime
   # Output: up 1 day, 10:17

**Analogy:** like a stopwatch that started when you turned on your
computer and never stopped!

**/proc/loadavg -- system load average**

.. code-block:: bash

   cat /proc/loadavg
   # Output: 1.23 0.95 0.87 2/456 12345
   # 1.23 = load average last 1 minute
   # 0.95 = load average last 5 minutes
   # 0.87 = load average last 15 minutes
   # 2/456 = 2 running processes / 456 total processes

What's "load average"? The number of processes waiting for CPU time.

**Analogy:** like the line at a coffee shop:

* Load of 1.0 = one person in line (perfect!)
* Load of 5.0 = five people in line (getting busy!)
* Load of 20.0 = twenty people in line (overwhelmed!)

Rule of thumb: load should be less than or equal to the number of CPU
cores.

Network Information
~~~~~~~~~~~~~~~~~~~~~~~~

**/proc/net/dev -- network interface statistics**

.. code-block:: bash

   cat /proc/net/dev

Shows: bytes/packets sent and received on each interface, plus errors
and drops.

**Analogy:** like a post office counter tracking how many letters
were sent and received!

**/proc/net/tcp -- active TCP connections**

.. code-block:: bash

   cat /proc/net/tcp

Shows all active TCP connections (what you're connected to right
now) -- though raw, in a hex-encoded format (addresses and ports as
hex, connection state as a hex code). Tools like ``ss`` and
``netstat`` read this same file and decode it into the readable form
you're used to.

Hardware Information
~~~~~~~~~~~~~~~~~~~~~~~~~

**/proc/devices -- available device drivers**

.. code-block:: bash

   cat /proc/devices

Shows: what hardware drivers are registered (disk, network, sound,
etc.).

**/proc/interrupts -- hardware interrupts**

.. code-block:: bash

   cat /proc/interrupts

Shows: how many times each hardware device asked for CPU attention.

**Analogy:** like counting how many times your doorbell rang (disk),
phone rang (network), or alarm went off (timer)!

The Magic: How /proc Actually Works
------------------------------------------

Traditional File System (Real Files)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor "You" as user
   rectangle "Read file.txt" as cmd
   database "Hard Drive" as disk #lightgreen
   rectangle "File: Hello World" as file

   user -> cmd: cat file.txt
   cmd -> disk: Read from disk
   disk -> file: Data stored here
   file -> cmd: "Hello World"
   cmd -> user: Display "Hello World"

What happens:

1. You ask to read a file
2. Computer goes to hard drive
3. Reads actual data stored there
4. Shows you the data

/proc File System (Virtual Files)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor "You" as user
   rectangle "Read /proc/cpuinfo" as cmd
   rectangle "Linux Kernel" as kernel #lightblue
   rectangle "CPU Hardware" as cpu #pink

   user -> cmd: cat /proc/cpuinfo
   cmd -> kernel: "Generate cpuinfo!"
   kernel -> cpu: "What's your info?"
   cpu -> kernel: "I'm an Intel i7..."
   kernel -> kernel: Format the data
   kernel -> cmd: "Here's the text!"
   cmd -> user: Display CPU info
   note right of kernel: No disk involved!\nData created instantly!

What happens:

1. You ask to read ``/proc/cpuinfo``
2. Kernel says "Let me create that file right now!"
3. Kernel asks hardware for current info
4. Kernel formats it as text
5. Kernel sends it to you
6. The file disappears after you're done!

Think of it like: a magic book where the pages write themselves when
you open it, showing you what's happening right now!

Practical Examples
------------------------

Example 1: Find Which Process Is Using a File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Someone is using important.txt, who is it?
   lsof important.txt

   # OR look at all processes:
   ls -l /proc/*/fd/* | grep important.txt

Shows: the PID of the process using that file.

Real use case: "My disk is full, what process is writing to it?"

Example 2: Monitor a Process in Real-Time
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Watch process 1234's memory usage change
   watch -n 1 'cat /proc/1234/status | grep VmRSS'
   # VmRSS = Resident Set Size (actual RAM used)

**Analogy:** like having a heart rate monitor attached to a specific
process!

Example 3: See What Files a Process Has Open
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Process 1234 - what files does it have open?
   ls -l /proc/1234/fd/

   # Output might show:
   # 0 -> /dev/pts/0 (stdin - keyboard)
   # 1 -> /dev/pts/0 (stdout - screen)
   # 2 -> /dev/pts/0 (stderr - screen)
   # 3 -> /var/log/app.log (log file)
   # 4 -> /home/user/database.db (database)

Real use case: "Why can't I delete this file? Oh, process 1234 still
has it open!"

Example 4: Check CPU Features
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Does my CPU support AVX instructions?
   grep avx /proc/cpuinfo
   # If output shows "avx", then yes!

Real use case: "Can I run this video editing software? It needs
AVX2..."

Example 5: Find the Memory Hog
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Which process is using the most memory?
   for pid in /proc/[0-9]*; do
       echo "$(cat $pid/status 2>/dev/null | grep VmRSS | awk '{print $2}') $pid"
   done | sort -rn | head -5
   # Shows top 5 memory-using processes

Real use case: "My computer is slow, who's eating all the RAM?"

Special /proc Files You Can Write To
--------------------------------------------

Most ``/proc`` files are read-only, but some you can write to for
configuration!

**/proc/sys/ -- system tuning knobs**

.. code-block:: bash

   # See all system settings
   ls -R /proc/sys/

Common ones:

.. code-block:: text

   /proc/sys/net/ipv4/ip_forward       # Enable IP forwarding
   /proc/sys/vm/swappiness             # How aggressively to swap
   /proc/sys/kernel/hostname           # System hostname

Example: enable IP forwarding (for router/NAT)

.. code-block:: bash

   # Read current value
   cat /proc/sys/net/ipv4/ip_forward
   # Output: 0 (disabled)

   # Enable it
   echo 1 > /proc/sys/net/ipv4/ip_forward
   # Now your computer can forward packets (act as router)!

**Analogy:** like settings switches on your computer's control panel.
You can flip them on/off!

/proc vs /sys -- What's the Difference?
------------------------------------------------

Both are virtual filesystems, but different purposes:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 40 40

   * - Aspect
     - /proc
     - /sys
   * - Purpose
     - Process info + legacy system info
     - Modern hardware/driver info
   * - Organized by
     - Process ID (PID)
     - Device/driver hierarchy
   * - Introduced
     - Early Linux (1990s)
     - Linux 2.6 (2003)
   * - Structure
     - Mostly flat files
     - Tree structure

**Analogy:**

* ``/proc`` = old filing cabinet with process folders + misc system
  papers
* ``/sys`` = modern organized library with hardware catalogs

Example:

.. code-block:: text

   # /proc way (old, flat)
   /proc/cpuinfo

   # /sys way (new, organized)
   /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

Fun Facts About /proc
---------------------------

Files Show Size 0, But Have Content!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   ls -lh /proc/cpuinfo
   # Output: -r--r--r-- 1 root root 0 Oct  4 10:30 /proc/cpuinfo
   # Size shows 0, but...

   cat /proc/cpuinfo
   # Displays tons of CPU info!

Why? The file is generated on-the-fly when you read it. It doesn't
exist until you ask for it!

Some Files Are Write-Only
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # You can write to it but can't read it back!
   echo "Hello" > /proc/sysrq-trigger
   # (Don't actually do this -- sysrq-trigger processes each
   # character you write as its own command, and several of them
   # are destructive: e.g. it'll not just "reboot" but also
   # terminate every process and power off along the way)

Symbolic Links Point to Real Locations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   ls -l /proc/self/cwd
   cd /home/user/documents
   ls -l /proc/self/cwd
   # Output: lrwxrwxrwx 1 user user 0 Oct 4 10:30 /proc/self/cwd -> /home/user/documents

``/proc/self`` is a magic link that always points to the process
reading it (you!).

Troubleshooting with /proc
----------------------------------

Problem: "Process is stuck, can't kill it!"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check the process state:

.. code-block:: bash

   cat /proc/PID/status | grep State
   # D = Uninterruptible sleep (waiting for I/O - usually disk)
   # Z = Zombie (dead but parent didn't clean up)
   # R = Running
   # S = Sleeping (interruptible)

If state = ``D``: the process is waiting for disk/hardware. Usually
means a hardware problem!

If state = ``Z``: the process is a zombie. Kill its parent process to
clean it up.

Problem: "System feels slow"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check load average:

.. code-block:: bash

   cat /proc/loadavg
   # If the first number is much bigger than your CPU count,
   # the system is overloaded!

Check memory pressure:

.. code-block:: bash

   cat /proc/meminfo | grep -E "MemAvailable|SwapFree"
   # If MemAvailable is low and SwapFree is decreasing,
   # you're running out of RAM!

Problem: "Is this process still doing anything?"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check CPU time:

.. code-block:: bash

   cat /proc/PID/stat | awk '{print "User CPU: "$14" System CPU: "$15}'
   # Wait a few seconds, check again
   # If numbers don't change, process is idle!

Common /proc Files Quick Reference
------------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 35 40

   * - File
     - What It Shows
     - Use Case
   * - ``/proc/PID/cmdline``
     - Command that started process
     - "What program is this?"
   * - ``/proc/PID/status``
     - Process state, memory, etc.
     - "Why is it stuck?"
   * - ``/proc/PID/fd/``
     - Open files
     - "What's it accessing?"
   * - ``/proc/cpuinfo``
     - CPU information
     - "What CPU do I have?"
   * - ``/proc/meminfo``
     - Memory statistics
     - "How much RAM is free?"
   * - ``/proc/uptime``
     - System uptime
     - "How long has it been running?"
   * - ``/proc/loadavg``
     - System load
     - "Is my system overloaded?"
   * - ``/proc/net/dev``
     - Network statistics
     - "How much data transferred?"
   * - ``/proc/mounts``
     - Mounted filesystems
     - "What's mounted where?"
   * - ``/proc/version``
     - Kernel version
     - "What Linux version?"

Summary
------------

What is ``/proc``?

* A virtual filesystem (not on disk!)
* A window into the kernel's brain
* Files generated on-demand
* Shows live system state

Why is it useful?

* Debug processes
* Monitor system health
* Tune system parameters
* Investigate hardware
* Track network activity

Key concept: ``/proc`` is a real-time dashboard for your entire
computer!

Analogy recap:

* Traditional files = books on a shelf (stored on disk)
* ``/proc`` files = a magic mirror that shows you what's happening
  right now (generated by the kernel)

**Remember:** almost everything in ``/proc`` is read-only and
informational. The few writable files in ``/proc/sys/`` are for
system tuning -- be careful with those!

**Final tip:** when debugging Linux problems, ``/proc`` is your best
friend. It shows you exactly what's happening inside your system,
right now, in real-time!
