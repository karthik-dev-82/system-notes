# Development Commands Reference Guide

## Docker Commands

### Basic Container Operations
```bash
# Copy files between host and container
docker cp foo.txt mycontainer:/foo.txt
docker cp mycontainer:/foo.txt foo.txt

# Container lifecycle
docker start <container>
docker stop <container>
docker restart <container>
docker rm <container>          # Remove container
docker rename <old> <new>      # Rename container

# Container access
docker exec -it <container> bash  # Interactive shell
docker logs -f <container>        # Follow logs
docker inspect <container>        # View details
```

### Image Management
```bash
# Image operations
docker pull <image>:<tag>      # Pull image
docker push <image>:<tag>      # Push to registry
docker build -t <name> .       # Build from Dockerfile
docker tag <image> <new>       # Tag image
docker rmi <image>             # Remove image

# Save and load images
docker save -o image.tar image:tag
docker load -i image.tar
```

### Cleanup Commands
```bash
# Remove unused resources
docker system prune -a --volumes  # Remove all unused
docker container prune           # Remove stopped containers
docker image prune              # Remove unused images
docker volume prune             # Remove unused volumes
docker network prune            # Remove unused networks

# Remove specific resources
docker rmi $(docker images -f "dangling=true" -q)  # Remove dangling images
```

### Network & Volume Management
```bash
# Network operations
docker network create <network>  # Create network
docker network ls               # List networks
docker network rm <network>     # Remove network
docker network inspect <network> # Network details

# Volume management
docker volume create <name>     # Create volume
docker volume ls                # List volumes
docker volume rm <name>         # Remove volume
docker volume inspect <name>    # Volume details
```

## Git Commands

### Basic Operations
```bash
# Repository setup
git init                      # Initialize repository
git clone <url>               # Clone repository
git remote add origin <url>   # Add remote
git remote -v                 # List remotes

# Stage and commit
git add <file>                # Stage file
git add -A                    # Stage all changes
git commit -m "message"       # Commit with message
git commit --amend            # Modify last commit
```

### Branch Management
```bash
# Create and switch branches
git checkout -b <branch>      # Create and switch
git switch -c <branch>        # Modern way to create and switch
git branch <branch>           # Create branch
git checkout <branch>         # Switch branch

# Delete branches
git push --delete <remote> <branch>  # Delete remote branch
git branch -d <branch>               # Delete local branch
git branch -D <branch>               # Force delete local branch

# Rename branch
git checkout <old_name>
git branch -m <new_name>
git push origin -u <new_name>
git push origin --delete <old_name>
```

### History and Diff
```bash
# View history
git log --graph --oneline     # Compact history
git log -p <file>             # File history with diffs
git log -S"<string>"          # Search in commits
git blame <file>              # Show file annotations

# Compare changes
git diff                      # Working directory vs staging
git diff --staged            # Staging vs last commit
git diff <branch1>..<branch2> # Compare branches
git diff --word-diff         # Show word-level changes
```

### Stash Operations
```bash
# Stash management
git stash push -- /dir/to/folder/  # Stash specific folder
git stash save "message"          # Stash with message
git stash list                    # List stashes
git stash show -p                 # Show stash contents
git stash apply                   # Apply stash
git stash pop                     # Apply and remove stash
git stash drop                    # Remove stash
git stash clear                   # Remove all stashes
```

### Advanced Operations
```bash
# Cherry-picking
git cherry-pick <commit>      # Cherry-pick commit
git cherry-pick -x <commit>   # Include source reference
git cherry-pick --abort       # Abort cherry-pick

# Rebase operations
git rebase -i HEAD~3          # Interactive rebase
git rebase --onto <new> <old> # Change base
git rebase --abort           # Abort rebase

# Submodule management
git submodule add <url>       # Add submodule
git submodule init           # Initialize submodules
git submodule update --init --recursive  # Update submodules
git submodule foreach git pull  # Update all submodules
```

## File Operations

### Search and Find
```bash
# Find files
find . -name "pattern"        # Find by name
find . -type f -mtime -7      # Files modified in last 7 days
find . -size +100M            # Files larger than 100MB
find . -empty                 # Find empty files/directories

# Grep operations
grep -r "pattern" .           # Recursive search
grep -l "pattern" *           # List only filenames
grep -C 3 "pattern" file      # Show context
grep -v "pattern" file        # Inverse match
```

### File Transfer and Download
```bash
# aria2c download
aria2c -x 16 -s 16 \
    --min-split-size=2M \
    --console-log-level=warn \
    --dir=./downloads \
    --out=filename.tar.bz2 \
    "http://example.com/file.tar.bz2"

# rsync file transfer
rsync -avz --progress source/ dest/
rsync -avz --delete source/ dest/  # Mirror directories
```

### File Management
```bash
# Find duplicates
find -type f -exec md5sum '{}' ';' | \
    sort | uniq --all-repeated=separate -w 33 | cut -c 35-

# Advanced duplicate finder
find . -type f -exec sha256sum {} \; | \
    sort | uniq -w 64 --all-repeated=separate | \
    cut -f 3- -d ' '

# Batch rename
rename 's/\.txt$/\.md/' *.txt  # Rename txt to md
rename 's/\s+/_/g' *           # Replace spaces with underscores
```
