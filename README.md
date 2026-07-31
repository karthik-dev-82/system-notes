
# 🛠️ Bash Miscellaneous

A curated collection of practical reference guides, command-line cheat sheets, and DevOps workflows for Linux administration, container management, version control, and system diagnostics.

---

## 📚 Quick Navigation Index

| Reference Guide | Primary Focus | Key Utilities Covered |
| --- | --- | --- |
| 📊 **[System Monitoring Commands](system_monitoring_commands.md)** | Performance, Diagnostics & Resource Analysis | `htop`, `vmstat`, `iotop`, `iostat`, `ss`, `pidstat` |
| ⚡ **[Developer Commands](developer_commands.md)** | Daily Engineering Workflows & Tooling | `docker`, `git`, `rsync`, `aria2c`, `find`, `grep` |

---

## 📊 Overview of Included Guides

### 1. [System Monitoring Commands](https://www.google.com/search?q=./system_monitoring_commands.md)

Essential commands for inspecting system health, hunting down bottlenecks, and diagnosing real-time performance issues across CPU, Memory, Disk I/O, and Networking.

* **Process & CPU:** Interactive process monitoring with `htop`/`btop` and per-process CPU profiling using `pidstat`.
* **Memory & Performance:** Virtual memory pressure analysis with `vmstat`.
* **Storage I/O:** Disk bottleneck identification via `iotop` and `iostat`.
* **Network & Bandwidth:** Port inspection and connection tracing using modern `ss` and `iftop`.
* **Pro Workflows:** `tmux` dashboard grids, continuous `watch` loops, and background performance logging with `sar`.

### 2. [Developer Commands](https://www.google.com/search?q=./developer_commands.md)

Practical command snippets for container management, repository hygiene, version control, and advanced file manipulation.

* **Docker Management:** Container lifecycle operations, image maintenance, cleanup/pruning commands, networks, and volume persistence.
* **Git Version Control:** Branch creation/renaming (`git switch`), diff inspection, safe/forced cleanups, cherry-picking, interactive rebasing, submodules, and stash management (`git stash push`).
* **File Operations & Transfers:** High-speed multi-connection downloads using `aria2c`, directory mirroring with `rsync`, batch file renaming, SHA-256 duplicate detection, and modern search tools (`ripgrep`, `fd`).
  
---

## 📂 Repository Layout

```text
bash-miscellaneous/
├── README.md                          # Master repository index
├── system_monitoring_commands.md      # Linux monitoring & metrics guide
└── developer_commands.md              # Docker, Git & file operations guide

```
