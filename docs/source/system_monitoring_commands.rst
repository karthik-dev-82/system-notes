System Monitoring Commands Reference
========================================

A comprehensive, practical cheatsheet for monitoring Linux process
performance, storage I/O, memory, and network activity.

Process & CPU Monitoring
----------------------------

htop & btop
~~~~~~~~~~~~~

Real-time, interactive process viewers and system resource monitors.

.. code-block:: bash

   htop                           # Launch interactive process viewer
   btop                           # Modern visual alternative (if installed)

* **Key Features:** Visual CPU/RAM bars, interactive process management,
  process trees.
* **Essential Shortcuts:**

  * ``F5``: Toggle process tree view
  * ``F6``: Sort by column (CPU%, MEM%, PID)
  * ``F9``: Send signal / Kill process
  * ``F10``: Exit

pidstat
~~~~~~~~~

Monitors resource utilization for individual Linux processes and threads.

.. code-block:: bash

   pidstat 1                      # CPU usage per process every second
   pidstat -d 1                   # Disk I/O usage per process
   pidstat -r 1                   # Memory statistics per process
   pidstat -u -p <PID> 1          # Monitor a specific PID continuously

Memory & System Performance
--------------------------------

vmstat (Virtual Memory Statistics)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Reports virtual memory, process, disk activity, and CPU time breakdown.

.. code-block:: bash

   vmstat 1 5                     # Report stats every 1 second, 5 times total
   vmstat -s                      # Display event counters and memory summary
   vmstat -d                      # Display disk statistics summary

.. list-table::
   :header-rows: 1
   :widths: 15 20 65

   * - Field Group
     - Metric
     - Description
   * - **Procs**
     - ``r``
     - Processes waiting for run time (CPU queue length)
   * - **Memory**
     - ``free`` / ``buff`` / ``cache``
     - Free memory vs. OS buffers and page cache
   * - **Swap**
     - ``si`` / ``so``
     - Swap-in / Swap-out rate per second *(High numbers indicate low RAM)*
   * - **CPU**
     - ``us`` / ``sy`` / ``wa``
     - User CPU time / System CPU time / I/O Wait time

Storage & Disk I/O Monitoring
----------------------------------

iotop
~~~~~~~

Monitors real-time disk I/O usage per process *(Requires root/sudo)*.

.. code-block:: bash

   sudo iotop                     # Interactive I/O monitor
   sudo iotop -o                  # Show ONLY processes actively doing I/O
   sudo iotop -b -n 3             # Batch mode (useful for logging scripts)

iostat
~~~~~~~~

Reports detailed I/O and CPU performance metrics for storage devices.

.. code-block:: bash

   iostat -x 1                    # Extended statistics updated every second
   iostat -d                      # Disk statistics only
   iostat -p ALL                  # Statistics for all individual partitions

* **Critical Metrics to Watch:**

  * ``%util``: Device saturation percentage. Values approaching **100%**
    indicate an I/O bottleneck.
  * ``await``: Average time (in ms) taken for I/O requests to be serviced.

Network Connection & Bandwidth
-----------------------------------

ss (Socket Statistics)
~~~~~~~~~~~~~~~~~~~~~~~~

Fast, modern utility to inspect active network sockets *(Replaces
``netstat``)*.

.. code-block:: bash

   ss -tunlp                      # Show listening TCP/UDP sockets with process names/PIDs
   ss -s                          # Output summary statistics of all open sockets
   ss state established           # List active established network connections

netstat *(Legacy)*
~~~~~~~~~~~~~~~~~~~~

Traditional network utility. *(Note: Deprecated on newer Linux distros in
favor of* ``ss`` *)*.

.. code-block:: bash

   netstat -tulpn                 # Show listening TCP/UDP ports
   netstat -r                     # Display system routing table

iftop
~~~~~~~

Real-time bandwidth usage breakdown per network host connection *(Requires
root/sudo)*.

.. code-block:: bash

   sudo iftop -n                  # Display bandwidth without resolving hostnames
   sudo iftop -P                  # Show port numbers alongside host connections

Pro Tips & Dashboard Workflows
-----------------------------------

1. Dynamic Watch Loops
~~~~~~~~~~~~~~~~~~~~~~~~

Monitor top resource consumers in real-time using ``watch``:

.. code-block:: bash

   # Watch the top 5 CPU-consuming processes (updates every 1s)
   watch -n 1 'ps aux --sort=-%cpu | head -n 6'

   # Monitor memory usage updates continuously
   watch -n 1 'free -h'

2. Instant Terminal Dashboard (via ``tmux``)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Split your terminal into a single multi-tool monitoring grid:

.. code-block:: bash

   tmux new-session \
       'htop' \; split-window -h \
       'sudo iotop' \; split-window -v \
       'watch -n 1 ss -tunlp'

3. Background Performance Logging
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Capture system activity metrics for post-incident analysis:

.. code-block:: bash

   # Log detailed system activity for 1 hour (3600 seconds)
   sar 1 3600 > system_stats.log &

   # Log extended disk I/O metrics to file
   iostat -tdx 1 > io_stats.log &
