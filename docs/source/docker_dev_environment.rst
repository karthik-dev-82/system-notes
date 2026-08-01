Docker Container Architecture Guide
=======================================

Understanding how the ``development`` repo's dev environment is built,
using plain-language analogies.

.. note::
   This page describes the setup in
   `karthik-dev-82/development <https://github.com/karthik-dev-82/development>`_
   specifically (``Dockerfile``, ``.devcontainer/devcontainer.json``, and
   ``docker-compose.yml``), verified directly against that repo -- not a
   generic Docker tutorial.

What is This?
------------------

Think of your Docker container like a custom-built treehouse -- it's your
perfect coding workspace that has everything you need, works the same way
every time, and can be rebuilt from scratch if needed.

The Big Picture
--------------------

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   skinparam roundcorner 15
   rectangle "Your Computer" as host {
     rectangle "VS Code" as vscode #LightBlue
     rectangle "Docker Engine" as docker #LightGreen
     rectangle "Your Project Files" as files #LightYellow {
       note right: src/, docs/, etc.
     }
   }
   rectangle "Docker Container" as container #LightCoral {
     rectangle "Ubuntu 24.04" as ubuntu #White
     rectangle "Development Tools" as tools #LightGray
     rectangle "Your Code (Mounted)" as code #LightYellow
   }
   vscode -down-> docker : "Opens container"
   docker -down-> container : "Runs"
   files -down-> code : "Shared/Mounted"
   vscode -down-> container : "Connects to"
   note bottom of container
     Everything you need:
     * C++ compiler (GCC 13, Clang 17)
     * Python 3 + venv
     * Node.js 20
     * ROS2 Jazzy
     * Rust toolchain
     * Libraries & tools
   end note

**Analogy:** Your computer is like a neighborhood, Docker is like a
construction company, and the container is your custom treehouse with all
your favorite tools inside.

.. code-block:: text

   Your Computer
   ├── Docker Engine (the actual container runtime)
   │   ├── Manages all containers
   │   ├── Builds images
   │   └── Runs containers
   │
   ├── VS Code
   │   └── Tells Docker Engine: "Build & run a container for me"
   │
   └── docker-compose.yml
       └── Tells Docker Engine: "Run these containers for me"

.. note::
   VS Code's ``.devcontainer/devcontainer.json`` points straight at the
   ``Dockerfile`` (``"dockerFile": "../Dockerfile"``) -- it does **not**
   reference ``docker-compose.yml`` at all. So opening this repo in VS
   Code only ever creates the one development container; it never starts
   the database containers from ``docker-compose.yml``. If you want those,
   you have to start them yourself (see :ref:`docker-compose-workflow`
   below).

The Three Main Files
-------------------------

1. Dockerfile - The Blueprint
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is like a recipe or instruction manual for building your container.

**What it does:**

* Starts with Ubuntu 24.04 (like choosing the foundation)
* Installs compilers, languages, and tools (adding rooms and furniture)
* Sets up the environment (decorating and organizing)

**Structure** (the real build order, in nine stages):

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   rectangle "Dockerfile Layers" {
     rectangle "1: Base -- Ubuntu 24.04" as base #E8F5E9
     rectangle "2: System packages + build tools" as system #FFF9C4
     rectangle "3: Debug/monitoring tools (gdb, htop, ...)" as debug #FFE0B2
     rectangle "4: Compilers -- GCC 13, Clang 17" as compilers #FFECB3
     rectangle "5: Node.js 20" as nodejs #C8E6C9
     rectangle "6: Modern CLI tools (ripgrep, tmux, ...)" as cli #DCEDC8
     rectangle "7: ROS2 Jazzy (ros-base)" as ros2 #B2DFDB
     rectangle "8: C++ libraries (Boost, gRPC, ...)" as cpp_libs #F8BBD0
     rectangle "9: Python venv + Rust/Cargo tools" as pyrust #CE93D8
   }
   base -down-> system
   system -down-> debug
   debug -down-> compilers
   compilers -down-> nodejs
   nodejs -down-> cli
   cli -down-> ros2
   ros2 -down-> cpp_libs
   cpp_libs -down-> pyrust
   note right of pyrust
     Each layer builds on
     the previous one,
     like stacking blocks!
     A change to one layer
     only invalidates the
     cache from there down.
   end note

**Key sections explained:**

*Layer 1: Foundation (Ubuntu)*

.. code-block:: dockerfile

   FROM ubuntu:24.04

Analogy: choosing the foundation of your treehouse -- Ubuntu 24.04 is a
stable, modern base.

*Layer 2-3: Essential and debugging tools*

.. code-block:: dockerfile

   RUN apt-get install build-essential cmake ninja-build git curl
   RUN apt-get install gdb valgrind strace htop net-tools

Analogy: installing basic tools -- hammer, nails, saw, and a flashlight
for when something goes wrong.

*Layer 4: Modern compilers*

.. code-block:: dockerfile

   RUN apt-get install gcc-13 g++-13 clang-17 libc++-17-dev

Analogy: getting the latest power tools that understand modern C++23
features.

*Layer 5: Node.js*

.. code-block:: bash

   curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

Analogy: adding a JavaScript workshop to your treehouse.

*Layer 7: ROS2*

.. code-block:: dockerfile

   RUN apt-get install ros-jazzy-ros-base python3-rosdep python3-colcon-common-extensions

Analogy: installing a robotics lab in your workspace.

.. note::
   **Correction:** this installs ``ros-jazzy-ros-base``, the minimal
   headless ROS2 package set -- not ``ros-jazzy-desktop``. That matters
   because ``ros-base`` does **not** include GUI tools like ``rviz2`` or
   ``rqt``. If you need those, they'd have to be added separately; don't
   assume they're already in the container.

*Layer 8: C++ libraries*

.. code-block:: dockerfile

   RUN apt-get install libboost-all-dev libgrpc++-dev libgtest-dev \
       libspdlog-dev libopencv-dev libeigen3-dev nlohmann-json3-dev

Analogy: stocking your workshop with pre-made parts you can use in your
projects.

*Layer 9: Python environment and Rust*

.. code-block:: dockerfile

   RUN python3 -m venv /opt/python-dev \
       && /opt/python-dev/bin/pip install pytest black mypy poetry numpy pandas fastapi
   RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

.. note::
   **Addition -- this is missing from the original notes entirely:** the
   ``Dockerfile`` also installs the full Rust toolchain via ``rustup``,
   then uses ``cargo`` to build several modern CLI tools: ``bat``, ``eza``,
   ``bottom``, ``procs``, ``dust``, ``delta``, and ``hyperfine``. The
   generated ``~/.bashrc`` then aliases the classics over to them --
   ``cat`` → ``bat``, ``ls``/``la``/``l`` → ``eza``, ``find`` → ``fd``,
   ``grep`` → ``rg``, ``ps`` → ``procs``, ``top`` → ``bottom``. If a
   command feels unusually fast or colorful in this container, that's why.

2. devcontainer.json - The Configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This tells VS Code how to use the container and what extras to add.

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   package "devcontainer.json" {
     rectangle "Container Settings" as settings #E3F2FD
     rectangle "VS Code Extensions (30+)" as extensions #F3E5F5
     rectangle "Post-Create Scripts" as scripts #E8F5E9
   }
   note right of settings
     * Which Dockerfile to use
     * Network settings
     * Security options
   end note
   note right of extensions
     * C++ IntelliSense
     * Python tools
     * ROS2, Git, Docker
     * RST/PlantUML support
   end note
   note right of scripts
     * fix-dns.sh (runs FIRST)
     * setup-git.sh
     * fix-permissions.sh
     * npm install
   end note
   settings -down-> extensions
   extensions -down-> scripts

**Key parts:**

*Docker settings*

.. code-block:: json

   "dockerFile": "../Dockerfile",
   "runArgs": [
     "--privileged",
     "--network=host",
     "--cap-add=SYS_PTRACE",
     "--security-opt=seccomp:unconfined"
   ]

Analogy: telling the construction crew where the blueprint is and giving
them special permissions (like letting them access the neighborhood
internet directly, or attach a debugger to any process).

*Extensions (a handful of the 30+ actually configured)*

.. code-block:: json

   "extensions": [
     "ms-vscode.cpptools",
     "ms-python.python",
     "ms-vscode.cmake-tools",
     "ms-iot.vscode-ros2",
     "eamodio.gitlens"
   ]

Analogy: installing special gadgets in your treehouse -- a C++ reading
lamp, Python toolbox, CMake workbench, and a robotics corner.

*Post-create command*

The real ``postCreateCommand`` is a single chained script, and **order
matters**:

.. code-block:: bash

   ./.devcontainer/fix-dns.sh && \
   ./.devcontainer/setup-git.sh && \
   ./.devcontainer/fix-permissions.sh && \
   sudo apt-get install -y ros-jazzy-std-srvs libspdlog-dev && \
   npm install --silent

Analogy: final touches after building -- but you have to fix the phone
line (DNS) before you can call anyone (fetch packages), which is why
that step runs first.

.. _docker-compose-workflow:

3. docker-compose.yml - The Neighborhood Plan
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This can run multiple containers together (like having different
buildings in your neighborhood) -- separately from whatever VS Code is
doing.

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   top to bottom direction
   package "Docker Compose Services" {
     rectangle "dev-environment\n(container: dev-container)" as dev #81C784
     note right of dev
       Main workspace, no
       Compose "profile" --
       starts by default
     end note
     rectangle "postgres\n(container: dev-postgres)" as postgres #64B5F6
     note right of postgres
       profile: database
       opt-in only!
     end note
     rectangle "redis\n(container: dev-redis)" as redis #FFB74D
     note right of redis
       profile: cache
       opt-in only!
     end note
     rectangle "mongodb\n(container: dev-mongodb)" as mongo #BA68C8
     note right of mongo
       profile: mongodb
       opt-in only!
     end note
   }
   dev --> postgres : Can reach via\nlocalhost (host networking)
   dev --> redis : Can reach via\nlocalhost (host networking)
   dev --> mongo : Can reach via\nlocalhost (host networking)

.. note::
   **Correction:** the compose file's main service is named
   ``dev-environment`` and its ``container_name`` is ``dev-container`` --
   *not* "development." Also, ``postgres``, ``redis``, and ``mongodb`` are
   each gated behind a Compose ``profiles:`` entry, so they are **opt-in**:
   a bare ``docker-compose up`` only starts ``dev-environment``. You need
   either ``docker-compose --profile database up`` or to name the service
   explicitly (``docker-compose up -d postgres``) to bring one up. And
   because ``dev-environment`` runs with ``network_mode: host``, it talks
   to the database containers over ``localhost:<port>``, not via Compose's
   internal service-name DNS.

Analogy: your treehouse (dev container) is the main building, but you can
add separate buildings for storage (databases) that all connect via paths
(network) -- except none of those extra buildings get built unless you
explicitly ask for them.

How It All Works Together
------------------------------

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   actor "You" as user
   participant "VS Code" as vscode #LightGreen
   participant "Docker" as docker #LightBlue
   participant "Container" as container #LightSalmon
   participant "Your Files" as files #GreenYellow
   user -> vscode : Open project folder
   vscode -> vscode : Detect .devcontainer/
   vscode -> user : "Reopen in Container?"
   user -> vscode : Click "Reopen"
   vscode -> docker : Read Dockerfile
   docker -> docker : Build image (if needed)
   note right: Uses cached layers\nfor speed!
   docker -> container : Create container
   container -> container : fix-dns.sh, setup-git.sh,\nfix-permissions.sh
   container -> files : Mount project files
   vscode -> container : Connect
   vscode -> vscode : Install extensions
   vscode -> user : Ready!
   note over container
     Now your code is
     inside the container,
     but you edit it in
     VS Code normally!
   end note

**Step-by-step flow:**

1. You open VS Code in your project folder
2. VS Code notices ``.devcontainer/devcontainer.json``
3. You click "Reopen in Container"
4. Docker reads the ``Dockerfile`` blueprint
5. Docker builds the container (uses cache if nothing changed)
6. Container starts and runs ``fix-dns.sh``, then ``setup-git.sh``, then
   ``fix-permissions.sh``
7. Your files are mounted (shared) into the container
8. VS Code connects to the container
9. Extensions install automatically
10. You're ready to code

Container Layers (The Cake Analogy)
----------------------------------------

Think of the Docker image as a layer cake:

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   rectangle "Docker Image Layers" {
     rectangle "Layer 9: Python venv + Rust" as l9 #FFEB3B
     rectangle "Layer 8: C++ Libraries" as l8 #FFC107
     rectangle "Layer 7: ROS2" as l7 #FF9800
     rectangle "Layer 6: Modern CLI Tools" as l6 #FF5722
     rectangle "Layer 5: Node.js" as l5 #F44336
     rectangle "Layer 4: Compilers" as l4 #E91E63
     rectangle "Layer 3: Debug Tools" as l3 #9C27B0
     rectangle "Layer 2: System Packages" as l2 #673AB7
     rectangle "Layer 1: Ubuntu Base" as l1 #512DA8
   }
   l9 -down-> l8
   l8 -down-> l7
   l7 -down-> l6
   l6 -down-> l5
   l5 -down-> l4
   l4 -down-> l3
   l3 -down-> l2
   l2 -down-> l1
   note right of l1
     Each layer is
     cached separately.

     If you change Layer 8,
     only 8-9 rebuild!

     Layers 1-7 are reused
     from cache = FAST!
   end note

**Why layers matter:**

* **Caching:** unchanged layers don't rebuild (saves time!)
* **Sharing:** multiple containers can share base layers (saves space!)
* **Debugging:** can see exactly what changed

File System: Where Everything Lives
----------------------------------------

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   folder "/" as root {
     folder "home" {
       folder "developer" {
         folder "workspace" #FFEB3B
       }
     }
     folder "opt" {
       folder "ros/jazzy" #E3F2FD
       folder "python-dev" #FFF9C4
     }
     folder "usr" {
       folder "bin" {
         file "g++" #E8F5E9
         file "python3" #E8F5E9
         file "node" #E8F5E9
       }
       folder "lib"
     }
   }
   note right of workspace
     YOUR PROJECT FILES
     (mounted from host)
   end note
   note right of lib
     Libraries like
     Boost, gRPC
   end note
   note bottom of root
     The "workspace" folder is special:
     it's YOUR files from your computer,
     shared with the container!

     Changes here affect BOTH places!
   end note

**Key paths** (all verified against the actual ``Dockerfile`` and
``docker-compose.yml``):

* ``/home/developer/workspace`` → your project files (mounted/shared)
* ``/opt/ros/jazzy`` → ROS2 installation
* ``/opt/python-dev`` → the Python virtualenv with pytest, black, poetry,
  numpy, pandas, fastapi, etc.
* ``/usr/bin`` → compilers and tools (``g++``, ``python3``, ``node``)
* ``/usr/lib`` → libraries (Boost, gRPC, etc.)

How File Mounting Works
----------------------------

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   rectangle "Your Computer" as host {
     folder "project/" as host_project #FFF9C4 {
       file "main.cpp"
       file "README.md"
       folder "src/"
     }
   }
   rectangle "Docker Container" as container {
     folder "/home/developer/workspace/" as container_workspace #FFF9C4 {
       file "main.cpp"
       file "README.md"
       folder "src/"
     }
   }
   host_project <-down-> container_workspace : "Mounted\n(Synchronized)"
   note bottom of container_workspace
     MAGIC: These are the
     SAME files!

     Edit in VS Code -> Changes instantly
     appear in container

     Compile in container -> Output
     appears on your computer
   end note

Analogy: it's like having a magic window between your room and your
treehouse -- whatever you put on the desk appears in both places!

Important Container Settings
---------------------------------

Network Mode: ``--network=host``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   rectangle "Your Computer Network" as host_network {
     cloud "Internet" as internet
     rectangle "localhost:3000" as host_port
   }
   rectangle "Container" as container {
     rectangle "App listening\non port 3000" as app
   }
   internet <-down-> host_port
   host_port <-down-> app : "Direct access\n(host mode)"
   note right of container
     With --network=host:
     Container uses your computer's
     network directly.

     localhost:3000 in container =
     localhost:3000 on your computer!
   end note

Privileged Mode: ``--privileged``
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Analogy: giving the container a "master key" -- it can do special things
like access USB devices, run Docker inside Docker, or attach a debugger
with full system access.

**Important:** only use this in development, not in production!

DNS Settings
~~~~~~~~~~~~~~

.. note::
   **Correction -- this was flat-out backwards in the original notes.**
   The container does **not** use ``--dns=8.8.8.8``/``--dns=1.1.1.1``
   flags. ``devcontainer.json`` says so explicitly in a comment: those
   flags are silently *ignored* by Docker once ``--network=host`` is set.
   DNS is instead fixed by a dedicated ``.devcontainer/fix-dns.sh`` script,
   which runs **first** in ``postCreateCommand`` -- before ``setup-git.sh``
   or anything that needs to reach the network -- because, as the repo's
   own comment puts it, "everything else depends on working DNS."

Analogy: rather than handing the container a couple of phone numbers to
try, the setup script rewires its phone line directly so it can dial out
at all.

The Complete Startup Sequence
----------------------------------

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   start
   :You: Open VS Code;
   :VS Code: Detect devcontainer.json;
   if (Container image exists?) then (no)
     :Docker: Read Dockerfile;
     :Docker: Build image\n(layer by layer);
     note right
       First time: several minutes
       Next time: cached!
     end note
   else (yes)
     :Docker: Use cached image;
   endif
   :Docker: Create container from image;
   :Docker: Mount your project files;
   :Container: Start Ubuntu;
   fork
     :Run: fix-dns.sh;
     :Fix DNS resolution FIRST;
   fork again
     :Run: setup-git.sh;
     :Configure Git username/email;
   fork again
     :Run: fix-permissions.sh;
     :Fix file ownership;
   end fork
   :Run: npm install;
   :VS Code: Connect to container;
   :VS Code: Install extensions;
   :Ready to code!;
   stop

.. note::
   The original notes showed ``fix-dns.sh``, ``setup-git.sh``, and
   ``fix-permissions.sh`` as running in parallel (fork/join), same as
   above. In the real ``postCreateCommand`` they're actually chained with
   ``&&`` in a strict sequence (DNS, then git, then permissions, then
   package installs, then ``npm install``) -- because DNS has to work
   before anything that touches the network can run. The diagram keeps
   the fork for readability, but treat the real order as sequential.

What Gets Installed
------------------------

C++ Development
~~~~~~~~~~~~~~~~~~

* GCC 13 (C++23 support)
* Clang 17 (alternative compiler)
* CMake + Ninja (build system)
* Boost libraries (utilities)
* gRPC + Protocol Buffers (networking)
* Google Test / Google Mock (testing)
* spdlog + fmt (logging)
* OpenCV, Eigen3 (math/vision)
* clang-format, clang-tidy, cppcheck (code quality)

Python Development
~~~~~~~~~~~~~~~~~~~~~

* Python 3 in a dedicated venv at ``/opt/python-dev``
* pytest, mypy, black, isort
* Poetry (dependency management)
* NumPy, Pandas, Matplotlib, Jupyter
* FastAPI, Flask, SQLAlchemy

Node.js Development
~~~~~~~~~~~~~~~~~~~~~~

* Node.js 20 (via NodeSource)
* npm
* TypeScript, ts-node, nodemon

ROS2 Robotics
~~~~~~~~~~~~~~~~

* ROS2 Jazzy -- ``ros-jazzy-ros-base`` (headless; **no** rviz2/rqt by
  default -- see the correction above)
* colcon (build tool)
* rosdep (dependencies)

Rust & Modern CLI Tools
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::
   This entire category was missing from the original notes.

* Rust toolchain via ``rustup``
* ``bat`` (better ``cat``), ``eza`` (better ``ls``), ``bottom`` (better
  ``top``), ``procs`` (better ``ps``), ``dust`` (disk usage), ``delta``
  (better diffs), ``hyperfine`` (benchmarking)
* Aliased over the originals in ``~/.bashrc``: ``cat``/``ls``/``find``/
  ``grep``/``ps``/``top`` all quietly point at the Rust versions

Key Concepts to Remember
-----------------------------

1. Images vs Containers
~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   rectangle "Dockerfile" as dockerfile #FFF9C4
   rectangle "Docker Image" as image #E3F2FD
   rectangle "Docker Container" as container #C8E6C9
   dockerfile -down-> image : "docker build"
   image -down-> container : "docker run"
   note right of dockerfile
     Blueprint/Recipe
   end note
   note right of image
     Built from Dockerfile
     Like a frozen snapshot
     Read-only
   end note
   note right of container
     Running instance of image
     Like a live environment
     Can change
   end note
   note bottom of container
     Image = Cookie cutter
     Container = Actual cookie

     One image, many containers!
   end note

2. Volumes (File Sharing)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   Host Computer          Container
   ─────────────         ──────────
   project/      <──────> /home/developer/workspace/
      main.cpp              main.cpp

   Same file, two views!

3. Layers (Caching)
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   Changed something in Layer 8 of the Dockerfile?
   Layers 1-7: Reused (fast!)
   Layers 8-9: Rebuilt

   This is why layer order matters!

Summary
------------

Your Docker container is:

* Built from a ``Dockerfile`` (the blueprint)
* Configured by ``devcontainer.json`` (the settings)
* Optionally paired with ``docker-compose.yml`` (separate services --
  opt-in, not automatic)
* Sharing your project files via mounting
* Isolated from your main computer
* Reproducible -- same every time
* Fast, due to layer caching

**Benefits:**

* Works the same on everyone's computer
* No "it works on my machine" problems
* Easy to reset (just rebuild!)
* All tools pre-installed
* Isolated (won't mess up your computer)

Quick Reference
--------------------

**Starting the container** (in VS Code):

1. Open project
2. Press ``F1``
3. Type "Reopen in Container"
4. Press Enter
5. Wait for build (first time only)

**Rebuilding** (if you change the ``Dockerfile``):

1. Press ``F1``
2. Type "Rebuild Container"
3. Press Enter

**Viewing containers:**

.. code-block:: bash

   # See running containers
   docker ps

   # Enter container shell
   docker exec -it dev-container bash

Common Questions
---------------------

**Q: Why does the first build take so long?**
A: Building all layers from scratch. Next time: cached = fast!

**Q: Will my files be lost if I stop the container?**
A: No! Your project files are on your computer, just shared with the
container.

**Q: Can I use multiple terminals?**
A: Yes! Each terminal in VS Code connects to the same container.

**Q: What if I break something?**
A: Just rebuild the container -- it resets to the ``Dockerfile``!

VS Code Devcontainer vs Docker Compose
-------------------------------------------

**Understanding two different workflows**

When you work with this project, you have two separate ways to run
Docker containers. This often causes confusion!

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   package "Your Project Files" {
     file ".devcontainer/\ndevcontainer.json" as devconfig #E3F2FD
     file "Dockerfile" as dockerfile #FFF9C4
     file "docker-compose.yml" as compose #FFE0B2
   }
   package "Workflow 1: VS Code Devcontainer" {
     rectangle "VS Code" as vscode1 #81C784
     rectangle "vsc-development-xxx\n(Auto-created)" as vsc_container #C8E6C9
     devconfig -down-> vscode1
     dockerfile -down-> vscode1
     vscode1 -down-> vsc_container : "Creates & manages"
   }
   package "Workflow 2: Docker Compose" {
     rectangle "docker-compose up" as compose_cmd #FF8A65
     rectangle "dev-container\n(service: dev-environment)" as dev_container #FFCCBC
     rectangle "dev-postgres\n(profile: database)" as postgres #FFCCBC
     rectangle "dev-redis\n(profile: cache)" as redis #FFCCBC
     compose -down-> compose_cmd
     compose_cmd -down-> dev_container : "Starts (default)"
     compose_cmd -down-> postgres : "Only with\n--profile database"
     compose_cmd -down-> redis : "Only with\n--profile cache"
   }
   note right of vsc_container
     This is what you use
     when coding in VS Code!
   end note
   note right of dev_container
     This is separate!
     Not used by VS Code
     by default
   end note

Workflow 1: VS Code Devcontainer (what you're likely using)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you do this:

.. code-block:: bash

   cd /path/to/project
   code .
   # Click "Reopen in Container"

**What happens:**

1. VS Code reads ``.devcontainer/devcontainer.json``
2. Builds from your ``Dockerfile``
3. Creates a new container with a name like ``vsc-development-abc123``
4. Installs VS Code extensions inside
5. Mounts your project files
6. You code inside this container

Container name pattern: ``vsc-*`` (managed by VS Code).

To see it:

.. code-block:: bash

   docker ps --filter "name=vsc-"

Workflow 2: Docker Compose (separate services)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you do this:

.. code-block:: bash

   docker-compose up -d

**What actually happens:** only the ``dev-environment`` service starts
(container name ``dev-container``) -- because it's the only service
without a ``profiles:`` entry. ``postgres``, ``redis``, and ``mongodb``
each require their profile to be enabled, or the service to be named
explicitly:

.. code-block:: bash

   # Starts nothing extra beyond dev-environment
   docker-compose up -d

   # Starts postgres too, by naming it explicitly
   docker-compose up -d postgres

   # Or enable a whole profile
   docker-compose --profile database up -d

Container names: ``dev-container``, ``dev-postgres``, ``dev-redis``,
``dev-mongodb`` (all defined in ``docker-compose.yml``).

Why Your Docker Desktop Shows the Compose Containers as Stopped
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is normal! Here's why:

.. uml::

   !theme plain
   skinparam backgroundColor #FEFEFE
   rectangle "Docker Desktop View" {
     rectangle "vsc-development-abc123\n(RUNNING)" as vsc #C8E6C9
     rectangle "dev-container\n(STOPPED)" as dev #FFCDD2
     rectangle "dev-postgres\n(STOPPED)" as postgres #FFCDD2
     rectangle "dev-redis\n(STOPPED)" as redis #FFCDD2
   }
   actor "You Coding\nin VS Code" as user
   user -down-> vsc : "Connected here"
   note right of vsc
     This is your actual
     development container!

     Created by VS Code
     Has all your tools
     You're coding here
   end note
   note right of dev
     This container is NOT used
     by VS Code's devcontainer flow!

     It's from docker-compose.yml
     Only starts with:
     docker-compose up
   end note

**Key insight:** VS Code creates its own container (``vsc-*``) and
doesn't use the ``dev-environment`` service from ``docker-compose.yml``.
Both can exist, but they serve different purposes -- and the database
services need their profile enabled before they'll even attempt to start.

Which Workflow Should You Use?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Use VS Code Devcontainer when:**

* You want seamless VS Code integration
* You're coding and need IntelliSense, debugging
* You want automatic extension installation
* You don't need to run services independently

Command: just ``code .`` and click "Reopen in Container".

**Use Docker Compose when:**

* You need database services (PostgreSQL, Redis, MongoDB)
* You want to run services without VS Code
* You're testing multi-container applications
* You need services available to other applications

Command: ``docker-compose --profile database --profile cache up -d``.

**Use both when** you're coding in VS Code *and* need databases running
alongside:

.. code-block:: bash

   # 1. Start the services you need (profiles required!)
   docker-compose --profile database --profile cache up -d

   # 2. Open VS Code
   code .
   # Click "Reopen in Container"

   # Now you have:
   # - VS Code container for development
   # - Database services running alongside, reachable via localhost

Checking What's Running
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # See VS Code's container
   docker ps --filter "name=vsc-"

   # See docker-compose containers
   docker-compose ps

   # See ALL containers
   docker ps -a

Making VS Code Use Docker Compose Instead
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you want VS Code to attach to the Compose-managed service instead of
building its own container, edit ``.devcontainer/devcontainer.json``:

.. code-block:: json

   {
     "name": "Development Environment",

     "dockerComposeFile": "../docker-compose.yml",
     "service": "dev-environment",
     "workspaceFolder": "/home/developer/workspace",

     "customizations": {
       "vscode": {
         "extensions": []
       }
     }
   }

Then rebuild (``F1`` → "Rebuild Container"). Now VS Code uses the
``dev-environment`` service directly, instead of building a separate
``vsc-*`` container from the plain ``Dockerfile``.

Quick Comparison
~~~~~~~~~~~~~~~~~~~

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 35 40

   * - Feature
     - VS Code Devcontainer
     - Docker Compose
   * - Container name
     - ``vsc-development-*``
     - ``dev-container``, ``dev-postgres``, etc.
   * - Started by
     - VS Code
     - ``docker-compose up`` (databases need ``--profile``)
   * - Purpose
     - Coding environment
     - Services & infrastructure
   * - VS Code integration
     - Automatic
     - Manual attach required
   * - Extensions
     - Auto-installed
     - Manual setup
   * - Multiple services
     - Single container
     - Many containers (opt-in via profiles)
   * - Can run together?
     - Yes
     - Yes

Common Scenarios
~~~~~~~~~~~~~~~~~~~

**"I just want to code":**

.. code-block:: bash

   code .
   # Click "Reopen in Container"
   # Done!

**"I need a database while coding":**

.. code-block:: bash

   # Start database (profile required)
   docker-compose up -d postgres

   # Then code
   code .
   # Click "Reopen in Container"
   # Both running!

**"I want everything in docker-compose":**

.. code-block:: bash

   # Option A: point devcontainer.json at docker-compose.yml (see above)
   # Option B: just use docker-compose directly, with the profiles you need
   docker-compose --profile database --profile cache --profile mongodb up -d
   # Then attach VS Code to the running container:
   # Extensions > Docker > right-click container > "Attach VS Code"

Troubleshooting
~~~~~~~~~~~~~~~~~~

**"I don't see my VS Code container in Docker Desktop!"**

Docker Desktop's UI sometimes doesn't prominently show devcontainers.
Check manually:

.. code-block:: bash

   docker ps --filter "name=vsc-"

**"Why is 'dev-container' stopped if I'm coding?"**

Because VS Code created a different container (``vsc-*``). The
``dev-container`` service from ``docker-compose.yml`` isn't being used
unless you started it yourself. This is normal.

**"Can I see what's inside the VS Code container?"**

Yes. Get the container name first, then exec into it:

.. code-block:: bash

   docker ps --filter "name=vsc-"
   docker exec -it vsc-development-abc123 bash

**"How do I stop the VS Code container?"**

Either close the VS Code window, or click "Reopen Folder Locally" in VS
Code. The container stops automatically when VS Code disconnects.

Summary
~~~~~~~~~

* VS Code's devcontainer flow creates its own container (``vsc-*``)
* ``docker-compose`` creates separate service containers
  (``dev-container``, and the databases *only if their profile is
  enabled*)
* Both can run simultaneously -- they don't conflict
* The compose-managed ``dev-container`` being stopped while you code is
  normal
* You're coding in the ``vsc-*`` container, not ``dev-container``

Development vs Deployment Containers
-----------------------------------------

**Simple answer: this repo only has development containers right now.**

.. code-block:: text

   Current Setup:
   ├── Development Container (VS Code creates this: vsc-development-*)
   │   └── Has: all dev tools, compilers, debuggers, testing frameworks
   │
   └── Optional Service Containers (from docker-compose, profile-gated)
       ├── dev-postgres (database for development)
       ├── dev-redis (cache for development)
       └── dev-mongodb (document db for development)

All of these are for development only -- they're heavy, feature-rich, and
designed for building or testing code. There is no separate production
``Dockerfile`` in the repo.

The Two-Container Analogy
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Think of it like a kitchen:

**Development container = professional kitchen**

* Every tool imaginable
* All the ingredients
* Recipe books
* Huge workspace
* Typical size: several GB

**Deployment container (hypothetical -- doesn't exist yet here) = food
delivery box**

* Only the finished dish
* Minimal packaging
* No cooking tools
* Just what's needed to serve
* Typical size: tens to a couple hundred MB

Key Differences
~~~~~~~~~~~~~~~~~~

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 40 40

   * - Aspect
     - Development Container
     - Deployment Container
   * - Purpose
     - Build, test, debug code
     - Run production app
   * - Size
     - Several GB
     - Tens to ~200 MB
   * - Contains
     - Compilers, dev tools, tests
     - Only compiled app + runtime
   * - Security
     - Privileged mode, full access
     - Restricted, hardened
   * - Who uses it
     - You, the developer
     - End users / production servers

Bottom Line
~~~~~~~~~~~~~

* You currently have: development containers only
* You don't have: deployment/production containers
* This is normal: most projects start with a dev-only setup
* When needed: add production Dockerfiles later, once ready to deploy
