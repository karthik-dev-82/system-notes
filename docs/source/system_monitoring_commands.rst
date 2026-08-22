System Monitoring Commands Reference
========================================

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
   :class: longtable
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
