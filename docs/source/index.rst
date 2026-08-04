System Notes
===================

A curated collection of reference guides and revision notes -- Linux
internals, networking, containers, and whatever else is worth writing
down and coming back to.

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Guides

   bashrc_reference
   developer_commands
   system_monitoring_commands
   network_interfaces
   docker_dev_environment
   spdlog_sinks_architecture
   linux_devices
   kernel_networking_docker_internals
   lidar_slam
   ssh_secure_shell
   unicode_utf8_encoding
   base64_encoding
   databases_postgresql_mongodb_redis
   image_formats
   threads_processes_synchronization
   openssl_guide
   proc_filesystem
   hash_load_balancer
   tcp_udp_interactive
   tcp_congestion_control_interactive
   docker_packet_journey_interactive
   threads_sync_interactive
   hash_load_balancer_interactive
   consistent_hashing_interactive
   proc_filesystem_interactive
   linux_fs_basics_interactive
   overlayfs_interactive
   cpp_memory_interactive
   cpp_raii_smart_pointers_interactive
   python_sequences_interactive
   python_hashing_interactive
   network_interfaces_interactive

Quick Navigation
-----------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`bashrc_reference`
     - Interactive shell setup, aliases, and functions
     - ``.bashrc``, aliases, ``__setprompt``, ``ssh-agent``
   * - :doc:`system_monitoring_commands`
     - Performance, diagnostics & resource analysis
     - ``htop``, ``vmstat``, ``iotop``, ``iostat``, ``ss``, ``pidstat``
   * - :doc:`developer_commands`
     - Daily engineering workflows & tooling
     - ``docker``, ``git``, ``rsync``, ``aria2c``, ``find``, ``grep``
   * - :doc:`network_interfaces`
     - Linux network interfaces, explained with analogies & diagrams
     - ``eth0``, ``lo``, ``veth``, ``docker0``, VLANs, TUN/TAP, NAT
   * - :doc:`docker_dev_environment`
     - How the ``development`` repo's Docker dev container is built
     - ``Dockerfile``, ``devcontainer.json``, ``docker-compose.yml``
   * - :doc:`spdlog_sinks_architecture`
     - spdlog logging architecture, sinks, and log levels
     - ``spdlog``, sinks, formatters, log levels, rotation
   * - :doc:`linux_devices`
     - Block/char/network/terminal/pseudo devices, and USB layering
     - ``/dev``, ``lsblk``, ``ttyACM``/``ttyUSB``, ``udevadm``, PTYs
   * - :doc:`kernel_networking_docker_internals`
     - Kernel networking stack, Docker internals, iptables, OverlayFS
     - netfilter, namespaces, cgroups, veth, DNAT/MASQUERADE, overlay2
   * - :doc:`lidar_slam`
     - LIDAR and SLAM for navigation where GPS doesn't work
     - point clouds, localization, mapping, autonomous vehicles
   * - :doc:`ssh_secure_shell`
     - How the SSH handshake, encryption, and key auth actually work
     - key exchange, host keys, password vs. key auth, tunneling
   * - :doc:`unicode_utf8_encoding`
     - How Unicode code points and UTF-8's variable-length encoding work
     - code points, planes, UTF-8 bit patterns, multi-byte characters
   * - :doc:`base64_encoding`
     - Base64, ASCII, URL encoding, and hex, explained with analogies
     - Base64 alphabet, percent-encoding, MIME attachments, hex colors
   * - :doc:`databases_postgresql_mongodb_redis`
     - PostgreSQL, MongoDB, and Redis compared with a kitchen analogy
     - joins, documents, key-value, ACID, indexes, sorted sets
   * - :doc:`image_formats`
     - SVG vs. PNG vs. JPEG, and when to use each
     - vector vs. raster, transparency, lossy/lossless compression
   * - :doc:`threads_processes_synchronization`
     - Threads, processes, and synchronization primitives in C++
     - mutex, semaphore, condition variable, deadlock, race conditions
   * - :doc:`openssl_guide`
     - Encryption, hashing, and certificates, plus practical OpenSSL commands
     - symmetric/asymmetric crypto, TLS, x509 certs, ``openssl`` CLI
   * - :doc:`proc_filesystem`
     - The virtual /proc filesystem -- process info, system stats, tuning knobs
     - ``/proc/PID``, ``/proc/cpuinfo``, ``/proc/meminfo``, ``/proc/sys``
   * - :doc:`hash_load_balancer`
     - Hash-based load balancing, sticky sessions, and consistent hashing
     - modulo hashing, session affinity, CDN routing, reshuffling problem
   * - :doc:`tcp_udp_interactive`
     - Interactive TCP vs. UDP packet delivery -- play with loss and see the difference
     - handshake, retransmission, ordering, best-effort delivery
   * - :doc:`tcp_congestion_control_interactive`
     - Interactive TCP congestion control -- drive the cwnd sawtooth yourself
     - slow start, congestion avoidance, fast retransmit, timeout, ssthresh
   * - :doc:`docker_packet_journey_interactive`
     - Interactive packet journey -- container, veth, docker0, netfilter, and back
     - MASQUERADE, DNAT, PREROUTING/POSTROUTING, conntrack
   * - :doc:`threads_sync_interactive`
     - Interactive threads & synchronization -- step through race conditions and deadlock yourself
     - mutex, semaphore, condition variable, race condition, deadlock
   * - :doc:`hash_load_balancer_interactive`
     - Interactive hash load balancer -- 10 clients, 3 servers, naive modulo hashing, and what a flow actually is
     - flow 5-tuple, hash % N, connection vs. user stickiness
   * - :doc:`consistent_hashing_interactive`
     - Interactive consistent hashing ring -- add/remove servers and watch what actually moves
     - hash ring, virtual nodes, reshuffling, load balancing
   * - :doc:`proc_filesystem_interactive`
     - Live /proc explorer -- click any path and watch it get generated on demand
     - /proc/PID, meminfo, loadavg, uptime, process lifecycle
   * - :doc:`linux_fs_basics_interactive`
     - Interactive inodes/links and mounting/VFS -- the foundation OverlayFS builds on
     - inodes, hard links, symlinks, mount points, VFS
   * - :doc:`overlayfs_interactive`
     - Interactive OverlayFS -- read/write/delete across layers, watch copy-up and whiteouts
     - lowerdir, upperdir, merged view, copy-up, whiteouts
   * - :doc:`cpp_memory_interactive`
     - Interactive C++ memory bugs -- dangling references, heap leaks, use-after-free, double-free
     - stack frames, heap allocation, raw pointers, undefined behavior
   * - :doc:`cpp_raii_smart_pointers_interactive`
     - Interactive RAII and smart pointers -- unique_ptr ownership/move, shared_ptr refcounting and the circular-reference leak
     - RAII, unique_ptr, shared_ptr, weak_ptr, reference counting
   * - :doc:`python_sequences_interactive`
     - Interactive Python list/stack/queue/deque -- CPython's real growth formula and probing, verified against source
     - dynamic arrays, amortized O(1), LIFO/FIFO, deque blocks
   * - :doc:`python_hashing_interactive`
     - Interactive Python dict/set -- real CPython collision probing, resize thresholds, and set algebra
     - hash tables, open addressing, insertion order, union/intersection/difference
   * - :doc:`network_interfaces_interactive`
     - Interactive bridge, TUN/TAP, and VLAN demos -- MAC learning, Layer 2 vs Layer 3 framing, 802.1Q isolation
     - MAC learning table, TUN/TAP, 802.1Q tagging, VLAN isolation
