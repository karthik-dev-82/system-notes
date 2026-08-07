
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
| 🎮 **[Network Interfaces (Interactive)](docs/source/network_interfaces_interactive.rst)** | Interactive bridge, TUN/TAP, and VLAN demos -- MAC learning, Layer 2 vs Layer 3 framing, 802.1Q isolation | MAC learning table, TUN/TAP, 802.1Q tagging, VLAN isolation |
| 🌐 **[Network Interfaces](docs/source/network_interfaces.rst)** | Linux network interfaces, explained with analogies & diagrams | `eth0`, `lo`, `veth`, `docker0`, VLANs, TUN/TAP, NAT |
| 🎮 **[TCP vs UDP (Interactive)](docs/source/tcp_udp_interactive.rst)** | Interactive TCP vs. UDP packet delivery -- play with loss and see the difference | handshake, retransmission, ordering, best-effort delivery |
| 🎮 **[TCP Congestion Control (Interactive)](docs/source/tcp_congestion_control_interactive.rst)** | Interactive TCP congestion control -- drive the cwnd sawtooth yourself | slow start, congestion avoidance, fast retransmit, timeout, ssthresh |
| 🐳 **[Docker Dev Environment](docs/source/docker_dev_environment.rst)** | How the `development` repo's Docker dev container is built | `Dockerfile`, `devcontainer.json`, `docker-compose.yml` |
| 🔌 **[Linux Devices](docs/source/linux_devices.rst)** | Block/char/network/terminal/pseudo devices, and USB layering | `/dev`, `lsblk`, `ttyACM`/`ttyUSB`, `udevadm`, PTYs |
| 🎮 **[Linux Filesystem Basics (Interactive)](docs/source/linux_fs_basics_interactive.rst)** | Interactive inodes/links and mounting/VFS -- the foundation OverlayFS builds on | inodes, hard links, symlinks, mount points, VFS |
| 🎮 **[OverlayFS (Interactive)](docs/source/overlayfs_interactive.rst)** | Interactive OverlayFS -- read/write/delete across layers, watch copy-up and whiteouts | lowerdir, upperdir, merged view, copy-up, whiteouts |
| 🎮 **[Process Address Space (Interactive)](docs/source/process_memory_layout_interactive.rst)** | Interactive process address space -- click code to see where it lands, then watch ASLR reshuffle it | text/data/bss/heap/mmap/stack segments, ASLR |
| 🎮 **[VMAs & Page Tables (Interactive)](docs/source/vma_paging_interactive.rst)** | Interactive VMAs and page tables -- grow the heap for free, then watch a real page fault get resolved | VMAs, page tables, page faults, lazy allocation |
| 🎮 **[Latency Numbers (Interactive)](docs/source/latency_numbers_interactive.rst)** | Interactive latency ladder -- 2012 vs. 2024 hardware, plus a human-timescale rescaling of every hop | CPU cache, RAM, SSD/NVMe, datacenter RTT, cross-continent RTT |
| 🎮 **[Page Cache (Interactive)](docs/source/page_cache_interactive.rst)** | Interactive page cache -- two processes share one cache, mmap() skips the copy, crash before fsync() and lose it | page cache, mmap, fsync, write-back, cross-process sharing |
| 🎮 **[Packet Journey (Interactive)](docs/source/docker_packet_journey_interactive.rst)** | Interactive packet journey -- container, veth, docker0, netfilter, and back | MASQUERADE, DNAT, PREROUTING/POSTROUTING, conntrack |
| 🧠 **[Kernel Networking, Docker & OverlayFS](docs/source/kernel_networking_docker_internals.rst)** | Kernel networking stack, Docker internals, iptables, OverlayFS | netfilter, namespaces, cgroups, veth, DNAT/MASQUERADE, overlay2 |
| 📡 **[LIDAR & SLAM](docs/source/lidar_slam.rst)** | LIDAR and SLAM for navigation where GPS doesn't work | point clouds, localization, mapping, autonomous vehicles |
| 🎮 **[SSH Handshake (Interactive)](docs/source/ssh_secure_shell_interactive.rst)** | Interactive SSH handshake -- a real toy-scale Diffie-Hellman exchange, host-key MITM detection, and both auth methods | Diffie-Hellman, host key fingerprints, password vs. public-key auth |
| 🔐 **[SSH: Your Secret Internet Tunnel](docs/source/ssh_secure_shell.rst)** | How the SSH handshake, encryption, and key auth actually work | key exchange, host keys, password vs. key auth, tunneling |
| 🎮 **[DNS Resolution (Interactive)](docs/source/dns_resolution_interactive.rst)** | Interactive DNS resolver -- walk root/TLD/authoritative, then watch layered TTL caching and CNAME-following in action | recursive resolver, referral chain, TTL caching, CNAME |
| 🎮 **[TLS Certificate Chain (Interactive)](docs/source/tls_cert_chain_interactive.rst)** | Interactive TLS certificate chain -- real ECDSA signatures, four independent trust checks, break each one separately | certificate chain, root/intermediate/leaf, trust store, hostname verification |
| 🎮 **[UTF-8 & Unicode (Interactive)](docs/source/utf8_encoding_interactive.rst)** | Interactive UTF-8 encode/decode -- step through the real bit-slicing byte by byte, then run it backward | code points, byte-length ranges, bit slicing, self-sync/resync |
| 🔤 **[Unicode and UTF-8 Encoding](docs/source/unicode_utf8_encoding.rst)** | How Unicode code points and UTF-8's variable-length encoding work | code points, planes, UTF-8 bit patterns, multi-byte characters |
| 🔠 **[Base64 Encoding](docs/source/base64_encoding.rst)** | Base64, ASCII, URL encoding, and hex, explained with analogies | Base64 alphabet, percent-encoding, MIME attachments, hex colors |
| 🗄️ **[Databases: PostgreSQL, MongoDB & Redis](docs/source/databases_postgresql_mongodb_redis.rst)** | PostgreSQL, MongoDB, and Redis compared with a kitchen analogy | joins, documents, key-value, ACID, indexes, sorted sets |
| 🖼️ **[Image Formats](docs/source/image_formats.rst)** | SVG vs. PNG vs. JPEG, and when to use each | vector vs. raster, transparency, lossy/lossless compression |
| 🎮 **[Threads & Sync (Interactive)](docs/source/threads_sync_interactive.rst)** | Interactive threads & synchronization -- step through race conditions and deadlock yourself | mutex, semaphore, condition variable, race condition, deadlock |
| 🧵 **[Threads, Processes & Synchronization](docs/source/threads_processes_synchronization.rst)** | Threads, processes, and synchronization primitives in C++ | mutex, semaphore, condition variable, deadlock, race conditions |
| 🔐 **[Complete Guide to OpenSSL](docs/source/openssl_guide.rst)** | Encryption, hashing, and certificates, plus practical OpenSSL commands | symmetric/asymmetric crypto, TLS, x509 certs, `openssl` CLI |
| 🎮 **[Live /proc Explorer (Interactive)](docs/source/proc_filesystem_interactive.rst)** | Live /proc explorer -- click any path and watch it get generated on demand | /proc/PID, meminfo, loadavg, uptime, process lifecycle |
| 🪟 **[The /proc Filesystem](docs/source/proc_filesystem.rst)** | The virtual /proc filesystem -- process info, system stats, tuning knobs | `/proc/PID`, `/proc/cpuinfo`, `/proc/meminfo`, `/proc/sys` |
| 🎮 **[Hash Load Balancer (Interactive)](docs/source/hash_load_balancer_interactive.rst)** | Interactive hash load balancer -- 10 clients, 3 servers, naive modulo hashing, and what a flow actually is | flow 5-tuple, hash % N, connection vs. user stickiness |
| 🎮 **[Consistent Hashing (Interactive)](docs/source/consistent_hashing_interactive.rst)** | Interactive consistent hashing ring -- add/remove servers and watch what actually moves | hash ring, virtual nodes, reshuffling, load balancing |
| ⚖️ **[Hash Load Balancer](docs/source/hash_load_balancer.rst)** | Hash-based load balancing, sticky sessions, and consistent hashing | modulo hashing, session affinity, CDN routing, reshuffling problem |
| 🎮 **[Bitcoin Mining (Interactive)](docs/source/bitcoin_mining_interactive.rst)** | Interactive Bitcoin mining -- real SHA-256 in your browser, tamper with a block and watch the cascade | proof of work, SHA-256, block hashing, 51% attack cost |
| ₿ **[Bitcoin, Distributed Ledgers & Zcash](docs/source/bitcoin_distributed_ledgers_zcash.rst)** | Bitcoin, distributed ledgers, and Zcash explained with analogies | blockchain, proof of work, mining, zero-knowledge proofs |

### C++ Notes

| Reference Guide | Primary Focus | Key Utilities Covered |
| --- | --- | --- |
| 📝 **[spdlog Sinks & Architecture](docs/source/spdlog_sinks_architecture.rst)** | spdlog logging architecture, sinks, and log levels | `spdlog`, sinks, formatters, log levels, rotation |
| 📦 **[Conan Package Manager Guide](docs/source/conan_package_manager.rst)** | Conan package manager for C++ -- conanfile structure, generators, and commands | `conanfile.txt`, `conanfile.py`, generators, ConanCenter |
| 🎮 **[C++ Memory (Interactive)](docs/source/cpp_memory_interactive.rst)** | Interactive C++ memory bugs -- dangling references, heap leaks, use-after-free, double-free | stack frames, heap allocation, raw pointers, undefined behavior |
| 🎮 **[C++ RAII & Smart Pointers (Interactive)](docs/source/cpp_raii_smart_pointers_interactive.rst)** | Interactive RAII and smart pointers -- unique_ptr ownership/move, shared_ptr refcounting and the circular-reference leak | RAII, unique_ptr, shared_ptr, weak_ptr, reference counting |
| 🎮 **[C++ Move Semantics (Interactive)](docs/source/cpp_move_semantics_interactive.rst)** | Interactive move semantics -- copy vs move construction cost, made countable | move constructor, std::move, moved-from state, noexcept |
| 🎮 **[C++ Virtual Functions & vtables (Interactive)](docs/source/cpp_vtable_interactive.rst)** | Interactive virtual dispatch and vtables -- plus the classic non-virtual-destructor leak | vtable, vptr, dynamic dispatch, virtual destructor |
| 🎮 **[C++ Exception Unwinding (Interactive)](docs/source/cpp_exception_unwind_interactive.rst)** | Interactive exception unwinding -- RAII cleanup during unwind, and why a destructor must never throw | stack unwinding, RAII, std::terminate, noexcept |

### Python Notes

| Reference Guide | Primary Focus | Key Utilities Covered |
| --- | --- | --- |
| 🎮 **[Python Sequences (Interactive)](docs/source/python_sequences_interactive.rst)** | Interactive Python list/stack/queue/deque -- CPython's real growth formula and probing, verified against source | dynamic arrays, amortized O(1), LIFO/FIFO, deque blocks |
| 🎮 **[Python Hashing (Interactive)](docs/source/python_hashing_interactive.rst)** | Interactive Python dict/set -- real CPython collision probing, resize thresholds, and set algebra | hash tables, open addressing, insertion order, union/intersection/difference |
| 🎮 **[Python Generators (Interactive)](docs/source/python_generators_interactive.rst)** | Interactive generators -- step through next()/send()/throw()/close(), then measure laziness against a list comprehension | yield, suspended frames, StopIteration, two-way communication |
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
        ├── network_interfaces_interactive.rst
        ├── network_interfaces.rst
        ├── tcp_udp_interactive.rst
        ├── tcp_congestion_control_interactive.rst
        ├── docker_dev_environment.rst
        ├── linux_devices.rst
        ├── linux_fs_basics_interactive.rst
        ├── overlayfs_interactive.rst
        ├── process_memory_layout_interactive.rst
        ├── vma_paging_interactive.rst
        ├── latency_numbers_interactive.rst
        ├── page_cache_interactive.rst
        ├── docker_packet_journey_interactive.rst
        ├── kernel_networking_docker_internals.rst
        ├── lidar_slam.rst
        ├── ssh_secure_shell_interactive.rst
        ├── ssh_secure_shell.rst
        ├── dns_resolution_interactive.rst
        ├── tls_cert_chain_interactive.rst
        ├── utf8_encoding_interactive.rst
        ├── unicode_utf8_encoding.rst
        ├── base64_encoding.rst
        ├── databases_postgresql_mongodb_redis.rst
        ├── image_formats.rst
        ├── threads_sync_interactive.rst
        ├── threads_processes_synchronization.rst
        ├── openssl_guide.rst
        ├── proc_filesystem_interactive.rst
        ├── proc_filesystem.rst
        ├── hash_load_balancer_interactive.rst
        ├── consistent_hashing_interactive.rst
        ├── hash_load_balancer.rst
        ├── bitcoin_mining_interactive.rst
        ├── bitcoin_distributed_ledgers_zcash.rst
        ├── spdlog_sinks_architecture.rst
        ├── conan_package_manager.rst
        ├── cpp_memory_interactive.rst
        ├── cpp_raii_smart_pointers_interactive.rst
        ├── cpp_move_semantics_interactive.rst
        ├── cpp_vtable_interactive.rst
        ├── cpp_exception_unwind_interactive.rst
        ├── python_sequences_interactive.rst
        ├── python_hashing_interactive.rst
        ├── python_generators_interactive.rst
        ├── python_concurrency_interactive.rst
        ├── python_asyncio_gather_interactive.rst
        └── _static/
            ├── custom.css
            ├── tcp_udp_widget.html
            ├── tcp_congestion_widget.html
            ├── docker_packet_journey_widget.html
            ├── threads_sync_widget.html
            ├── hash_load_balancer_widget.html
            ├── consistent_hash_widget.html
            ├── proc_explorer_widget.html
            ├── linux_fs_basics_widget.html
            ├── overlayfs_widget.html
            ├── process_memory_layout_widget.html
            ├── vma_paging_widget.html
            ├── latency_numbers_widget.html
            ├── page_cache_widget.html
            ├── cpp_memory_widget.html
            ├── cpp_unique_ptr_widget.html
            ├── cpp_shared_ptr_widget.html
            ├── cpp_move_semantics_widget.html
            ├── cpp_vtable_widget.html
            ├── cpp_exception_unwind_widget.html
            ├── py_list_widget.html
            ├── py_stack_widget.html
            ├── py_queue_widget.html
            ├── py_hashing_widget.html
            ├── py_generator_stepper_widget.html
            ├── py_generator_laziness_widget.html
            ├── net_bridge_widget.html
            ├── net_tuntap_widget.html
            ├── net_vlan_widget.html
            ├── ssh_handshake_widget.html
            ├── dns_resolution_widget.html
            ├── tls_cert_chain_widget.html
            ├── utf8_encoding_widget.html
            ├── concurrency_models_widget.html
            ├── asyncio_gather_widget.html
            └── bitcoin_mining_widget.html

```

Docs are built and published to GitHub Pages automatically by
[`.github/workflows/docs.yml`](.github/workflows/docs.yml) on every push to
`main`.
