
# 🛠️ System Notes

A curated collection of reference guides and revision notes -- Linux internals, networking, containers, and whatever else is worth writing down and coming back to.

📖 **Full rendered docs (with PlantUML diagrams): https://karthik-dev-82.github.io/system-notes/**

---

## 📚 Quick Navigation Index

### System Notes

| Reference Guide | Primary Focus | Key Utilities Covered |
| --- | --- | --- |
| 🖥️ **[.bashrc Reference](docs/source/bashrc_reference.rst)** | Shell setup, aliases & functions | `.bashrc`, aliases, `__setprompt`, `ssh-agent` |
| 📊 **[System Monitoring Commands](docs/source/system_monitoring_commands.rst)** | Performance, Diagnostics & Resource Analysis | `htop`, `vmstat`, `iotop`, `iostat`, `ss`, `pidstat` |
| ⚡ **[Developer Commands](docs/source/developer_commands.rst)** | Daily Engineering Workflows & Tooling | `docker`, `git`, `rsync`, `aria2c`, `find`, `grep` |
| 🎮 **[Poe the Poet (Interactive)](docs/source/poe_the_poet_interactive.rst)** | A real Poe the Poet task-resolution simulator -- task types, arg passthrough, sequence fail-fast, hidden tasks | poe, pyproject.toml, cmd/shell/script/expr, sequence, parallel, switch |
| 🎮 **[Network Interfaces (Interactive)](docs/source/network_interfaces_interactive.rst)** | Interactive bridge, TUN/TAP, and VLAN demos -- MAC learning, Layer 2 vs Layer 3 framing, 802.1Q isolation | MAC learning table, TUN/TAP, 802.1Q tagging, VLAN isolation |
| 🌐 **[Network Interfaces](docs/source/network_interfaces.rst)** | Linux network interfaces, explained with analogies & diagrams | `eth0`, `lo`, `veth`, `docker0`, VLANs, TUN/TAP, NAT |
| 🎮 **[TCP vs UDP (Interactive)](docs/source/tcp_udp_interactive.rst)** | Interactive TCP vs. UDP packet delivery -- play with loss and see the difference | handshake, retransmission, ordering, best-effort delivery |
| 🎮 **[TCP Congestion Control (Interactive)](docs/source/tcp_congestion_control_interactive.rst)** | Interactive TCP congestion control -- drive the cwnd sawtooth yourself | slow start, congestion avoidance, fast retransmit, timeout, ssthresh |
| 🐳 **[Docker Dev Environment](docs/source/docker_dev_environment.rst)** | How the `development` repo's Docker dev container is built | `Dockerfile`, `devcontainer.json`, `docker-compose.yml` |
| 🔌 **[Linux Devices](docs/source/linux_devices.rst)** | Block/char/network/terminal/pseudo devices, and USB layering | `/dev`, `lsblk`, `ttyACM`/`ttyUSB`, `udevadm`, PTYs |
| 🎮 **[USB Device Binding (Interactive)](docs/source/usb_binding_interactive.rst)** | Interactive USB driver binding -- class vs. vendor-chip matching, live minor-number allocation | `cdc_acm`, `ftdi_sio`/`cp210x`/`ch341`/`pl2303`, `/dev/ttyUSB*` |
| 🎮 **[Terminal Sessions (Interactive)](docs/source/tty_sessions_interactive.rst)** | Interactive PTY/console/serial session allocation -- shared pts pool, console switching, `who` | `/dev/pts/N`, `tty1`-`tty6`, `ttyS0`, `who` |
| 🎮 **[Linux Filesystem Basics (Interactive)](docs/source/linux_fs_basics_interactive.rst)** | Interactive inodes/links and mounting/VFS -- the foundation OverlayFS builds on | inodes, hard links, symlinks, mount points, VFS |
| 🎮 **[OverlayFS (Interactive)](docs/source/overlayfs_interactive.rst)** | Interactive OverlayFS -- read/write/delete across layers, watch copy-up and whiteouts | lowerdir, upperdir, merged view, copy-up, whiteouts |
| 🎮 **[Process Address Space (Interactive)](docs/source/process_memory_layout_interactive.rst)** | Interactive process address space -- click code to see where it lands, then watch ASLR reshuffle it | text/data/bss/heap/mmap/stack segments, ASLR |
| 🎮 **[VMAs & Page Tables (Interactive)](docs/source/vma_paging_interactive.rst)** | Interactive VMAs and page tables -- grow the heap for free, then watch a real page fault get resolved | VMAs, page tables, page faults, lazy allocation |
| 🎮 **[Copy-on-Write After fork() (Interactive)](docs/source/cow_fork_interactive.rst)** | Interactive copy-on-write -- fork() a process for free, then watch a write fault either reuse a frame or copy it | fork(), copy-on-write, page faults, reference counting |
| 🎮 **[Latency Numbers (Interactive)](docs/source/latency_numbers_interactive.rst)** | Interactive latency ladder -- 2012 vs. 2024 hardware, plus a human-timescale rescaling of every hop | CPU cache, RAM, SSD/NVMe, datacenter RTT, cross-continent RTT |
| 🎮 **[Page Cache (Interactive)](docs/source/page_cache_interactive.rst)** | Interactive page cache -- two processes share one cache, mmap() skips the copy, crash before fsync() and lose it | page cache, mmap, fsync, write-back, cross-process sharing |
| 🧩 **[Beyond the Bridges: Processor Architecture](docs/source/processor_architecture.rst)** | Where memory and I/O connect in modern Intel, AMD, and ARM chips, and why northbridge/southbridge is now historical | SoC tile, PCH, DMI, CCD/IOD, Infinity Fabric, unified memory, CMN mesh |
| 🧩 **[The CUDA Moat](docs/source/cuda_gpu_architecture.rst)** | Why GPUs suit neural-net math, and why CUDA specifically (not GPUs generically) is NVIDIA's real moat | SM, CUDA/Tensor cores, HBM, CUDA vs. ROCm/OpenCL, NVLink, NVSwitch |
| 🎮 **[Packet Journey (Interactive)](docs/source/docker_packet_journey_interactive.rst)** | Interactive packet journey -- container, veth, docker0, netfilter, and back | MASQUERADE, DNAT, PREROUTING/POSTROUTING, conntrack |
| 🧠 **[Kernel Networking, Docker & OverlayFS](docs/source/kernel_networking_docker_internals.rst)** | Kernel networking stack, Docker internals, iptables, OverlayFS | netfilter, namespaces, cgroups, veth, DNAT/MASQUERADE, overlay2 |
| 📡 **[LIDAR & SLAM](docs/source/lidar_slam.rst)** | LIDAR and SLAM for navigation where GPS doesn't work | point clouds, localization, mapping, autonomous vehicles |
| 🎮 **[LIDAR Point Clouds (Interactive)](docs/source/lidar_pointcloud_interactive.rst)** | Interactive LIDAR ray-casting -- real ray-vs-wall geometry, real round-trip time-of-flight math | ray casting, point cloud, terrestrial vs. mobile scanning |
| 🎮 **[SLAM Scan Matching (Interactive)](docs/source/slam_scan_matching_interactive.rst)** | Interactive SLAM -- odometry drift vs. real ICP scan-matching correction, side by side, with a live 100-trial statistic | ICP, point-to-point matching, pose estimation, dead reckoning |
| 🎮 **[SSH Handshake (Interactive)](docs/source/ssh_secure_shell_interactive.rst)** | Interactive SSH handshake -- a real toy-scale Diffie-Hellman exchange, host-key MITM detection, and both auth methods | Diffie-Hellman, host key fingerprints, password vs. public-key auth |
| 🔐 **[SSH: Your Secret Internet Tunnel](docs/source/ssh_secure_shell.rst)** | How the SSH handshake, encryption, and key auth actually work | key exchange, host keys, password vs. key auth, tunneling |
| 🎮 **[DNS Resolution (Interactive)](docs/source/dns_resolution_interactive.rst)** | Interactive DNS resolver -- walk root/TLD/authoritative, then watch layered TTL caching and CNAME-following in action | recursive resolver, referral chain, TTL caching, CNAME |
| 🎮 **[REST APIs (Tutorial + Interactive)](docs/source/rest_api_interactive.rst)** | Tutorial + Play With It: a real in-browser REST API -- resources, HTTP methods, status codes, and genuine idempotency behavior | GET/POST/PUT/PATCH/DELETE, safe vs. idempotent, status codes, statelessness |
| 🎮 **[REST vs. RPC (Interactive)](docs/source/rest_vs_rpc_interactive.rst)** | Identical flaky-network retry storm hits three handlers side by side, one of them double-charges | idempotency, retry safety, idempotency keys, gRPC/JSON-RPC vs. resource verbs |
| 🎮 **[Long Polling vs. WebSockets (Interactive)](docs/source/long_poll_vs_ws_interactive.rst)** | Same event schedule, live request-count and delivery-latency comparison | server push, request overhead, reconnect-gap latency, persistent connections |
| 🎮 **[TLS Certificate Chain (Interactive)](docs/source/tls_cert_chain_interactive.rst)** | Interactive TLS certificate chain -- real ECDSA signatures, four independent trust checks, break each one separately | certificate chain, root/intermediate/leaf, trust store, hostname verification |
| 🎮 **[UTF-8 & Unicode (Interactive)](docs/source/utf8_encoding_interactive.rst)** | Interactive UTF-8 encode/decode -- step through the real bit-slicing byte by byte, then run it backward | code points, byte-length ranges, bit slicing, self-sync/resync |
| 🔤 **[Unicode and UTF-8 Encoding](docs/source/unicode_utf8_encoding.rst)** | How Unicode code points and UTF-8's variable-length encoding work | code points, planes, UTF-8 bit patterns, multi-byte characters |
| 🔠 **[Base64 Encoding](docs/source/base64_encoding.rst)** | Base64, ASCII, URL encoding, and hex, explained with analogies | Base64 alphabet, percent-encoding, MIME attachments, hex colors |
| 🗄️ **[Databases: PostgreSQL, MongoDB & Redis](docs/source/databases_postgresql_mongodb_redis.rst)** | PostgreSQL, MongoDB, and Redis compared with a kitchen analogy | joins, documents, key-value, ACID, indexes, sorted sets |
| 📋 **[The 20-Country Dataset](docs/source/db_country_dataset.rst)** | The full dataset reused across every database page, in one place | id, iso2, region, population, gdpPerCapita, currency, capital |
| 🎮 **[Index vs. Full Scan (Interactive)](docs/source/db_index_scan_interactive.rst)** | Interactive index vs. full scan -- same 20-country query, run two ways, real cost numbers | indexes, binary search, hash lookup, query planning |
| 🎮 **[Redis Data Structures (Interactive)](docs/source/db_redis_structures_interactive.rst)** | Interactive Redis structures -- hash, sorted set, set, and TTL cache, all on the same country data | hashes, sorted sets, leaderboards, set intersection, TTL/expiry |
| 🎮 **[ACID Transaction Atomicity (Interactive)](docs/source/db_acid_transaction_interactive.rst)** | Interactive ACID atomicity -- insert a country and capital together, force a mid-way failure, watch rollback vs. an orphaned row | transactions, atomicity, rollback, foreign keys, referential integrity |
| 🎮 **[Composite Indexes (Interactive)](docs/source/db_composite_index_interactive.rst)** | Interactive composite indexes and the leftmost prefix rule -- which columns actually narrow a search vs. fall back to row-by-row rechecking | composite index, leftmost prefix, covering index, query planner |
| 🎮 **[Apache Cassandra (Interactive)](docs/source/cassandra_interactive.rst)** | The real N/W/R quorum-overlap guarantee run as a live fuzz test, plus a real memtable/SSTable/compaction LSM-tree you can write, read, and compact yourself | tunable consistency, quorum, hinted handoff, read repair, LSM-tree, memtable, SSTable, compaction, tombstone |
| 🖼️ **[Image Formats](docs/source/image_formats.rst)** | SVG vs. PNG vs. JPEG, and when to use each | vector vs. raster, transparency, lossy/lossless compression |
| 🎮 **[8b/10b Line Encoding (Interactive)](docs/source/8b10b_encoding_interactive.rst)** | Interactive 8b/10b-style line coding -- send a byte, watch running disparity keep the wire from ever going flat | running disparity, DC balance, clock recovery, sub-block encoding |
| 🎮 **[CAN Bus Arbitration (Interactive)](docs/source/can_arbitration_interactive.rst)** | Interactive CAN bus arbitration -- pick contending nodes, watch the real bit-by-bit priority race | dominant/recessive bits, wired-AND, bitwise arbitration, priority |
| 🎮 **[Watchdog Timer (Interactive)](docs/source/watchdog_timer_interactive.rst)** | Interactive watchdog timer -- pet it to stay alive, freeze the program and watch it fire, switch to a real window watchdog's too-early-pet fault | classic vs. window watchdog, petting, timeout, forced reset |
| 🎮 **[GStreamer Pipelines (Interactive)](docs/source/gstreamer_pipeline_interactive.rst)** | Interactive GStreamer pipeline builder -- chain elements together, real caps negotiation, decodebin's dynamic pad | pads, caps negotiation, decodebin, pipeline states |
| 🎮 **[Threads & Sync (Interactive)](docs/source/threads_sync_interactive.rst)** | Interactive threads & synchronization -- step through race conditions and deadlock yourself | mutex, semaphore, condition variable, race condition, deadlock |
| 🧵 **[Threads, Processes & Synchronization](docs/source/threads_processes_synchronization.rst)** | Threads, processes, and synchronization primitives in C++ | mutex, semaphore, condition variable, deadlock, race conditions |
| 🔐 **[Complete Guide to OpenSSL](docs/source/openssl_guide.rst)** | Encryption, hashing, and certificates, plus practical OpenSSL commands | symmetric/asymmetric crypto, TLS, x509 certs, `openssl` CLI |
| 🎮 **[Live /proc Explorer (Interactive)](docs/source/proc_filesystem_interactive.rst)** | Live /proc explorer -- click any path and watch it get generated on demand | /proc/PID, meminfo, loadavg, uptime, process lifecycle |
| 🪟 **[The /proc Filesystem](docs/source/proc_filesystem.rst)** | The virtual /proc filesystem -- process info, system stats, tuning knobs | `/proc/PID`, `/proc/cpuinfo`, `/proc/meminfo`, `/proc/sys` |
| 🎮 **[Hash Load Balancer (Interactive)](docs/source/hash_load_balancer_interactive.rst)** | Interactive hash load balancer -- 10 clients, 3 servers, naive modulo hashing, and what a flow actually is | flow 5-tuple, hash % N, connection vs. user stickiness |
| 🎮 **[Consistent Hashing (Interactive)](docs/source/consistent_hashing_interactive.rst)** | Interactive consistent hashing ring -- add/remove servers and watch what actually moves | hash ring, virtual nodes, reshuffling, load balancing |
| ⚖️ **[Hash Load Balancer](docs/source/hash_load_balancer.rst)** | Hash-based load balancing, sticky sessions, and consistent hashing | modulo hashing, session affinity, CDN routing, reshuffling problem |
| 🎮 **[Apache Kafka (Interactive)](docs/source/kafka_topic_interactive.rst)** | Interactive Kafka topic -- send keyed readings, watch partition routing, poll with consumer groups, rebalance live | partitions, consumer groups, offsets, rebalancing, replay |
| 🎮 **[Idempotency & Delivery Semantics (Interactive)](docs/source/delivery_semantics_interactive.rst)** | At-most-once/at-least-once/idempotent delivery run side by side on the same flaky pipeline -- deliveries vs. effects tracked as two separate numbers | idempotency key, at-least-once, exactly-once, effectively-once, Kafka offset commit timing |
| 🎮 **[Priority Inversion (Interactive)](docs/source/priority_inversion_interactive.rst)** | Interactive priority inversion -- the bug that nearly stranded Mars Pathfinder, and the priority-inheritance fix, side by side | preemption, mutex, priority inheritance, real-time scheduling |
| 🧩 **[Architectural Patterns](docs/source/architectural_patterns.rst)** | The five shapes a system's components can be arranged in -- client-server, microservices, serverless, event-driven, peer-to-peer, with a worked example for each | client-server, microservices, serverless, cold start, event-driven, peer-to-peer |
| 🎮 **[CAP Theorem (Interactive)](docs/source/cap_theorem_interactive.rst)** | Partition a 2-node store and choose Consistency or Availability, then see why quorum-based systems don't lose everyone | CAP theorem, partition tolerance, AP vs. CP, quorum, last-write-wins, strong vs. eventual consistency |
| 🎮 **[Rate Limiting (Interactive)](docs/source/rate_limiting_interactive.rst)** | 5 rate-limiting algorithms fired at the same burst -- watch them disagree at the exact same moment | token bucket, leaky bucket, fixed window, sliding window log, sliding window counter |
| 🎮 **[Bloom Filters (Interactive)](docs/source/bloom_filter_interactive.rst)** | A real bit array and real hash functions -- add words, test words, measure false positives against the textbook formula | bloom filter, false positive rate, double hashing, FNV-1a |
| 🎮 **[Normalization vs. Denormalization (Interactive)](docs/source/normalization_denormalization_interactive.rst)** | The same data two ways, real PostgreSQL EXPLAIN costs, and a real reproduced update anomaly | normalization, denormalization, joins, update anomaly, EXPLAIN ANALYZE |
| 🎮 **[Database Sharding (Interactive)](docs/source/database_sharding_interactive.rst)** | Hash-based vs. range-based sharding on the same sequential-key workload -- the real hot-shard problem and two rebalancing operations | sharding, hash sharding, range sharding, hot shard, rebalancing, scatter-gather |
| 🎮 **[Cache Strategies (Interactive)](docs/source/cache_strategies_interactive.rst)** | cache-aside/read-through/write-through/write-back (crash the cache and see what's actually lost), plus LRU/FIFO/LFU/TTL side by side | cache-aside, read-through, write-through, write-back, LRU, FIFO, LFU, TTL |
| 🎮 **[Raft Consensus (Interactive)](docs/source/raft_consensus_interactive.rst)** | Real Raft leader election (randomized timeouts, forced split votes, quorum loss) and log replication (AppendEntries, majority commit) | Raft, leader election, terms, log replication, AppendEntries, quorum, consensus |
| 🎮 **[Proxy Servers (Interactive)](docs/source/proxy_servers_interactive.rst)** | The real X-Forwarded-For spoofing bug (naive vs. trusted-hop-count parsing, fuzz-verified) and what TLS termination actually does and doesn't imply | forward proxy, reverse proxy, X-Forwarded-For, TLS termination, trusted proxies |
| 🎮 **[CDN (Interactive)](docs/source/cdn_interactive.rst)** | The real thundering-herd/request-coalescing mechanism on a cold edge POP, and cache-key composition's two opposite failure modes, fuzz-verified | CDN, edge POP, thundering herd, request coalescing, cache key, origin pull |
| 🎮 **[Resilience Patterns (Interactive)](docs/source/resilience_patterns_interactive.rst)** | A real closed/open/half-open circuit breaker across 8 service instances (fixed vs. jittered reset timeouts), plus bulkhead pool isolation | circuit breaker, half-open probe, jittered backoff, thundering herd, bulkhead, noisy neighbor |
| 🧩 **[URL Shortener Case Study (Interactive)](docs/source/url_shortener_interactive.rst)** | A worked "design a URL shortener" interview question end to end -- capacity math, real base62/hash short-code generation with live collision handling | short-code generation, base62, capacity estimation, system design synthesis |
| 🎮 **[Bitcoin Mining (Interactive)](docs/source/bitcoin_mining_interactive.rst)** | Interactive Bitcoin mining -- real SHA-256 in your browser, tamper with a block and watch the cascade | proof of work, SHA-256, block hashing, 51% attack cost |
| ₿ **[Bitcoin, Distributed Ledgers & Zcash](docs/source/bitcoin_distributed_ledgers_zcash.rst)** | Bitcoin, distributed ledgers, and Zcash explained with analogies | blockchain, proof of work, mining, zero-knowledge proofs |

### C++ Notes

| Reference Guide | Primary Focus | Key Utilities Covered |
| --- | --- | --- |
| 📝 **[spdlog Sinks & Architecture](docs/source/spdlog_sinks_architecture.rst)** | spdlog logging architecture, sinks, and log levels | `spdlog`, sinks, formatters, log levels, rotation |
| 🎮 **[spdlog Level Cascade (Interactive)](docs/source/spdlog_sinks_interactive.rst)** | Interactive spdlog level filtering -- logger gate first, then each sink's own gate independently | `set_level`, `trace`-`critical`/`off`, per-sink pattern |
| 📦 **[Conan Package Manager Guide](docs/source/conan_package_manager.rst)** | Conan package manager for C++ -- conanfile structure, generators, and commands | `conanfile.txt`, `conanfile.py`, generators, ConanCenter |
| 🎮 **[C++ Memory (Interactive)](docs/source/cpp_memory_interactive.rst)** | Interactive C++ memory bugs -- dangling references, heap leaks, use-after-free, double-free | stack frames, heap allocation, raw pointers, undefined behavior |
| 🎮 **[C++ RAII & Smart Pointers (Interactive)](docs/source/cpp_raii_smart_pointers_interactive.rst)** | Interactive RAII and smart pointers -- unique_ptr ownership/move, shared_ptr refcounting and the circular-reference leak | RAII, unique_ptr, shared_ptr, weak_ptr, reference counting |
| 🎮 **[unique_ptr vs shared_ptr vs weak_ptr (Interactive)](docs/source/cpp_smart_pointers_interactive.rst)** | Play With It: all three ownership models side by side -- the strong-count/weak-count control block, lock(), and why weak_ptr never keeps an object alive | unique_ptr, shared_ptr, weak_ptr, control block, lock(), expired() |
| 🎮 **[C++ Move Semantics (Interactive)](docs/source/cpp_move_semantics_interactive.rst)** | Interactive move semantics -- copy vs move construction cost, made countable | move constructor, std::move, moved-from state, noexcept |
| 🎮 **[C++20 Ranges (Interactive)](docs/source/cpp_ranges_interactive.rst)** | Build a std::views pipeline, watch it stay lazy, and see order and short-circuiting change results | views::filter, views::transform, views::take, laziness, views vs actions |
| 🎮 **[C++ Virtual Functions & vtables (Interactive)](docs/source/cpp_vtable_interactive.rst)** | Interactive virtual dispatch and vtables -- plus the classic non-virtual-destructor leak | vtable, vptr, dynamic dispatch, virtual destructor |
| 🎮 **[C++ Exception Unwinding (Interactive)](docs/source/cpp_exception_unwind_interactive.rst)** | Interactive exception unwinding -- RAII cleanup during unwind, and why a destructor must never throw | stack unwinding, RAII, std::terminate, noexcept |
| 🎮 **[C++ Singleton (Interactive)](docs/source/cpp_singleton_interactive.rst)** | Interactive C++11 thread-safe static init vs. a naive unsynchronized race | magic statics, double-checked locking, function-local static |
| 🎮 **[C++ Command Pattern (Interactive)](docs/source/cpp_command_interactive.rst)** | Interactive undo/redo built from commands carrying their own inverse | Command pattern, undo/redo stack, std::function, lambdas |
| 🎮 **[C++ Observer Pattern (Interactive)](docs/source/cpp_observer_interactive.rst)** | A real heap-use-after-free when an observer is destroyed without unsubscribing, and the weak_ptr fix | Observer pattern, weak_ptr, lock(), dangling pointer |
| 🎮 **[C++ Strategy Pattern (Interactive)](docs/source/cpp_strategy_interactive.rst)** | Swap pricing algorithms at runtime on the same cart, and see what adding a new one actually costs vs. an if/else chain | Strategy pattern, open/closed principle, polymorphism |
| 🎮 **[C++ Decorator Pattern (Interactive)](docs/source/cpp_decorator_interactive.rst)** | Real gzip + real AES-GCM, wrapped in two different orders, on the same data | Decorator pattern, CompressionStream, SubtleCrypto, composability |
| 🎮 **[Futures & Promises (Interactive)](docs/source/cpp_futures_promises_interactive.rst)** | A real discrete-time model of std::async -- get() blocking/invalidation, launch policies, destructor-blocks and deferred-never-runs | std::future, std::promise, std::async, launch::async, launch::deferred |
| 🎮 **[Multithreading: scoped_lock (Interactive)](docs/source/cpp_scoped_lock_interactive.rst)** | The identical opposite-order two-mutex deadlock setup run through lock_guard (deadlocks) and scoped_lock (doesn't) side by side | std::thread, lock_guard, scoped_lock, deadlock, try_lock |
| 🎮 **[C++20 Coroutines (Interactive)](docs/source/cpp_coroutines_interactive.rst)** | Real JS generators standing in for C++20 coroutines -- lazy co_yield production, co_await suspending without blocking siblings | co_await, co_yield, co_return, promise_type, cooperative scheduling |

### Python Notes

| Reference Guide | Primary Focus | Key Utilities Covered |
| --- | --- | --- |
| 🎮 **[Python Sequences (Interactive)](docs/source/python_sequences_interactive.rst)** | Interactive Python list/stack/queue/deque -- CPython's real growth formula and probing, verified against source | dynamic arrays, amortized O(1), LIFO/FIFO, deque blocks |
| 🎮 **[Python Hashing (Interactive)](docs/source/python_hashing_interactive.rst)** | Interactive Python dict/set -- real CPython collision probing, resize thresholds, and set algebra | hash tables, open addressing, insertion order, union/intersection/difference |
| 🎮 **[Python Generators (Interactive)](docs/source/python_generators_interactive.rst)** | Interactive generators -- step through next()/send()/throw()/close(), then measure laziness against a list comprehension | yield, suspended frames, StopIteration, two-way communication |
| 🎮 **[Python itertools (Interactive)](docs/source/py_itertools_interactive.rst)** | Real groupby/tee/count/cycle, verified against actual CPython output -- groupby's consecutive-only grouping, tee's buffer growing and shrinking live | groupby, tee, count, cycle, enumerate, lazy iterator combinators |
| 🎮 **[Python Context Managers (Interactive)](docs/source/python_context_managers_interactive.rst)** | Interactive context managers -- class-based vs @contextmanager side by side, four scenarios, identical outcomes | with statement, __enter__/__exit__, contextlib, exception suppression |
| 🎮 **[Python Coroutines (Interactive)](docs/source/python_coroutines_interactive.rst)** | Interactive toy event loop -- a real hand-built scheduler driving coroutines, plus await delegation chained through nested calls | async/await, event loop, cooperative scheduling, await delegation |
| 🎮 **[Async Generators & Context Managers (Interactive)](docs/source/python_async_generators_interactive.rst)** | Interactive async generators and async context managers -- yield meets await, and __aenter__/__aexit__ take real time without blocking a sibling task | async generator, async for, __aenter__, __aexit__, asynccontextmanager |
| 🎮 **[Multiprocessing vs Threading vs AsyncIO (Interactive)](docs/source/python_concurrency_interactive.rst)** | Interactive multiprocessing vs threading vs asyncio -- the same 3 tasks, 4 scheduling strategies, run side by side | GIL, pre-emptive vs cooperative multitasking, CPU-bound vs I/O-bound |
| 🎮 **[asyncio.gather() (Interactive)](docs/source/python_asyncio_gather_interactive.rst)** | Interactive asyncio.gather() -- 3 real coroutines, real console output, and the argument-order-vs-completion-order guarantee made concrete | async/await, asyncio.gather, asyncio.TaskGroup, coroutine scheduling |

---

## 📊 Overview of Included Guides

### 1. [System Monitoring Commands](docs/source/system_monitoring_commands.rst)

Essential commands for inspecting system health, hunting down bottlenecks, and diagnosing real-time performance issues across CPU, Memory, Disk I/O, and Networking.

* **Process & CPU:** Interactive process monitoring with `htop`/`btop` and per-process CPU profiling using `pidstat`.
* **Memory & Performance:** Virtual memory pressure analysis with `vmstat`.
* **Storage I/O:** Disk bottleneck identification via `iotop` and `iostat`.
* **Network & Bandwidth:** Port inspection and connection tracing using modern `ss` and `iftop`.
* **Pro Workflows:** `tmux` dashboard grids, continuous `watch` loops, and background performance logging with `sar`.

### 2. [Developer Commands](docs/source/developer_commands.rst)

Practical command snippets for container management, repository hygiene, version control, and advanced file manipulation.

* **Docker Management:** Container lifecycle operations, image maintenance, cleanup/pruning commands, networks, and volume persistence.
* **Git Version Control:** Branch creation/renaming (`git switch`), diff inspection, safe/forced cleanups, cherry-picking, interactive rebasing, submodules, and stash management (`git stash push`).
* **File Operations & Transfers:** High-speed multi-connection downloads using `aria2c`, directory mirroring with `rsync`, batch file renaming, SHA-256 duplicate detection, and modern search tools (`ripgrep`, `fd`).

---

## 📂 Repository Layout

```text
system-notes/
├── README.md                          # Master repository index
├── .bashrc                            # The actual dotfile
└── docs/                              # Sphinx + PlantUML documentation source
    ├── requirements.txt
    └── source/
        ├── conf.py
        ├── index.rst
        ├── bashrc_reference.rst
        ├── system_monitoring_commands.rst
        ├── developer_commands.rst
        ├── poe_the_poet_interactive.rst
        ├── network_interfaces_interactive.rst
        ├── network_interfaces.rst
        ├── tcp_udp_interactive.rst
        ├── tcp_congestion_control_interactive.rst
        ├── docker_dev_environment.rst
        ├── linux_devices.rst
        ├── usb_binding_interactive.rst
        ├── tty_sessions_interactive.rst
        ├── linux_fs_basics_interactive.rst
        ├── overlayfs_interactive.rst
        ├── process_memory_layout_interactive.rst
        ├── vma_paging_interactive.rst
        ├── cow_fork_interactive.rst
        ├── latency_numbers_interactive.rst
        ├── page_cache_interactive.rst
        ├── processor_architecture.rst
        ├── cuda_gpu_architecture.rst
        ├── docker_packet_journey_interactive.rst
        ├── kernel_networking_docker_internals.rst
        ├── lidar_slam.rst
        ├── lidar_pointcloud_interactive.rst
        ├── slam_scan_matching_interactive.rst
        ├── ssh_secure_shell_interactive.rst
        ├── ssh_secure_shell.rst
        ├── dns_resolution_interactive.rst
        ├── rest_api_interactive.rst
        ├── rest_vs_rpc_interactive.rst
        ├── long_poll_vs_ws_interactive.rst
        ├── tls_cert_chain_interactive.rst
        ├── utf8_encoding_interactive.rst
        ├── unicode_utf8_encoding.rst
        ├── base64_encoding.rst
        ├── databases_postgresql_mongodb_redis.rst
        ├── db_country_dataset.rst
        ├── db_index_scan_interactive.rst
        ├── db_redis_structures_interactive.rst
        ├── db_acid_transaction_interactive.rst
        ├── db_composite_index_interactive.rst
        ├── cassandra_interactive.rst
        ├── image_formats.rst
        ├── 8b10b_encoding_interactive.rst
        ├── can_arbitration_interactive.rst
        ├── watchdog_timer_interactive.rst
        ├── gstreamer_pipeline_interactive.rst
        ├── threads_sync_interactive.rst
        ├── threads_processes_synchronization.rst
        ├── openssl_guide.rst
        ├── proc_filesystem_interactive.rst
        ├── proc_filesystem.rst
        ├── hash_load_balancer_interactive.rst
        ├── consistent_hashing_interactive.rst
        ├── hash_load_balancer.rst
        ├── kafka_topic_interactive.rst
        ├── delivery_semantics_interactive.rst
        ├── priority_inversion_interactive.rst
        ├── architectural_patterns.rst
        ├── cap_theorem_interactive.rst
        ├── rate_limiting_interactive.rst
        ├── bloom_filter_interactive.rst
        ├── normalization_denormalization_interactive.rst
        ├── database_sharding_interactive.rst
        ├── cache_strategies_interactive.rst
        ├── raft_consensus_interactive.rst
        ├── proxy_servers_interactive.rst
        ├── cdn_interactive.rst
        ├── resilience_patterns_interactive.rst
        ├── url_shortener_interactive.rst
        ├── bitcoin_mining_interactive.rst
        ├── bitcoin_distributed_ledgers_zcash.rst
        ├── spdlog_sinks_architecture.rst
        ├── spdlog_sinks_interactive.rst
        ├── conan_package_manager.rst
        ├── cpp_memory_interactive.rst
        ├── cpp_raii_smart_pointers_interactive.rst
        ├── cpp_smart_pointers_interactive.rst
        ├── cpp_move_semantics_interactive.rst
        ├── cpp_ranges_interactive.rst
        ├── cpp_vtable_interactive.rst
        ├── cpp_exception_unwind_interactive.rst
        ├── cpp_singleton_interactive.rst
        ├── cpp_command_interactive.rst
        ├── cpp_observer_interactive.rst
        ├── cpp_strategy_interactive.rst
        ├── cpp_decorator_interactive.rst
        ├── cpp_futures_promises_interactive.rst
        ├── cpp_scoped_lock_interactive.rst
        ├── cpp_coroutines_interactive.rst
        ├── python_sequences_interactive.rst
        ├── python_hashing_interactive.rst
        ├── python_generators_interactive.rst
        ├── py_itertools_interactive.rst
        ├── python_context_managers_interactive.rst
        ├── python_coroutines_interactive.rst
        ├── python_async_generators_interactive.rst
        ├── python_concurrency_interactive.rst
        ├── python_asyncio_gather_interactive.rst
        └── _static/
            ├── custom.css
            ├── poe_the_poet_widget.html
            ├── usb_binding_widget.html
            ├── tty_sessions_widget.html
            ├── net_bridge_widget.html
            ├── net_tuntap_widget.html
            ├── net_vlan_widget.html
            ├── tcp_udp_widget.html
            ├── tcp_congestion_widget.html
            ├── docker_packet_journey_widget.html
            ├── dns_resolution_widget.html
            ├── rest_api_widget.html
            ├── rest_vs_rpc_widget.html
            ├── long_poll_vs_ws_widget.html
            ├── linux_fs_basics_widget.html
            ├── overlayfs_widget.html
            ├── proc_explorer_widget.html
            ├── process_memory_layout_widget.html
            ├── vma_paging_widget.html
            ├── cow_fork_widget.html
            ├── page_cache_widget.html
            ├── latency_numbers_widget.html
            ├── processor_architecture_widget.html
            ├── cuda_moat_widget.html
            ├── ssh_handshake_widget.html
            ├── tls_cert_chain_widget.html
            ├── bitcoin_mining_widget.html
            ├── utf8_encoding_widget.html
            ├── 8b10b_encoding_widget.html
            ├── can_arbitration_widget.html
            ├── watchdog_timer_widget.html
            ├── gstreamer_pipeline_widget.html
            ├── db_index_scan_widget.html
            ├── db_redis_structures_widget.html
            ├── db_acid_transaction_widget.html
            ├── db_isolation_levels_widget.html
            ├── db_composite_index_widget.html
            ├── cassandra_widget.html
            ├── threads_sync_widget.html
            ├── hash_load_balancer_widget.html
            ├── consistent_hash_widget.html
            ├── kafka_topic_widget.html
            ├── kafka_replication_widget.html
            ├── delivery_semantics_widget.html
            ├── priority_inversion_widget.html
            ├── cap_partition_widget.html
            ├── cap_quorum_widget.html
            ├── rate_limit_widget.html
            ├── bloom_filter_widget.html
            ├── normalization_widget.html
            ├── sharding_widget.html
            ├── cache_strategies_widget.html
            ├── eviction_policies_widget.html
            ├── raft_election_widget.html
            ├── raft_replication_widget.html
            ├── proxy_servers_widget.html
            ├── cdn_widget.html
            ├── resilience_patterns_widget.html
            ├── url_shortener_widget.html
            ├── lidar_pointcloud_widget.html
            ├── slam_scan_matching_widget.html
            ├── spdlog_sinks_widget.html
            ├── cpp_memory_widget.html
            ├── cpp_unique_ptr_widget.html
            ├── cpp_shared_ptr_widget.html
            ├── cpp_smart_pointers_widget.html
            ├── cpp_move_semantics_widget.html
            ├── cpp_ranges_widget.html
            ├── cpp_vtable_widget.html
            ├── cpp_exception_unwind_widget.html
            ├── cpp_singleton_widget.html
            ├── cpp_command_widget.html
            ├── cpp_observer_widget.html
            ├── cpp_strategy_widget.html
            ├── cpp_decorator_widget.html
            ├── cpp_futures_promises_widget.html
            ├── cpp_scoped_lock_widget.html
            ├── cpp_coroutines_widget.html
            ├── py_list_widget.html
            ├── py_stack_widget.html
            ├── py_queue_widget.html
            ├── py_hashing_widget.html
            ├── py_generator_stepper_widget.html
            ├── py_generator_laziness_widget.html
            ├── py_itertools_widget.html
            ├── py_context_manager_widget.html
            ├── py_event_loop_widget.html
            ├── py_await_chain_widget.html
            ├── py_async_generator_widget.html
            ├── py_async_context_manager_widget.html
            ├── concurrency_models_widget.html
            └── asyncio_gather_widget.html

```

Docs are built and published to GitHub Pages automatically by
[`.github/workflows/docs.yml`](.github/workflows/docs.yml) on every push to
`main`.
