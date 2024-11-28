DOCKER commands
***************

1) Copying files from host to docker container.
   docker cp foo.txt mycontainer:/foo.txt

2) Docker Remove all unused containers, volumes, networks and images
   docker rm `docker ps --no-trunc -aq`

GIT commands
************
1) Show changes in a single git commit 
   git show --color --pretty=format:%b hash

2) Delete a git branch locally and remotely.
   git push --delete <remote_name> <branch_name>
   git branch -d <branch_name>

3) Git cherry-pick from another repo
   git remote add other https://example.link/repository.git
   git fetch other
   git cherry-pick commit_hash

4) git log for a specific development branch
   git log --graph --abbrev-commit --decorate  --first-parent <branch_name>

5) Stash a specific folder in git 
   git stash push -- /dir/to/folder/
   git stash apply

6) Update git submodule URL 
    git submodule update --init --recursive --rebase --force

7) Update git submodules in a single command
   rm -rf $(git submodule status | awk '{print $2}')  && git submodule update --init --recursive --rebase --force

8) Renaming Git Branch
  #Checkout old branch
  git checkout <old_name>
  #Rename local branch by typing
  git branch -m <new_name>
  #push the <new name> local branch and reset the upstream branch.
  git push origin -u <new_name>
  #Delete the <old_name> remote branch
  git push origin --delete <old_name>
    

GENERAL commands
****************
1. download large files from artifactory
aria2c -x 16 -s 1600 --min-split-size=2M --console-log-level=warn  http://usbalp-artfct01.cts.cubic.cub:8085/artifactory/C3E-Snapshots/Deployments/c3edeployment/feature/C3E-6420-ensure-that-backup-time-from-etc-timestamp-works-correctly/C3E-MSP-2.1.9-0-b7_feature_C3E_6420_ensure_that_backup_time_from_etc_timestamp_works_correctly.Ubuntu.tar.bz2

2. grep --include="*.*" -nRHI "C3EDdsFilterParameter" *

3. find duplicate files
find -type f -exec md5sum '{}' ';' | sort | uniq --all-repeated=separate -w 33 | cut -c 35-

4. Valgrind command
valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes --verbose --log-file=valgrind-out.txt ./executable exampleParam1

