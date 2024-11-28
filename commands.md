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
```

### Stashing and Submodules
```bash
# Stash operations
git stash push -- /dir/to/folder/
git stash apply
git stash list                   # List stashes
git stash show -p               # Show stash contents

# Submodule management
git submodule update --init --recursive --rebase --force

# Update submodules (improved version)
git submodule sync
git submodule update --init --recursive --remote
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

# Find duplicate files
find -type f -exec md5sum '{}' ';' | \
    sort | uniq --all-repeated=separate -w 33 | cut -c 35-

# Enhanced duplicate file finder (with size check)
find . -type f -exec sha256sum {} \; | \
    sort | uniq -w 64 --all-repeated=separate | \
    cut -f 3- -d ' '
```

### Debugging and Analysis
```bash
# Valgrind memory checker
valgrind --leak-check=full \
    --show-leak-kinds=all \
    --track-origins=yes \
    --verbose \
    --log-file=valgrind-out.txt \
    ./executable exampleParam1

# Additional useful commands
strace -f ./executable           # Trace system calls
gdb ./executable                # GNU debugger
perf stat ./executable          # Performance statistics
```

## Additional Suggested Commands

### Docker
```bash
# Save and load Docker images
docker save -o image.tar image:tag
docker load -i image.tar

# Clean up specific resources
docker rmi $(docker images -f "dangling=true" -q)  # Remove dangling images
```

### Git
```bash
# Undo last commit but keep changes
git reset --soft HEAD^

# Find which commit introduced a bug
git bisect start
git bisect bad                  # Current version is bad
git bisect good v2.6.13-rc2    # Last known good version
```

### System Monitoring
```bash
# Monitor system resources
htop                           # Interactive process viewer
iotop                         # I/O monitoring
netstat -tulpn                # Network connections
```
