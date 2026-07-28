# .bashrc Reference

Documents everything in `bashrc_work`. The `bashrc_local` variant is identical except the **Company-Specific** section below is removed entirely.

## Shell behavior & environment

| Setting | What it does |
| --- | --- |
| `HISTFILESIZE=10000` / `HISTSIZE=500` | Keeps 10,000 lines of history on disk, 500 in the live session buffer. |
| `HISTCONTROL=erasedups:ignoredups:ignorespace` | Drops duplicate history entries and skips lines that start with a space. |
| `shopt -s checkwinsize` | Re-reads terminal dimensions after each command (fixes wrapping after a resize). |
| `shopt -s histappend` | Appends to `~/.bash_history` instead of overwriting it, so multiple terminals don't clobber each other's history. |
| `stty -ixon` | Frees up Ctrl-S (normally "pause output") so it can be used for forward history search. |
| `bind "set completion-ignore-case on"` | Tab-completion ignores case. |
| `bind "set show-all-if-ambiguous On"` | Shows all completions immediately instead of requiring a second Tab press. |
| `EDITOR` / `VISUAL=vim` | Default editor for tools that shell out to one (`crontab -e`, `git commit`, etc.). |
| `CLICOLOR=1` / `LS_COLORS` | Color-codes `ls` output by file type/extension. |
| `LESS_TERMCAP_*` | Colors bold/underline text in `man` pages viewed through `less`. |


## General aliases

### Safety / modified defaults

| Alias | What it does |
| --- | --- |
| `cp='cp -i'`, `mv='mv -i'` | Prompt before overwriting an existing file. |
| `rm` | Uses `trash-put` (recoverable delete) if installed; otherwise falls back to `rm -iv` (confirm + verbose). |
| `mkdir='mkdir -p'` | Creates parent directories as needed, no error if the directory already exists. |
| `ps='ps auxf'` | Full process list in a tree/forest layout. |
| `ping='ping -c 10'` | Sends 10 pings and stops, instead of running forever. |
| `less='less -R'` | Renders raw ANSI color codes correctly instead of showing escape sequences. |
| `apt-get='sudo apt-get'` | Skips typing `sudo` for package installs. |

### Navigation

| Alias | What it does |
| --- | --- |
| `home`, `..`, `...`, `....`, `.....` | Jump to `$HOME` or up 1–4 directory levels. |
| `bd` | Returns to the previous directory (`$OLDPWD`). |
| `web` | `cd /var/www/html`. |

### Directory listings

| Alias | What it does |
| --- | --- |
| `la` | `ls -Alh` — show hidden files. |
| `ls` | `ls -Fh --color=always` — type suffixes + forced color. |
| `lx` | Sort by extension. |
| `lk` | Sort by size. |
| `lc` | Sort by change time. |
| `lu` | Sort by last access time. |
| `lr` | Recursive listing. |
| `lt` | Sort by modification date. |
| `lm` | Long listing piped through `more`. |
| `lw` | Wide format. |
| `ll` | `ls -Fls` — long listing with size. |
| `labc` | Alphabetical. |
| `lf` / `ldir` | Files only / directories only. |

### Permissions

`mx` (`chmod a+x`), and numeric shortcuts `000`, `644`, `666`, `755`, `777` (each is `chmod -R <mode>`).

### Search

| Alias | What it does |
| --- | --- |
| `h` | Grep your command history. |
| `p` | Grep running processes. |
| `topcpu` | Top 10 processes by CPU usage. |
| `f` | Grep filenames under the current directory. |
| `countfiles` | Counts files, symlinks, and directories recursively under `.`. |
| `checkcommand` | Shows whether a word is an alias, function, builtin, or file (`type -t`). |

### Networking

`ipview` (list IPs on global-scope interfaces), `openports` (`netstat` view of listening/established connections, PID + program).

### Disk & archives

| Alias | What it does |
| --- | --- |
| `diskspace`, `folders`, `folderssort` | Various `du`\-based views of what's consuming space. |
| `tree` / `treed` | Colorized directory tree (all files / dirs only). |
| `mountedinfo` | `df -hT` — mounted filesystems with type. |
| `mktar`, `mkbz2`, `mkgz` | Create `.tar`, `.tar.bz2`, `.tar.gz` archives. |
| `untar`, `unbz2`, `ungz` | Extract the corresponding archive type. |

### Misc

| Alias | What it does |
| --- | --- |
| `logs` | Tails every text-based log file under `/var/log`. |
| `psme` | Lists only your own processes, formatted as a table. |
| `sha1` | `openssl sha1` — quick SHA1 checksum. |
| `cpp` | `rsync -ah --info=progress2` — copy with a progress bar (handles large files better than `cp`). |
| `cpu` | One-line current CPU usage percentage, computed from `/proc/stat`. |
| `xclean` | Alias for the `fn_xclean` function (see below). |

## Functions

**`extract <file>`** — Universal archive extractor. Detects the format from the extension (`.tar.gz`, `.zip`, `.7z`, `.rar`, etc.) and runs the matching tool, so you don't need to remember `tar` flags per format.

**`search_file <name>`** — Wraps `find / -name <name> -type f`, searching the whole filesystem for a file by name.

**`ftext <pattern>`** — Recursive `grep` across the current directory, pre-excluding generated/binary file types (`.o`, `.so`, `.js`, `.html`, build artifacts, etc.) so results aren't drowned in noise.

**`ftextcount <pattern>`** — Same exclusions as `ftext`, but reports a per-file match _count_ sorted descending instead of printing every matching line.

**`up <n>`** — Moves up `n` directory levels in one command (`up 3` ≈ `cd ../../..`).

**`pwdtail`** — Prints just the last two path segments of the current directory (handy for a short prompt or log line).

**`distribution`** / **`ver`** — Read `/etc/os-release` to print the distro ID or the human-readable OS name/version.

**`netinfo`** — Compact view of each network interface and its IP (`ip -br addr show`).

**`mysqlconfig`** — Finds whichever `my.cnf` exists on the system (checks several common paths) and opens it in the editor; runs `updatedb && locate my.cnf` as a fallback if none is found.

**`rot13 [text]`** — ROT13 encode/decode, either from an argument or from stdin.

**`trim`** — Strips leading/trailing whitespace from a string (used internally by scripts, not typically called by hand).

**`_docker_cli_wipe`** _(internal helper)_ — Removes all containers, images, volumes, and buildx builders/cache via the normal Docker CLI. Leaves the daemon running. Shared by `docker-prune` and `fn_xclean` so the wipe logic only exists in one place.

**`_docker_wipe_warn`** _(internal helper)_ — Prints what's about to be destroyed (running containers) and sleeps 4 seconds before continuing, giving you a Ctrl-C window instead of executing blind.

**`docker-prune [--deep]`** — Docker cleanup.

- No flag: runs `_docker_cli_wipe` only — full CLI-level prune, daemon stays up.
- `--deep`: additionally stops Docker and deletes `/var/lib/docker` and `/var/lib/containerd` directly on disk, then restarts the daemon. This is the "nuclear option" — only needed to recover from actual Docker corruption, since it forces every image to be re-pulled from scratch. Also calls an internal `runner host buildkit fix` command afterward if `runner` is installed (unclear what it does internally — likely re-provisions the buildx builder).

**`fn_submodule_update`** — `git submodule update --init --recursive --rebase --force`. Syncs all submodules to the versions pinned by the parent repo.

**`diskhealth`** — Prints a three-part dashboard: physical disk space (`df -h`, excluding virtual filesystems), a Docker storage breakdown (`docker system df` + the daemon's data root), and system cache sizes (systemd journal, APT cache, `/var/log`).

**`fn_xclean [--docker]`** _(aliased as `xclean`)_ — Repo cleanup for starting a fresh branch. Must be run from inside a git repo (aborts otherwise). Removes `.venv` directories, `__pycache__` directories, and `work`/`*/work` build directories anywhere in the repo.

- `--docker`: additionally runs the full Docker wipe (`_docker_cli_wipe`), stopping and restarting the daemon around it. This is opt-in because it's machine-wide — it affects every container/image/volume on the box, not just this repo.

**`__setprompt`** — Builds the colored, multi-line `PS1` prompt: shows the last exit code in red if a command failed, then date/time, job count, user@host (if over SSH), and current directory.

## Prompt & session startup

- **`PROMPT_COMMAND='history -a; __setprompt'`** — Runs before every prompt: immediately flushes new history to disk, then rebuilds the prompt.
- **ssh-agent persistence** — On shell start, sources a saved agent environment from `~/.ssh/agent-environment` if one exists and its process is still alive; otherwise starts a new `ssh-agent` and saves its environment for future shells to reuse. This means every terminal shares one agent and its loaded keys instead of each spawning its own.
