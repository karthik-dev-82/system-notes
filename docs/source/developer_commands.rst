Development Commands Reference Guide
======================================

.. raw:: html

   <style>
     div.document {
       background: #eef1ee;
       color: #1c231d;
       font-family: Georgia, "Iowan Old Style", "Times New Roman", serif;
       line-height: 1.68;
       font-size: 17px;
       border: 1px solid #cdd6cc;
       border-radius: 4px;
       padding: 40px 48px 48px;
       margin: 12px 0 24px;
     }
     div.document h1 {
       font-family: inherit;
       font-weight: 400;
       font-size: 2.4rem;
       line-height: 1.12;
       color: #1c231d;
       border-bottom: 1px solid #cdd6cc;
       padding-bottom: 18px;
       margin: 0 0 30px;
     }
     div.document h2 {
       font-family: inherit;
       font-weight: 400;
       font-style: italic;
       font-size: 1.5rem;
       color: #1c231d;
       margin: 44px 0 10px;
       padding-top: 26px;
       border-top: 1px solid #cdd6cc;
     }
     div.document h2:first-of-type { border-top: none; padding-top: 0; margin-top: 30px; }
     div.document h3 {
       font-family: inherit;
       font-weight: 700;
       font-style: normal;
       font-size: 1.14rem;
       color: #7a2f3d;
       margin: 26px 0 8px;
     }
     div.document .headerlink {
       color: #5c675d;
       opacity: 0.5;
       text-decoration: none;
       font-size: 0.7em;
       margin-left: 8px;
     }
     div.document .headerlink:hover { opacity: 1; }
     div.document p { margin: 0 0 17px; }
     div.document strong { color: #1c231d; font-weight: 700; }
     div.document a { color: #7a2f3d; text-decoration: underline; text-decoration-color: #7a2f3d55; text-underline-offset: 2px; }
     div.document a:hover { text-decoration-color: #7a2f3d; }
     div.document ul, div.document ol { margin: 0 0 17px; padding-left: 26px; }
     div.document li { margin-bottom: 7px; }
     div.document hr { border: none; border-top: 1px solid #cdd6cc; margin: 40px 0; }

     div.document code.docutils.literal {
       font-family: ui-monospace, "SF Mono", Menlo, monospace;
       font-size: 0.86em;
       background: #f2f0ea;
       border: 1px solid #d8d4c8;
       color: #4a2f14;
       padding: 1px 5px;
       border-radius: 2px;
     }

     div.document div.highlight {
       background: #f2f0ea;
       border: 1px solid #d8d4c8;
       border-left: 3px solid #7a2f3d;
       border-radius: 0;
       padding: 14px 18px;
       margin: 4px 0 22px;
       overflow-x: auto;
     }
     div.document div.highlight pre {
       background: transparent;
       color: #2a2a24;
       font-family: ui-monospace, "SF Mono", Menlo, monospace;
       font-size: 0.86rem;
       line-height: 1.6;
       margin: 0;
     }
     div.document .highlight .c1 { color: #7a7266; font-style: italic; }
     div.document .highlight .k, div.document .highlight .kn, div.document .highlight .nb { color: #3d5c3d; font-weight: 600; }
     div.document .highlight .s1, div.document .highlight .s2 { color: #7a2f3d; }
     div.document .highlight .gp, div.document .highlight .gh { color: #7a2f3d; font-weight: 700; }
     div.document .highlight .nv, div.document .highlight .ss,
     div.document .highlight .vc, div.document .highlight .vg,
     div.document .highlight .vi, div.document .highlight .vm { color: #4a4470; }
     div.document .highlight .o, div.document .highlight .go { color: #6a6a5e; }

     div.document table.docutils {
       width: 100%;
       border-collapse: collapse;
       background: #ffffff;
       border: 1px solid #cdd6cc;
       margin: 6px 0 24px;
       font-size: 0.92rem;
       font-family: -apple-system, "Segoe UI", sans-serif;
     }
     div.document table.docutils th.head {
       text-align: left;
       padding: 9px 14px;
       font-size: 0.72rem;
       letter-spacing: 0.06em;
       text-transform: uppercase;
       color: #7a2f3d;
       border-bottom: 2px solid #7a2f3d;
       font-weight: 700;
     }
     div.document table.docutils td {
       padding: 9px 14px;
       border-bottom: 1px solid #cdd6cc;
       vertical-align: top;
     }
     div.document table.docutils tr.row-even { background: #f7f6f2; }
     div.document table.docutils tr.row-odd { background: transparent; }
     div.document table.docutils tr:last-child td { border-bottom: none; }

     div.document p.plantuml { text-align: center; margin: 30px 0; }
     div.document p.plantuml img {
       max-width: 100%;
       height: auto;
       background: #ffffff;
       border: 1px solid #cdd6cc;
       padding: 20px;
     }
   </style>

A curated reference sheet for daily developer workflows, including Docker
container management, Git operations, and advanced Linux file manipulation.

Docker Operations
--------------------

Container Operations
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

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

Image Management
~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Core operations
   docker pull <image>:<tag>      # Pull image from registry
   docker push <image>:<tag>      # Push image to registry
   docker build -t <name>:<tag> . # Build image from local Dockerfile
   docker tag <image_id> <new_name>:<tag>
   docker rmi <image>             # Remove local image

   # Export & Import tarballs
   docker save -o image.tar <image>:<tag>
   docker load -i image.tar

Cleanup & Pruning
~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Global cleanup (Use with care)
   docker system prune -a --volumes  # Remove ALL unused containers, networks, images, and volumes

   # Targeted cleanup
   docker container prune         # Remove all stopped containers
   docker image prune -a          # Remove all unused images
   docker volume prune            # Remove all unattached volumes
   docker network prune           # Remove all unused networks

   # Remove dangling items
   docker rmi $(docker images -f "dangling=true" -q)

Networks & Volumes
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

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

Git Version Control
-----------------------

Basic Operations
~~~~~~~~~~~~~~~~~~

.. code-block:: bash

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

Branch Management
~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

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

History & Diffs
~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Log Analysis
   git log --graph --oneline --decorate --all # Compact visualization of commit graph
   git log -p <file>              # Display commit history along with file diffs
   git log -S "<string>"          # Search commit history for specific code string
   git blame <file>               # Show author and commit info line-by-line

   # Inspecting Changes
   git diff                       # Unstaged changes vs staging area
   git diff --staged              # Staged changes vs last commit
   git diff <branch1>..<branch2>  # Compare differences between two branches

Stash Operations
~~~~~~~~~~~~~~~~~~

.. code-block:: bash

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

Advanced Git
~~~~~~~~~~~~~~

.. code-block:: bash

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

File Operations & Utilities
-------------------------------

Search & Find
~~~~~~~~~~~~~~~

.. code-block:: bash

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

File Transfer & Downloads
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

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

File Management & Duplicates
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Find duplicate files via SHA256 checksums
   find . -type f -exec sha256sum {} + | \
       sort | \
       uniq -w 64 --all-repeated=separate

   # Batch Renaming
   rename 's/\.txt$/\.md/' *.txt  # Rename all .txt files to .md
   rename 's/\s+/_/g' *           # Replace spaces with underscores in all filenames
