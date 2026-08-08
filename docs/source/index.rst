System Notes
===================

A curated collection of reference guides and revision notes -- Linux
internals, networking, containers, C++, Python, and whatever else is
worth writing down and coming back to.

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Shell & System Basics

   bashrc_reference
   system_monitoring_commands
   developer_commands
   linux_devices

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Networking

   network_interfaces_interactive
   network_interfaces
   tcp_udp_interactive
   tcp_congestion_control_interactive
   docker_packet_journey_interactive
   kernel_networking_docker_internals
   dns_resolution_interactive

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Containers & Filesystems

   docker_dev_environment
   linux_fs_basics_interactive
   overlayfs_interactive
   proc_filesystem_interactive
   proc_filesystem

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Memory & Processes

   process_memory_layout_interactive
   vma_paging_interactive
   cow_fork_interactive
   page_cache_interactive
   latency_numbers_interactive

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Security & Cryptography

   ssh_secure_shell_interactive
   ssh_secure_shell
   tls_cert_chain_interactive
   openssl_guide
   bitcoin_mining_interactive
   bitcoin_distributed_ledgers_zcash

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Encoding & Formats

   utf8_encoding_interactive
   unicode_utf8_encoding
   base64_encoding
   image_formats

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Databases

   databases_postgresql_mongodb_redis
   db_index_scan_interactive
   db_redis_structures_interactive
   db_acid_transaction_interactive

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Concurrency & Distributed Systems

   threads_sync_interactive
   threads_processes_synchronization
   hash_load_balancer_interactive
   consistent_hashing_interactive
   hash_load_balancer

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Robotics

   lidar_slam

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: C++ Notes

   spdlog_sinks_architecture
   conan_package_manager
   cpp_memory_interactive
   cpp_raii_smart_pointers_interactive
   cpp_move_semantics_interactive
   cpp_vtable_interactive
   cpp_exception_unwind_interactive

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Python Notes

   python_sequences_interactive
   python_hashing_interactive
   python_generators_interactive
   python_context_managers_interactive
   python_coroutines_interactive
   python_async_generators_interactive
   python_concurrency_interactive
   python_asyncio_gather_interactive

Shell & System Basics
-----------------------------

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
   * - :doc:`linux_devices`
     - Block/char/network/terminal/pseudo devices, and USB layering
     - ``/dev``, ``lsblk``, ``ttyACM``/``ttyUSB``, ``udevadm``, PTYs

Networking
-----------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`network_interfaces_interactive`
     - Interactive bridge, TUN/TAP, and VLAN demos -- MAC learning, Layer 2 vs Layer 3 framing, 802.1Q isolation
     - MAC learning table, TUN/TAP, 802.1Q tagging, VLAN isolation
   * - :doc:`network_interfaces`
     - Linux network interfaces, explained with analogies & diagrams
     - ``eth0``, ``lo``, ``veth``, ``docker0``, VLANs, TUN/TAP, NAT
   * - :doc:`tcp_udp_interactive`
     - Interactive TCP vs. UDP packet delivery -- play with loss and see the difference
     - handshake, retransmission, ordering, best-effort delivery
   * - :doc:`tcp_congestion_control_interactive`
     - Interactive TCP congestion control -- drive the cwnd sawtooth yourself
     - slow start, congestion avoidance, fast retransmit, timeout, ssthresh
   * - :doc:`docker_packet_journey_interactive`
     - Interactive packet journey -- container, veth, docker0, netfilter, and back
     - MASQUERADE, DNAT, PREROUTING/POSTROUTING, conntrack
   * - :doc:`kernel_networking_docker_internals`
     - Kernel networking stack, Docker internals, iptables, OverlayFS
     - netfilter, namespaces, cgroups, veth, DNAT/MASQUERADE, overlay2
   * - :doc:`dns_resolution_interactive`
     - Interactive DNS resolver -- walk root/TLD/authoritative, then watch layered TTL caching and CNAME-following in action
     - recursive resolver, referral chain, TTL caching, CNAME

Containers & Filesystems
------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`docker_dev_environment`
     - How the ``development`` repo's Docker dev container is built
     - ``Dockerfile``, ``devcontainer.json``, ``docker-compose.yml``
   * - :doc:`linux_fs_basics_interactive`
     - Interactive inodes/links and mounting/VFS -- the foundation OverlayFS builds on
     - inodes, hard links, symlinks, mount points, VFS
   * - :doc:`overlayfs_interactive`
     - Interactive OverlayFS -- read/write/delete across layers, watch copy-up and whiteouts
     - lowerdir, upperdir, merged view, copy-up, whiteouts
   * - :doc:`proc_filesystem_interactive`
     - Live /proc explorer -- click any path and watch it get generated on demand
     - /proc/PID, meminfo, loadavg, uptime, process lifecycle
   * - :doc:`proc_filesystem`
     - The virtual /proc filesystem -- process info, system stats, tuning knobs
     - ``/proc/PID``, ``/proc/cpuinfo``, ``/proc/meminfo``, ``/proc/sys``

Memory & Processes
-------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`process_memory_layout_interactive`
     - Interactive process address space -- click code to see where it lands, then watch ASLR reshuffle it
     - text/data/bss/heap/mmap/stack segments, ASLR
   * - :doc:`vma_paging_interactive`
     - Interactive VMAs and page tables -- grow the heap for free, then watch a real page fault get resolved
     - VMAs, page tables, page faults, lazy allocation
   * - :doc:`cow_fork_interactive`
     - Interactive copy-on-write -- fork() a process for free, then watch a write fault either reuse a frame or copy it
     - fork(), copy-on-write, page faults, reference counting
   * - :doc:`page_cache_interactive`
     - Interactive page cache -- two processes share one cache, mmap() skips the copy, crash before fsync() and lose it
     - page cache, mmap, fsync, write-back, cross-process sharing
   * - :doc:`latency_numbers_interactive`
     - Interactive latency ladder -- 2012 vs. 2024 hardware, plus a human-timescale rescaling of every hop
     - CPU cache, RAM, SSD/NVMe, datacenter RTT, cross-continent RTT

Security & Cryptography
------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`ssh_secure_shell_interactive`
     - Interactive SSH handshake -- a real toy-scale Diffie-Hellman exchange, host-key MITM detection, and both auth methods
     - Diffie-Hellman, host key fingerprints, password vs. public-key auth
   * - :doc:`ssh_secure_shell`
     - How the SSH handshake, encryption, and key auth actually work
     - key exchange, host keys, password vs. key auth, tunneling
   * - :doc:`tls_cert_chain_interactive`
     - Interactive TLS certificate chain -- real ECDSA signatures, four independent trust checks, break each one separately
     - certificate chain, root/intermediate/leaf, trust store, hostname verification
   * - :doc:`openssl_guide`
     - Encryption, hashing, and certificates, plus practical OpenSSL commands
     - symmetric/asymmetric crypto, TLS, x509 certs, ``openssl`` CLI
   * - :doc:`bitcoin_mining_interactive`
     - Interactive Bitcoin mining -- real SHA-256 in your browser, tamper with a block and watch the cascade
     - proof of work, SHA-256, block hashing, 51% attack cost
   * - :doc:`bitcoin_distributed_ledgers_zcash`
     - Bitcoin, distributed ledgers, and Zcash explained with analogies
     - blockchain, proof of work, mining, zero-knowledge proofs

Encoding & Formats
-------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`utf8_encoding_interactive`
     - Interactive UTF-8 encode/decode -- step through the real bit-slicing byte by byte, then run it backward
     - code points, byte-length ranges, bit slicing, self-sync/resync
   * - :doc:`unicode_utf8_encoding`
     - How Unicode code points and UTF-8's variable-length encoding work
     - code points, planes, UTF-8 bit patterns, multi-byte characters
   * - :doc:`base64_encoding`
     - Base64, ASCII, URL encoding, and hex, explained with analogies
     - Base64 alphabet, percent-encoding, MIME attachments, hex colors
   * - :doc:`image_formats`
     - SVG vs. PNG vs. JPEG, and when to use each
     - vector vs. raster, transparency, lossy/lossless compression

Databases
-----------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`databases_postgresql_mongodb_redis`
     - PostgreSQL, MongoDB, and Redis compared with a kitchen analogy
     - joins, documents, key-value, ACID, indexes, sorted sets
   * - :doc:`db_index_scan_interactive`
     - Interactive index vs. full scan -- same 20-country query, run two ways, real cost numbers
     - indexes, binary search, hash lookup, query planning
   * - :doc:`db_redis_structures_interactive`
     - Interactive Redis structures -- hash, sorted set, set, and TTL cache, all on the same country data
     - hashes, sorted sets, leaderboards, set intersection, TTL/expiry
   * - :doc:`db_acid_transaction_interactive`
     - Interactive ACID atomicity -- insert a country and capital together, force a mid-way failure, watch rollback vs. an orphaned row
     - transactions, atomicity, rollback, foreign keys, referential integrity

Concurrency & Distributed Systems
-----------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`threads_sync_interactive`
     - Interactive threads & synchronization -- step through race conditions and deadlock yourself
     - mutex, semaphore, condition variable, race condition, deadlock
   * - :doc:`threads_processes_synchronization`
     - Threads, processes, and synchronization primitives in C++
     - mutex, semaphore, condition variable, deadlock, race conditions
   * - :doc:`hash_load_balancer_interactive`
     - Interactive hash load balancer -- 10 clients, 3 servers, naive modulo hashing, and what a flow actually is
     - flow 5-tuple, hash % N, connection vs. user stickiness
   * - :doc:`consistent_hashing_interactive`
     - Interactive consistent hashing ring -- add/remove servers and watch what actually moves
     - hash ring, virtual nodes, reshuffling, load balancing
   * - :doc:`hash_load_balancer`
     - Hash-based load balancing, sticky sessions, and consistent hashing
     - modulo hashing, session affinity, CDN routing, reshuffling problem

Robotics
-----------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`lidar_slam`
     - LIDAR and SLAM for navigation where GPS doesn't work
     - point clouds, localization, mapping, autonomous vehicles

C++ Notes
-----------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`spdlog_sinks_architecture`
     - spdlog logging architecture, sinks, and log levels
     - ``spdlog``, sinks, formatters, log levels, rotation
   * - :doc:`conan_package_manager`
     - Conan package manager for C++ -- conanfile structure, generators, and commands
     - ``conanfile.txt``, ``conanfile.py``, generators, ConanCenter
   * - :doc:`cpp_memory_interactive`
     - Interactive C++ memory bugs -- dangling references, heap leaks, use-after-free, double-free
     - stack frames, heap allocation, raw pointers, undefined behavior
   * - :doc:`cpp_raii_smart_pointers_interactive`
     - Interactive RAII and smart pointers -- unique_ptr ownership/move, shared_ptr refcounting and the circular-reference leak
     - RAII, unique_ptr, shared_ptr, weak_ptr, reference counting
   * - :doc:`cpp_move_semantics_interactive`
     - Interactive move semantics -- copy vs move construction cost, made countable
     - move constructor, std::move, moved-from state, noexcept
   * - :doc:`cpp_vtable_interactive`
     - Interactive virtual dispatch and vtables -- plus the classic non-virtual-destructor leak
     - vtable, vptr, dynamic dispatch, virtual destructor
   * - :doc:`cpp_exception_unwind_interactive`
     - Interactive exception unwinding -- RAII cleanup during unwind, and why a destructor must never throw
     - stack unwinding, RAII, std::terminate, noexcept

Python Notes
-----------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`python_sequences_interactive`
     - Interactive Python list/stack/queue/deque -- CPython's real growth formula and probing, verified against source
     - dynamic arrays, amortized O(1), LIFO/FIFO, deque blocks
   * - :doc:`python_hashing_interactive`
     - Interactive Python dict/set -- real CPython collision probing, resize thresholds, and set algebra
     - hash tables, open addressing, insertion order, union/intersection/difference
   * - :doc:`python_generators_interactive`
     - Interactive generators -- step through next()/send()/throw()/close(), then measure laziness against a list comprehension
     - yield, suspended frames, StopIteration, two-way communication
   * - :doc:`python_context_managers_interactive`
     - Interactive context managers -- class-based vs @contextmanager side by side, four scenarios, identical outcomes
     - with statement, __enter__/__exit__, contextlib, exception suppression
   * - :doc:`python_coroutines_interactive`
     - Interactive toy event loop -- a real hand-built scheduler driving coroutines, plus await delegation chained through nested calls
     - async/await, event loop, cooperative scheduling, await delegation
   * - :doc:`python_async_generators_interactive`
     - Interactive async generators and async context managers -- yield meets await, and __aenter__/__aexit__ take real time without blocking a sibling task
     - async generator, async for, __aenter__, __aexit__, asynccontextmanager
   * - :doc:`python_concurrency_interactive`
     - Interactive multiprocessing vs threading vs asyncio -- the same 3 tasks, 4 scheduling strategies, run side by side
     - GIL, pre-emptive vs cooperative multitasking, CPU-bound vs I/O-bound
   * - :doc:`python_asyncio_gather_interactive`
     - Interactive asyncio.gather() -- 3 real coroutines, real console output, and the argument-order-vs-completion-order guarantee made concrete
     - async/await, asyncio.gather, asyncio.TaskGroup, coroutine scheduling
