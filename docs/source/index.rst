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
   poe_the_poet_interactive
   linux_devices
   usb_binding_interactive
   tty_sessions_interactive

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
   rest_api_interactive
   rest_vs_rpc_interactive
   long_poll_vs_ws_interactive

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
   :caption: Processor Architecture

   processor_architecture
   cpu_vs_gpu_interactive
   cuda_gpu_architecture

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Machine Learning

   pytorch_basics_interactive

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
   :caption: Hardware Protocols

   8b10b_encoding_interactive
   can_arbitration_interactive
   watchdog_timer_interactive

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Media & Streaming

   gstreamer_pipeline_interactive

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Databases

   databases_postgresql_mongodb_redis
   db_country_dataset
   db_index_scan_interactive
   db_redis_structures_interactive
   db_acid_transaction_interactive
   db_composite_index_interactive
   cassandra_interactive

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Concurrency & Distributed Systems

   threads_sync_interactive
   threads_processes_synchronization
   hash_load_balancer_interactive
   consistent_hashing_interactive
   hash_load_balancer
   kafka_topic_interactive
   delivery_semantics_interactive
   priority_inversion_interactive

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Architectural Patterns

   architectural_patterns

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: System Design

   cap_theorem_interactive
   rate_limiting_interactive
   bloom_filter_interactive
   normalization_denormalization_interactive
   database_sharding_interactive
   cache_strategies_interactive
   raft_consensus_interactive
   proxy_servers_interactive
   cdn_interactive
   resilience_patterns_interactive
   url_shortener_interactive

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Robotics

   lidar_slam
   lidar_pointcloud_interactive
   slam_scan_matching_interactive

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: C++ Notes

   spdlog_sinks_architecture
   spdlog_sinks_interactive
   conan_package_manager
   cpp_memory_interactive
   cpp_raii_smart_pointers_interactive
   cpp_smart_pointers_interactive
   cpp_move_semantics_interactive
   cpp_ranges_interactive
   cpp_vtable_interactive
   cpp_exception_unwind_interactive
   cpp_singleton_interactive
   cpp_command_interactive
   cpp_observer_interactive
   cpp_strategy_interactive
   cpp_decorator_interactive
   cpp_futures_promises_interactive
   cpp_scoped_lock_interactive
   cpp_coroutines_interactive

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Python Notes

   python_sequences_interactive
   python_hashing_interactive
   python_generators_interactive
   py_itertools_interactive
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
   * - :doc:`poe_the_poet_interactive`
     - Play With It: a real Poe the Poet task-resolution simulator -- task types, arg passthrough, sequence fail-fast, hidden tasks
     - poe, pyproject.toml, cmd/shell/script/expr, sequence, parallel, switch
   * - :doc:`linux_devices`
     - Block/char/network/terminal/pseudo devices, and USB layering
     - ``/dev``, ``lsblk``, ``ttyACM``/``ttyUSB``, ``udevadm``, PTYs
   * - :doc:`usb_binding_interactive`
     - Play With It: class vs. vendor-chip driver binding, live
     - ``cdc_acm``, ``ftdi_sio``/``cp210x``/``ch341``/``pl2303``, minor numbers
   * - :doc:`tty_sessions_interactive`
     - Play With It: PTY/console/serial session allocation, live
     - ``/dev/pts/N``, ``tty1``-``tty6``, ``ttyS0``, ``who``

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
   * - :doc:`rest_api_interactive`
     - Tutorial + Play With It: a real in-browser REST API -- resources, HTTP methods, status codes, and genuine idempotency behavior
     - GET/POST/PUT/PATCH/DELETE, safe vs. idempotent, status codes, statelessness
   * - :doc:`rest_vs_rpc_interactive`
     - Interactive REST vs. RPC -- identical flaky-network retry storm hits three handlers side by side, one of them double-charges
     - idempotency, retry safety, idempotency keys, gRPC/JSON-RPC vs. resource verbs
   * - :doc:`long_poll_vs_ws_interactive`
     - Interactive long polling vs. WebSockets -- same event schedule, live request-count and delivery-latency comparison
     - server push, request overhead, reconnect-gap latency, persistent connections

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

Processor Architecture
----------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`processor_architecture`
     - Beyond the Bridges -- where memory and I/O connect in modern Intel, AMD, and ARM chips, and why northbridge/southbridge is now historical
     - SoC tile, PCH, DMI, CCD/IOD, Infinity Fabric, unified memory, CMN mesh
   * - :doc:`cpu_vs_gpu_interactive`
     - Play With It: the real GPU transfer/launch-overhead crossover -- drag matrix size N and watch where the GPU actually stops being the faster choice, fuzz-verified against a real formula
     - CPU cores vs GPU cores, transfer overhead, kernel launch, N-cubed scaling, crossover point
   * - :doc:`cuda_gpu_architecture`
     - The CUDA Moat -- why GPUs suit neural-net math, and why CUDA specifically (not GPUs generically) is NVIDIA's real moat
     - SM, CUDA/Tensor cores, HBM, CUDA vs. ROCm/OpenCL, NVLink, NVSwitch

Machine Learning
-----------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`pytorch_basics_interactive`
     - Play With It: a real tensor, a real forward/loss/backward training loop, and autograd verified live against finite-difference numerical gradients -- the same gradcheck technique PyTorch's own tests use
     - tensors, autograd, gradient descent, loss, backward pass, gradcheck

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

Hardware Protocols
-------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`8b10b_encoding_interactive`
     - Interactive 8b/10b-style line coding -- send a byte, watch running disparity keep the wire from ever going flat
     - running disparity, DC balance, clock recovery, sub-block encoding
   * - :doc:`can_arbitration_interactive`
     - Interactive CAN bus arbitration -- pick contending nodes, watch the real bit-by-bit priority race
     - dominant/recessive bits, wired-AND, bitwise arbitration, priority
   * - :doc:`watchdog_timer_interactive`
     - Play With It: a real countdown you pet or freeze yourself, plus a real window watchdog whose too-early-pet fault is fuzz-verified
     - watchdog timer, petting, window watchdog, forced reset, embedded reliability

Media & Streaming
-------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`gstreamer_pipeline_interactive`
     - Interactive GStreamer pipeline builder -- chain elements together, real caps negotiation, decodebin's dynamic pad
     - pads, caps negotiation, decodebin, pipeline states

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
   * - :doc:`db_country_dataset`
     - The full 20-country dataset reused across every database page, in one place
     - id, iso2, region, population, gdpPerCapita, currency, capital
   * - :doc:`db_index_scan_interactive`
     - Interactive index vs. full scan -- same 20-country query, run two ways, real cost numbers
     - indexes, binary search, hash lookup, query planning
   * - :doc:`db_redis_structures_interactive`
     - Interactive Redis structures -- hash, sorted set, set, and TTL cache, all on the same country data
     - hashes, sorted sets, leaderboards, set intersection, TTL/expiry
   * - :doc:`db_acid_transaction_interactive`
     - Interactive ACID atomicity and isolation -- rollback vs. an orphaned row, plus dirty/non-repeatable/phantom reads and write skew, built and prevented live
     - transactions, atomicity, rollback, isolation levels, MVCC, write skew, serializable
   * - :doc:`db_composite_index_interactive`
     - Play With It: composite indexes and the leftmost prefix rule, live
     - composite index, leftmost prefix, covering index, query planner
   * - :doc:`cassandra_interactive`
     - Play With It: the real N/W/R quorum-overlap guarantee run as a live fuzz test, plus a real memtable/SSTable/compaction LSM-tree you can write, read, and compact yourself
     - tunable consistency, quorum, hinted handoff, read repair, LSM-tree, memtable, SSTable, compaction, tombstone

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
   * - :doc:`kafka_topic_interactive`
     - Interactive Kafka topic -- send keyed readings, watch partition routing, poll with consumer groups, rebalance live -- plus kill the leader and watch real replication and clean vs. unclean election
     - partitions, consumer groups, offsets, rebalancing, replay, ISR, leader election, unclean.leader.election.enable
   * - :doc:`delivery_semantics_interactive`
     - Play With It: at-most-once/at-least-once/idempotent delivery run side by side on the same flaky pipeline -- deliveries vs. effects tracked as two separate numbers
     - idempotency key, at-least-once, exactly-once, effectively-once, Kafka offset commit timing
   * - :doc:`priority_inversion_interactive`
     - Interactive priority inversion -- the bug that nearly stranded Mars Pathfinder, and the priority-inheritance fix, side by side
     - preemption, mutex, priority inheritance, real-time scheduling

Architectural Patterns
-----------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`architectural_patterns`
     - The five shapes a system's components can be arranged in -- client-server, microservices, serverless, event-driven, peer-to-peer -- with a real trade-off and worked example for each, cross-linked to where it already lives on this site
     - client-server, microservices, serverless, cold start, event-driven, peer-to-peer

System Design
-----------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`cap_theorem_interactive`
     - Play With It: partition a 2-node store and choose Consistency or Availability, then see why quorum-based systems don't lose everyone
     - CAP theorem, partition tolerance, AP vs. CP, quorum, last-write-wins, strong vs. eventual consistency
   * - :doc:`rate_limiting_interactive`
     - Play With It: 5 rate-limiting algorithms fired at the same burst -- watch them disagree at the exact same moment
     - token bucket, leaky bucket, fixed window, sliding window log, sliding window counter
   * - :doc:`bloom_filter_interactive`
     - Play With It: a real bit array and real hash functions -- add words, test words, measure false positives against the textbook formula
     - bloom filter, false positive rate, double hashing, FNV-1a
   * - :doc:`normalization_denormalization_interactive`
     - Play With It: the same data two ways, real PostgreSQL EXPLAIN costs, and a real reproduced update anomaly
     - normalization, denormalization, joins, update anomaly, EXPLAIN ANALYZE
   * - :doc:`database_sharding_interactive`
     - Play With It: hash-based vs. range-based sharding on the same sequential-key workload -- the real hot-shard problem and two different rebalancing operations
     - sharding, hash sharding, range sharding, hot shard, rebalancing, scatter-gather
   * - :doc:`cache_strategies_interactive`
     - Play With It: cache-aside/read-through/write-through/write-back (crash the cache and see what's actually lost), plus LRU/FIFO/LFU/TTL run side by side on one access sequence
     - cache-aside, read-through, write-through, write-back, LRU, FIFO, LFU, TTL
   * - :doc:`raft_consensus_interactive`
     - Play With It: real Raft leader election (randomized timeouts, forced split votes, quorum loss) and log replication (AppendEntries, consistency check, majority commit)
     - Raft, leader election, terms, log replication, AppendEntries, quorum, consensus
   * - :doc:`proxy_servers_interactive`
     - Play With It: the real X-Forwarded-For spoofing bug (naive vs trusted-hop-count parsing, fuzz-verified) and what TLS termination actually does and doesn't imply
     - forward proxy, reverse proxy, X-Forwarded-For, TLS termination, trusted proxies
   * - :doc:`cdn_interactive`
     - Play With It: the real thundering-herd/request-coalescing mechanism on a cold edge POP, and cache-key composition's two opposite failure modes, fuzz-verified
     - CDN, edge POP, thundering herd, request coalescing, cache key, origin pull
   * - :doc:`resilience_patterns_interactive`
     - Play With It: a real closed/open/half-open circuit breaker across 8 service instances (watch fixed vs. jittered reset timeouts either synchronize or spread a recovery-probe herd), plus bulkhead pool isolation protecting a healthy dependency from a flaky one
     - circuit breaker, half-open probe, jittered backoff, thundering herd, bulkhead, noisy neighbor
   * - :doc:`url_shortener_interactive`
     - Case study: a worked "design a URL shortener" interview question end to end -- capacity math, real base62/hash short-code generation with live collision handling, and where sharding, caching, rate limiting, and consensus each actually fit
     - short-code generation, base62, capacity estimation, system design synthesis

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
   * - :doc:`lidar_pointcloud_interactive`
     - Play With It: ray-vs-wall geometry, real time-of-flight math, live
     - ray casting, point cloud, terrestrial vs. mobile scanning
   * - :doc:`slam_scan_matching_interactive`
     - Play With It: odometry drift vs. ICP scan-matching correction, live
     - ICP, point-to-point matching, pose estimation, dead reckoning

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
   * - :doc:`spdlog_sinks_interactive`
     - Play With It: logger-then-sink level cascade, live
     - ``set_level``, ``trace``-``critical``/``off``, per-sink pattern
   * - :doc:`conan_package_manager`
     - Conan package manager for C++ -- conanfile structure, generators, and commands
     - ``conanfile.txt``, ``conanfile.py``, generators, ConanCenter
   * - :doc:`cpp_memory_interactive`
     - Interactive C++ memory bugs -- dangling references, heap leaks, use-after-free, double-free
     - stack frames, heap allocation, raw pointers, undefined behavior
   * - :doc:`cpp_raii_smart_pointers_interactive`
     - Interactive RAII and smart pointers -- unique_ptr ownership/move, shared_ptr refcounting and the circular-reference leak
     - RAII, unique_ptr, shared_ptr, weak_ptr, reference counting
   * - :doc:`cpp_smart_pointers_interactive`
     - Play With It: unique_ptr, shared_ptr, and weak_ptr side by side -- the strong-count/weak-count control block, lock(), and why weak_ptr never keeps an object alive
     - unique_ptr, shared_ptr, weak_ptr, control block, lock(), expired()
   * - :doc:`cpp_move_semantics_interactive`
     - Interactive move semantics -- copy vs move construction cost, made countable
     - move constructor, std::move, moved-from state, noexcept
   * - :doc:`cpp_ranges_interactive`
     - Play With It: build a std::views pipeline, watch it stay lazy, and see order and short-circuiting change results
     - views::filter, views::transform, views::take, laziness, views vs actions
   * - :doc:`cpp_vtable_interactive`
     - Interactive virtual dispatch and vtables -- plus the classic non-virtual-destructor leak
     - vtable, vptr, dynamic dispatch, virtual destructor
   * - :doc:`cpp_exception_unwind_interactive`
     - Interactive exception unwinding -- RAII cleanup during unwind, and why a destructor must never throw
     - stack unwinding, RAII, std::terminate, noexcept
   * - :doc:`cpp_singleton_interactive`
     - Play With It: C++11 thread-safe static init vs. a naive unsynchronized race
     - magic statics, double-checked locking, function-local static
   * - :doc:`cpp_command_interactive`
     - Play With It: undo/redo built from commands carrying their own inverse
     - Command pattern, undo/redo stack, std::function, lambdas
   * - :doc:`cpp_observer_interactive`
     - Play With It: a real heap-use-after-free when an observer is destroyed without unsubscribing, and the weak_ptr fix
     - Observer pattern, weak_ptr, lock(), dangling pointer
   * - :doc:`cpp_strategy_interactive`
     - Play With It: swap pricing algorithms at runtime on the same cart, and see what adding a new one actually costs vs. an if/else chain
     - Strategy pattern, open/closed principle, polymorphism
   * - :doc:`cpp_decorator_interactive`
     - Play With It: real gzip + real AES-GCM, wrapped in two different orders, on the same data
     - Decorator pattern, CompressionStream, SubtleCrypto, composability
   * - :doc:`cpp_futures_promises_interactive`
     - Play With It: a real discrete-time model of std::async -- get() blocking/invalidation, launch policies, and the destructor-blocks and deferred-never-runs gotchas
     - std::future, std::promise, std::async, launch::async, launch::deferred
   * - :doc:`cpp_scoped_lock_interactive`
     - Play With It: the identical opposite-order two-mutex deadlock setup run through naive lock_guard (deadlocks) and std::scoped_lock (doesn't) side by side
     - std::thread, lock_guard, scoped_lock, deadlock, try_lock
   * - :doc:`cpp_coroutines_interactive`
     - Play With It: real JS generators standing in for C++20 coroutines -- lazy co_yield production, and co_await suspending without blocking sibling tasks
     - co_await, co_yield, co_return, promise_type, cooperative scheduling

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
   * - :doc:`py_itertools_interactive`
     - Play With It: real groupby/tee/count/cycle, verified against actual CPython output -- groupby's consecutive-only grouping, tee's buffer growing and shrinking live
     - groupby, tee, count, cycle, enumerate, lazy iterator combinators
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
