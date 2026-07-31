# Development Commands Reference Guide

A curated reference sheet for daily developer workflows, including Docker container management, Git operations, and advanced Linux file manipulation.

---

## 📋 Table of Contents

* [Docker Operations](#-docker-operations)
  * [Container Operations](#container-operations)
  * [Image Management](#image-management)
  * [Cleanup & Pruning](#cleanup--pruning)
  * [Networks & Volumes](#networks--volumes)

* [Git Version Control](#-git-version-control)
  * [Basic Operations](#basic-operations)
  * [Branch Management](#branch-management)
  * [History & Diffs](#history--diffs)
  * [Stash Operations](#stash-operations)
  * [Advanced Git](#advanced-git)

* [File Operations & Utilities](#-file-operations--utilities)
  * [Search & Find](#search--find)
  * [File Transfer & Downloads](#file-transfer--downloads)
  * [File Management & Duplicates](#file-management--duplicates)

---

## 🐳 Docker Operations

### Container Operations

```bash
# Copy files between host and container
docker cp local_file.txt mycontainer:/container_path/
docker cp mycontainer:/container_path/file.txt ./local_file.txt

# Container lifecycle
docker start <container>
docker stop <container>
docker restart <container>
docker rm <container>          # Remove a stopped container
docker rename <old_name> <new_name>

# Access & Inspection
docker exec -it <container> bash  # Interactive shell access
docker logs -f --tail 100 <container> # Follow live logs (last 100 lines)
docker inspect <container>     # Output detailed JSON configuration

```

### Image Management

```bash
# Core operations
docker pull <image>:<tag>      # Pull image from registry
docker push <image>:<tag>      # Push image to registry
docker build -t <name>:<tag> . # Build image from local Dockerfile
docker tag <image_id> <new_name>:<tag>
docker rmi <image>             # Remove local image

# Export & Import tarballs
docker save -o image.tar <image>:<tag>
docker load -i image.tar

```

### Cleanup & Pruning

```bash
# Global cleanup (Use with care)
docker system prune -a --volumes  # Remove ALL unused containers, networks, images, and volumes

# Targeted cleanup
docker container prune         # Remove all stopped containers
docker image prune -a          # Remove all unused images
docker volume prune            # Remove all unattached volumes
docker network prune           # Remove all unused networks

# Remove dangling items
docker rmi $(docker images -f "dangling=true" -q)

```

### Networks & Volumes

```bash
# Network operations
docker network create <network_name>
docker network ls              # List networks
docker network inspect <network_name>
docker network rm <network_name>

# Volume management
docker volume create <volume_name>
docker volume ls               # List persistent volumes
docker volume inspect <volume_name>
docker volume rm <volume_name>

```

---

## 🐙 Git Version Control

### Basic Operations

```bash
# Repository setup
git init                       # Initialize repository in current directory
git clone <url>                # Clone remote repository
git remote add origin <url>    # Link local repo to remote
git remote -v                  # List configured remotes with URLs

# Staging & Committing
git add <file>                 # Stage specific file
git add -A                     # Stage all changes (new, modified, deleted)
git commit -m "commit message" # Commit staged changes
git commit --amend --no-edit   # Add staged changes to last commit without changing message

```

### Branch Management

```bash
# Branch Creation & Switching
git switch <branch>            # Modern way to switch branches
git switch -c <branch>         # Create and switch to new branch
git checkout -b <branch>       # Legacy equivalent to create & switch

# Branch Deletion & Maintenance
git branch -d <branch>         # Delete local branch (safe mode)
git branch -D <branch>         # Force delete unmerged local branch
git push origin --delete <branch> # Delete remote branch

# Rename Current Branch
git branch -m <new_name>
git push origin -u <new_name>
git push origin --delete <old_name>

```

### History & Diffs

```bash
# Log Analysis
git log --graph --oneline --decorate --all # Compact visualization of commit graph
git log -p <file>              # Display commit history along with file diffs
git log -S "<string>"          # Search commit history for specific code string
git blame <file>               # Show author and commit info line-by-line

# Inspecting Changes
git diff                       # Unstaged changes vs staging area
git diff --staged              # Staged changes vs last commit
git diff <branch1>..<branch2>  # Compare differences between two branches

```

### Stash Operations

```bash
# Saving Changes
git stash push -m "work in progress" # Stash local changes with descriptive message
git stash push -- path/to/dir/      # Stash changes in specific folder only

# Applying & Managing
git stash list                 # Display all saved stashes
git stash show -p stash@{0}    # Inspect diff of a specific stash
git stash apply                # Apply latest stash without deleting it
git stash pop                  # Apply latest stash and remove it from list
git stash drop stash@{0}       # Remove specific stash
git stash clear                # WIPE ALL STASHES

```

### Advanced Git

```bash
# Cherry-picking
git cherry-pick <commit_hash>    # Apply specific commit to current branch
git cherry-pick -x <commit_hash>  # Include source commit reference in message
git cherry-pick --abort        # Cancel cherry-pick process on conflict

# Rebase Workflows
git rebase -i HEAD~3           # Interactively edit last 3 commits (squash/reword)
git rebase --abort             # Abort active rebase process

# Submodules
git submodule add <url>        # Add new submodule
git submodule update --init --recursive # Clone/initialize all submodules
git submodule foreach git pull origin main # Update all submodules

```

---

## 📁 File Operations & Utilities

### Search & Find

```bash
# Standard find
find . -name "*.log"           # Find files by name pattern
find . -type f -mtime -7       # Find files modified in the last 7 days
find . -size +100M             # Find files larger than 100MB
find . -empty                  # Find empty files or directories

# Standard grep
grep -rnw "pattern" .          # Recursive search for exact word in current directory
grep -C 3 "error" app.log      # Search with 3 lines of leading/trailing context
grep -v "DEBUG" app.log        # Filter out lines containing "DEBUG"

# Modern Alternatives (Faster)
ripgrep "pattern"              # rg (Fast grep alternative, respects .gitignore)
fd "pattern"                   # fd (Fast find alternative)

```

### File Transfer & Downloads

```bash
# Multi-threaded download (aria2)
aria2c -x 16 -s 16 \
    --min-split-size=2M \
    --console-log-level=warn \
    --dir=./downloads \
    --out=filename.tar.bz2 \
    "https://example.com/file.tar.bz2"

# Robust file sync (rsync)
rsync -avz --progress source/ destination/       # Incremental sync with progress
rsync -avz --delete source/ destination/         # Mirror destination exactly to source

```

### File Management & Duplicates

```bash
# Find duplicate files via SHA256 checksums
find . -type f -exec sha256sum {} + | \
    sort | \
    uniq -w 64 --all-repeated=separate

# Batch Renaming
rename 's/\.txt$/\.md/' *.txt  # Rename all .txt files to .md
rename 's/\s+/_/g' *           # Replace spaces with underscores in all filenames

```
