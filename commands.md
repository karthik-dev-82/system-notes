# Development Commands Reference Guide

## Docker Commands

### Container Management
```bash
# Copy files between host and container
docker cp foo.txt mycontainer:/foo.txt
docker cp mycontainer:/foo.txt foo.txt

# Remove all unused Docker resources
docker system prune -a --volumes  # More comprehensive than current command
docker container prune           # Remove stopped containers
docker image prune              # Remove unused images
docker volume prune             # Remove unused volumes

# Additional useful commands
docker exec -it <container_name> bash  # Interactive shell
docker logs -f <container_name>        # Follow container logs
docker inspect <container_name>        # View container details

# Container resource usage
docker stats                    # Live resource usage
docker top <container_name>     # View running processes

# Network operations
docker network ls              # List networks
docker network inspect <network_name>  # Network details

# Volume management
docker volume create <volume_name>    # Create named volume
docker volume ls                      # List volumes
```

## Git Commands

### Branch Management
```bash
# Show changes in a commit
git show --color --pretty=format:%b <hash>

# Delete branch locally and remotely
git push --delete <remote_name> <branch_name>
git branch -d <branch_name>

# Rename branch
git checkout <old_name>
git branch -m <new_name>
git push origin -u <new_name>
git push origin --delete <old_name>

# List all branches
git branch -a                    # Show all branches
git branch -vv                   # Show branch tracking info

# Search through commit history
git log -S"<string>"            # Search for string in commits
git log -p <file>               # Show file history with diffs

# Advanced diff commands
git diff --word-diff            # Show word level changes
git diff --cached               # Show staged changes
```

### Cherry-picking and Logs
```bash
# Cherry-pick from another repo
git remote add other https://example.link/repository.git
git fetch other
git cherry-pick <commit_hash>

# View branch history
git log --graph --abbrev-commit --decorate --first-parent <branch_name>
git log --oneline --graph --decorate --all  # View all branches

# Blame with ignored whitespace
git blame -w <file>             # Ignore whitespace
git blame -M <file>             # Detect moved lines
```

### Stashing and Submodules
```bash
# Stash operations
git stash push -- /dir/to/folder/
git stash apply
git stash list                   # List stashes
git stash show -p               # Show stash contents
git stash drop                  # Remove last stash
git stash clear                 # Remove all stashes

# Submodule management
git submodule update --init --recursive --rebase --force
git submodule foreach git pull  # Update all submodules
git submodule status           # Check submodule states

# Clean working directory
git clean -fd                   # Remove untracked files/directories
git clean -nx                   # Dry run clean
```

## General Commands

### File Operations
```bash
# Download large files with aria2c
aria2c -x 16 -s 16 \
    --min-split-size=2M \
    --console-log-level=warn \
    --dir=./downloads \
    --out=filename.tar.bz2 \
    "http://example.com/file.tar.bz2"

# Search in files
grep --include="*.*" -nRHI "pattern" *     # Search in all files
grep -r --include="*.cpp" "pattern" *      # Search in specific file types
grep -l "pattern" *                        # List only filenames
grep -C 3 "pattern" file                   # Show 3 lines of context

# Find duplicate files
find -type f -exec md5sum '{}' ';' | \
    sort | uniq --all-repeated=separate -w 33 | cut -c 35-

# Enhanced duplicate file finder (with size check)
find . -type f -exec sha256sum {} \; | \
    sort | uniq -w 64 --all-repeated=separate | \
    cut -f 3- -d ' '

# Advanced find commands
find . -type f -mtime -7        # Files modified in last 7 days
find . -size +100M              # Files larger than 100MB
find . -exec chmod 644 {} \;    # Change permissions recursively
```

### System Monitoring

#### htop - Interactive Process Viewer
```plaintext
  1  [||||||                                 17.2%]     Tasks: 44, 37 thr; 1 running
  2  [||||||||                               21.0%]     Load average: 0.52 0.58 0.59
  3  [|||||||                                18.7%]     Uptime: 3 days, 12:45:17
  4  [|||||                                  13.2%]
  Mem[||||||||||||||||||||||||||||||||||||7.27G/7.70G]
  Swp[|||||||||                               2.1G/8.0G]

  PID USER      PRI  NI  VIRT   RES   SHR S CPU% MEM%   TIME+  Command
 1234 root       20   0  4196M 1.2G  8984 S  6.0 15.9  12:46.45 docker
 5678 mysql      20   0  8112M 2.1G    4M S  4.2 27.3   5:23.12 mysqld
 9012 www-data   20   0  2816M 382M   11M S  2.1  4.9   3:12.56 apache2
```

#### iotop - I/O Monitoring
```plaintext
Total DISK READ: 0.00 B/s | Total DISK WRITE: 142.22 K/s
Current DISK READ:0.00 B/s | Current DISK WRITE: 0.00 B/s
  TID  PRIO  USER     DISK READ  DISK WRITE  SWAPIN     IO>    COMMAND
 1234   be   mysql    0.00 B/s   123.45 K/s  0.00 %   3.44 % mysqld
 5678   be   root     0.00 B/s    18.77 K/s  0.00 %   0.00 % docker-compose
 9012   be   www-data 0.00 B/s     0.00 B/s  0.00 %   0.00 % apache2
```

#### netstat - Network Connections
```plaintext
Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program
tcp        0      0 0.0.0.0:80             0.0.0.0:*               LISTEN      1234/nginx
tcp        0      0 0.0.0.0:3306           0.0.0.0:*               LISTEN      5678/mysqld
tcp        0      0 127.0.0.1:6379         0.0.0.0:*               LISTEN      9012/redis-server
tcp6       0      0 :::22                  :::*                    LISTEN      1111/sshd
```

### Additional System Commands
```bash
# Resource monitoring
vmstat 1                       # Virtual memory stats every second
iostat -x 1                    # I/O statistics every second
dstat                         # Versatile resource statistics
pidstat                       # Per-process statistics

# Network monitoring
ss -tuln                      # Alternative to netstat
iftop                        # Network bandwidth monitor
tcpdump -i any               # Packet capture
mtr google.com               # Network path analysis

# File system operations
ncdu                         # Disk usage analyzer
lsof                        # List open files
fuser -m /mount/point       # Show processes using filesystem
```
