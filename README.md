
# 🛠️ System Notes

A curated collection of reference guides and revision notes -- Linux internals, networking, containers, and whatever else is worth writing down and coming back to.

📖 **Full rendered docs (with PlantUML diagrams): https://karthik-dev-82.github.io/system-notes/**

---

## 📚 Quick Navigation Index

| Reference Guide | Primary Focus | Key Utilities Covered |
| --- | --- | --- |
| 🖥️ **[.bashrc Reference](docs/source/bashrc_reference.rst)** | Shell setup, aliases & functions | `.bashrc`, aliases, `__setprompt`, `ssh-agent` |
| 📊 **[System Monitoring Commands](docs/source/system_monitoring_commands.rst)** | Performance, Diagnostics & Resource Analysis | `htop`, `vmstat`, `iotop`, `iostat`, `ss`, `pidstat` |
| ⚡ **[Developer Commands](docs/source/developer_commands.rst)** | Daily Engineering Workflows & Tooling | `docker`, `git`, `rsync`, `aria2c`, `find`, `grep` |
| 🌐 **[Network Interfaces](docs/source/network_interfaces.rst)** | Linux network interfaces, explained with analogies & diagrams | `eth0`, `lo`, `veth`, `docker0`, VLANs, TUN/TAP, NAT |
| 🐳 **[Docker Dev Environment](docs/source/docker_dev_environment.rst)** | How the `development` repo's Docker dev container is built | `Dockerfile`, `devcontainer.json`, `docker-compose.yml` |
| 📝 **[spdlog Sinks & Architecture](docs/source/spdlog_sinks_architecture.rst)** | spdlog logging architecture, sinks, and log levels | `spdlog`, sinks, formatters, log levels, rotation |
| 🔌 **[Linux Devices](docs/source/linux_devices.rst)** | Block/char/network/terminal/pseudo devices, and USB layering | `/dev`, `lsblk`, `ttyACM`/`ttyUSB`, `udevadm`, PTYs |
| 🧠 **[Kernel Networking, Docker & OverlayFS](docs/source/kernel_networking_docker_internals.rst)** | Kernel networking stack, Docker internals, iptables, OverlayFS | netfilter, namespaces, cgroups, veth, DNAT/MASQUERADE, overlay2 |
| 📡 **[LIDAR & SLAM](docs/source/lidar_slam.rst)** | LIDAR and SLAM for navigation where GPS doesn't work | point clouds, localization, mapping, autonomous vehicles |
| 🔐 **[SSH: Your Secret Internet Tunnel](docs/source/ssh_secure_shell.rst)** | How the SSH handshake, encryption, and key auth actually work | key exchange, host keys, password vs. key auth, tunneling |
| 🔤 **[Unicode and UTF-8 Encoding](docs/source/unicode_utf8_encoding.rst)** | How Unicode code points and UTF-8's variable-length encoding work | code points, planes, UTF-8 bit patterns, multi-byte characters |
| 🔠 **[Base64 Encoding](docs/source/base64_encoding.rst)** | Base64, ASCII, URL encoding, and hex, explained with analogies | Base64 alphabet, percent-encoding, MIME attachments, hex colors |
| 🗄️ **[Databases: PostgreSQL, MongoDB & Redis](docs/source/databases_postgresql_mongodb_redis.rst)** | PostgreSQL, MongoDB, and Redis compared with a kitchen analogy | joins, documents, key-value, ACID, indexes, sorted sets |
| 🖼️ **[Image Formats](docs/source/image_formats.rst)** | SVG vs. PNG vs. JPEG, and when to use each | vector vs. raster, transparency, lossy/lossless compression |
| 🧵 **[Threads, Processes & Synchronization](docs/source/threads_processes_synchronization.rst)** | Threads, processes, and synchronization primitives in C++ | mutex, semaphore, condition variable, deadlock, race conditions |
| 🔐 **[Complete Guide to OpenSSL](docs/source/openssl_guide.rst)** | Encryption, hashing, and certificates, plus practical OpenSSL commands | symmetric/asymmetric crypto, TLS, x509 certs, `openssl` CLI |
| 🪟 **[The /proc Filesystem](docs/source/proc_filesystem.rst)** | The virtual /proc filesystem -- process info, system stats, tuning knobs | `/proc/PID`, `/proc/cpuinfo`, `/proc/meminfo`, `/proc/sys` |
| ⚖️ **[Hash Load Balancer](docs/source/hash_load_balancer.rst)** | Hash-based load balancing, sticky sessions, and consistent hashing | modulo hashing, session affinity, CDN routing, reshuffling problem |
| 🎮 **[TCP vs UDP (Interactive)](docs/source/tcp_udp_interactive.rst)** | Interactive TCP vs. UDP packet delivery -- play with loss and see the difference | handshake, retransmission, ordering, best-effort delivery |
| 🎮 **[TCP Congestion Control (Interactive)](docs/source/tcp_congestion_control_interactive.rst)** | Interactive TCP congestion control -- drive the cwnd sawtooth yourself | slow start, congestion avoidance, fast retransmit, timeout, ssthresh |

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
        ├── network_interfaces.rst
        ├── docker_dev_environment.rst
        ├── spdlog_sinks_architecture.rst
        ├── linux_devices.rst
        ├── kernel_networking_docker_internals.rst
        ├── lidar_slam.rst
        ├── ssh_secure_shell.rst
        ├── unicode_utf8_encoding.rst
        ├── base64_encoding.rst
        ├── databases_postgresql_mongodb_redis.rst
        ├── image_formats.rst
        ├── threads_processes_synchronization.rst
        ├── openssl_guide.rst
        ├── proc_filesystem.rst
        ├── hash_load_balancer.rst
        ├── tcp_udp_interactive.rst
        ├── tcp_congestion_control_interactive.rst
        └── _static/
            ├── custom.css
            ├── tcp_udp_widget.html
            └── tcp_congestion_widget.html

```

Docs are built and published to GitHub Pages automatically by
[`.github/workflows/docs.yml`](.github/workflows/docs.yml) on every push to
`main`.
