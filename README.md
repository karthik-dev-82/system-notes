
# 🛠️ Bash Miscellaneous

A curated collection of practical reference guides, command-line cheat sheets, and DevOps workflows for Linux administration, container management, version control, and system diagnostics.

📖 **Full rendered docs (with PlantUML diagrams): https://karthik-dev-82.github.io/bash-miscellaneous/**
📥 **Single-file PDF (for offline reading/revision): https://karthik-dev-82.github.io/bash-miscellaneous/bash-miscellaneous.pdf**

---

## 📚 Quick Navigation Index

| Reference Guide | Primary Focus | Key Utilities Covered |
| --- | --- | --- |
| 🖥️ **[.bashrc Reference](docs/source/bashrc_reference.rst)** | Shell setup, aliases & functions | `.bashrc`, aliases, `__setprompt`, `ssh-agent` |
| 📊 **[System Monitoring Commands](docs/source/system_monitoring_commands.rst)** | Performance, Diagnostics & Resource Analysis | `htop`, `vmstat`, `iotop`, `iostat`, `ss`, `pidstat` |
| ⚡ **[Developer Commands](docs/source/developer_commands.rst)** | Daily Engineering Workflows & Tooling | `docker`, `git`, `rsync`, `aria2c`, `find`, `grep` |
| 🌐 **[Network Interfaces](docs/source/network_interfaces.rst)** | Linux network interfaces, explained with analogies & diagrams | `eth0`, `lo`, `veth`, `docker0`, VLANs, TUN/TAP, NAT |

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
bash-miscellaneous/
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
        └── network_interfaces.rst

```

Docs are built and published to GitHub Pages automatically by
[`.github/workflows/docs.yml`](.github/workflows/docs.yml) on every push to
`main`.
