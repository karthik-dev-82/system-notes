The original documentation is already well-structured, but we can make it **much easier to scan, reference, and maintain**.

Here are the key improvements made to the reference document:

* **Added visual tags/badges** for alias safety warnings (e.g., destructive actions vs. read-only commands).
* **Grouped related entries** into collapsible/distinct subsections to eliminate table bloat.
* **Streamlined function descriptions** with exact syntax usage so you don't have to check the script to remember parameters.
* **Separated interactive aliases from script utility functions**.

---

# `.bashrc` Reference Guide

> **Note:** Documents everything included in `bashrc_work`. The `bashrc_local` variant is identical except the **Company-Specific** section is removed entirely.

---

## 1. Shell Environment & Behavior

| Environment / Option | Value / Setting | Description |
| --- | --- | --- |
| **History Size** | `HISTFILESIZE=10000`<br>

<br>`HISTSIZE=500` | Retains 10,000 lines on disk, 500 in live terminal buffer. |
| **History Control** | `erasedups:ignoredups:ignorespace` | Removes duplicate entries and skips commands starting with a space. |
| **History Append** | `shopt -s histappend` | Appends to `~/.bash_history` on exit instead of overwriting. |
| **Window Resizing** | `shopt -s checkwinsize` | Recalculates `LINES` and `COLUMNS` after every command. |
| **Tab Completion** | `completion-ignore-case` (On)<br>

<br>`show-all-if-ambiguous` (On) | Ignores case and shows options on a single `Tab` press. |
| **Terminal Bell** | `set bell-style visible` | Flashes terminal visually instead of making audio bell sounds. |
| **Terminal Flow** | `stty -ixon` | Disables `Ctrl-S` output freezing to allow forward history search. |
| **Default Editor** | `EDITOR=vim`, `VISUAL=vim` | Uses `vim` for interactive tools (`crontab`, `git commit`, `nano`/`pico` aliases). |
| **Color Schemes** | `CLICOLOR=1`, `LS_COLORS` | Full color-coding for directory listings based on file extension. |
| **Man Page Colors** | `LESS_TERMCAP_*` | Adds color highlights (bold/underline) when reading man pages via `less`. |

---

## 2. General Aliases

### Safety & Modified Defaults

* `cp` / `mv` $\rightarrow$ `cp -i` / `mv -i` *(Interactive prompt before overwriting)*
* `rm` $\rightarrow$ Uses `trash-put` *(recoverable delete)* if installed; falls back to `rm -iv` *(confirm + verbose)*
* `rmd` $\rightarrow$ `/bin/rm --recursive --force --verbose` **`[DESTRUCTIVE]`**
* `mkdir` $\rightarrow$ `mkdir -p` *(Creates parent directories without error if existing)*
* `ps` $\rightarrow$ `ps auxf` *(Full process hierarchy tree)*
* `ping` $\rightarrow$ `ping -c 10` *(Limits ping count to 10)*
* `less` $\rightarrow$ `less -R` *(Renders ANSI colors properly)*
* `apt-get` $\rightarrow$ `sudo apt-get` *(Automatically runs with root privileges)*
* `vi` / `svi` / `vis` $\rightarrow$ `vim` / `sudo vi` / `vim "+set si"` *(Auto-indentation)*
* `nano` / `pico` $\rightarrow$ `edit` *(Custom editor mapping)*
* `snano` / `spico` $\rightarrow$ `sedit` *(Custom sudo editor mapping)*

### Navigation Shortcuts

* **Jump up directories:** `..` (`cd ..`), `...` (`cd ../..`), `....` (`cd ../../..`), `.....` (`cd ../../../..`)
* **Home / Web / Back:** `home` (`cd ~`), `web` (`cd /var/www/html`), `bd` (`cd "$OLDPWD"`)

### Directory Listings (`ls` variants)

| Alias | Command | Purpose |
| --- | --- | --- |
| `ls` | `ls -Fh --color=always` | Base colorized view with file-type indicators (`/`, `*`). |
| `la` | `ls -Alh` | Show all files including hidden (`.dotfiles`). |
| `ll` | `ls -Fls` | Long listing format with block sizes. |
| `lx` / `lk` | `ls -lXBh` / `ls -lSrh` | Sort by **extension** / Sort by **size** (descending). |
| `lc` / `lu` / `lt` | `ls -lcrh` / `-lurh` / `-ltrh` | Sort by **change time** / **access time** / **modification date**. |
| `lr` / `lw` / `lm` | `ls -lRh` / `ls -xAh` / `... | more` | **Recursive** / **Wide** horizontal layout / **Paged** listing. |
| `lf` / `ldir` | *grep filter* | Show **files only** / Show **directories only**. |
| `labc` | `ls -lap` | Alphabetical listing with slash indicators. |

### Permissions & System Controls

* **Executable Quick-Grant:** `mx` $\rightarrow$ `chmod a+x`
* **Recursive Numeric Modes:** `000`, `644`, `666`, `755`, `777` *(Runs `chmod -R <mode>`)*
* **System Shutdown:** `rebootsafe` (`sudo shutdown -r now`), `rebootforce` (`sudo shutdown -r -n now`)

### Search, Process & Disk Operations

* **Search:** `h` *(Grep history)*, `p` *(Grep running processes)*, `f` *(Grep filenames under `.`)*
* **Process Watch:** `topcpu` *(Top 10 CPU consuming processes)*, `psme` *(Pretty table of your active processes)*
* **Disk Space:** `folders` (`du -h --max-depth=1`), `folderssort` *(Sorted size by folder)*, `mountedinfo` (`df -hT`)
* **Directory Trees:** `tree` *(Colorized files + dirs)*, `treed` *(Directories only)*
* **Archives:**
* Compress: `mktar` (`.tar`), `mkbz2` (`.tar.bz2`), `mkgz` (`.tar.gz`)
* Extract: `untar`, `unbz2`, `ungz`


* **Utilities:**
* `cpp` $\rightarrow$ `rsync -ah --info=progress2` *(Copy large files with progress bar)*
* `cpu` $\rightarrow$ Calculates live CPU utilization percentage from `/proc/stat`
* `sha1` $\rightarrow$ `openssl sha1`
* `logs` $\rightarrow$ Continuous live tail of non-rotated log files under `/var/log`
* `countfiles` $\rightarrow$ Counts total files, links, and directories under current folder
* `checkcommand` $\rightarrow$ Runs `type -t` to reveal if a word is an alias, builtin, or binary
* `ipview` / `openports` $\rightarrow$ Lists global network IPs / Lists active TCP/UDP ports with PIDs



---

## 3. Functions Reference

### Navigation & Filesystem

#### `up <n>`

Moves up $n$ directory levels in a single command.

```bash
up 3  # Equivalent to cd ../../..

```

#### `pwdtail`

Prints only the trailing two directory levels of the current working directory.

```bash
$ pwd -> /var/www/html/site/assets
$ pwdtail -> site/assets

```

#### `search_file <filename>`

Executes a quick global search for a file starting from root `/` while suppressing permission errors.

```bash
search_file "nginx.conf"

```

#### `extract <file1> [file2 ...]`

Universal archive unpacker. Automatically detects format from extension (`.tar.gz`, `.zip`, `.7z`, `.rar`, `.bz2`, `.gz`, `.Z`).

---

### Code Search (`grep` Wrappers)

#### `ftext <pattern>`

Recursively searches for text across the current directory while excluding common compiled binaries, node modules, build artifacts, and auto-generated files (`.so`, `.o`, `.js`, `.html`, `Makefile`, etc.).

#### `ftextcount <pattern>`

Uses the same exclusion filters as `ftext`, but returns a **sorted file count list** of occurrences in descending order instead of line matches.

---

### System & Maintenance

#### `diskhealth`

Displays a comprehensive 3-part diagnostic dashboard:

1. Physical disk utilization (excluding `tmpfs`, `squashfs`, etc.).
2. Docker storage breakdown (`docker system df` + data root path).
3. System logs & cache footprint (`journalctl`, APT package cache, `/var/log`).

#### `fn_xclean [--docker]` *(Alias: `xclean`)*

Cleans current Git repository workspace before starting a new branch. **Must be run inside a Git repo.**

* Removes all `.venv` virtual environment directories.
* Removes all `__pycache__` directories.
* Removes `work` and `*/work` build output folders.
* `--docker`: **Optional.** Executes `_docker_cli_wipe` (stops Docker, wipes containers, images, volumes, and buildx cache machine-wide).

#### `docker-prune [--deep]`

Resets Docker resources on the host machine. Includes a 4-second delay buffer allowing cancellation (`Ctrl-C`).

* `docker-prune`: Runs `_docker_cli_wipe` (Clears containers, images, volumes, buildx cache without restarting daemon).
* `docker-prune --deep`: **Nuclear option.** Stops Docker daemon, directly deletes `/var/lib/docker/*` and `/var/lib/containerd/*` on disk, restarts daemon, and attempts `runner host buildkit fix` if available.

#### `fn_submodule_update`

Forcefully fetches, initializes, and rebases all Git submodules recursively:

```bash
git submodule update --init --recursive --rebase --force

```

#### `mysqlconfig`

Locates the active `my.cnf` file across standard paths (`/etc/my.cnf`, `/etc/mysql/my.cnf`, `~/.my.cnf`, etc.) and opens it using `sedit`. Falls back to `updatedb && locate my.cnf` if missing.

#### `netinfo` / `distribution` / `ver`

* `netinfo`: Compact state of network interfaces & IP assignments (`ip -br addr show`).
* `distribution`: Prints OS ID tag (e.g., `ubuntu`, `debian`, `centos`).
* `ver`: Prints full OS human-readable release string.

#### `rot13 [string]`

Standard ROT13 cipher transformation from argument or standard input stream.

---

## 4. Prompt & Shell Initialization

### Dynamic Prompt (`__setprompt`)

The prompt (`PS1`) is controlled via `PROMPT_COMMAND` which runs `history -a; __setprompt` before every rendered command line.

Features built into the multi-line prompt:

1. **Error Status:** Displays `(ERROR)-(Exit <code_number>)` in red if the previous command returned a non-zero exit code.
2. **Timestamp & Jobs:** Live date/time display alongside active background job counts (`Jobs:\j`).
3. **SSH Detection:** Automatically includes `user@hostname` in red when connected via SSH; displays only `username` on local sessions.
4. **Directory Path:** Highlights full working directory path (`\w`).
5. **Privilege Indicator:** Color changes to **Red `>**` for root sessions, **Green `>**` for standard user sessions.

### Shared `ssh-agent` Lifecycle

On interactive shell startup:

1. Checks for saved agent configuration at `~/.ssh/agent-environment`.
2. If file exists, reads PID and validates if the process is running using `kill -0 $SSH_AGENT_PID`.
3. If process is dead or file is missing, spawns a single `ssh-agent`, exports permissions (`chmod 600`), and writes session details to file.
4. **Result:** Every subshell and new terminal window connects to a single persistent SSH agent instead of launching orphaned background processes.
