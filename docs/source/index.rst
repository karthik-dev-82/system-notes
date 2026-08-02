System Notes
===================

A curated collection of reference guides and revision notes -- Linux
internals, networking, containers, and whatever else is worth writing
down and coming back to.

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Guides

   bashrc_reference
   developer_commands
   system_monitoring_commands
   network_interfaces
   docker_dev_environment
   spdlog_sinks_architecture
   linux_devices
   kernel_networking_docker_internals
   lidar_slam
   ssh_secure_shell

Quick Navigation
-----------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 30 45

   * - Reference Guide
     - Primary Focus
     - Key Utilities Covered
   * - :doc:`bashrc_reference`
     - Interactive shell setup, aliases, and functions
     - ``.bashrc``, aliases, ``__setprompt``, ``ssh-agent``
   * - :doc:`system_monitoring_commands`
     - Performance, diagnostics & resource analysis
     - ``htop``, ``vmstat``, ``iotop``, ``iostat``, ``ss``, ``pidstat``
   * - :doc:`developer_commands`
     - Daily engineering workflows & tooling
     - ``docker``, ``git``, ``rsync``, ``aria2c``, ``find``, ``grep``
   * - :doc:`network_interfaces`
     - Linux network interfaces, explained with analogies & diagrams
     - ``eth0``, ``lo``, ``veth``, ``docker0``, VLANs, TUN/TAP, NAT
   * - :doc:`docker_dev_environment`
     - How the ``development`` repo's Docker dev container is built
     - ``Dockerfile``, ``devcontainer.json``, ``docker-compose.yml``
   * - :doc:`spdlog_sinks_architecture`
     - spdlog logging architecture, sinks, and log levels
     - ``spdlog``, sinks, formatters, log levels, rotation
   * - :doc:`linux_devices`
     - Block/char/network/terminal/pseudo devices, and USB layering
     - ``/dev``, ``lsblk``, ``ttyACM``/``ttyUSB``, ``udevadm``, PTYs
   * - :doc:`kernel_networking_docker_internals`
     - Kernel networking stack, Docker internals, iptables, OverlayFS
     - netfilter, namespaces, cgroups, veth, DNAT/MASQUERADE, overlay2
   * - :doc:`lidar_slam`
     - LIDAR and SLAM for navigation where GPS doesn't work
     - point clouds, localization, mapping, autonomous vehicles
   * - :doc:`ssh_secure_shell`
     - How the SSH handshake, encryption, and key auth actually work
     - key exchange, host keys, password vs. key auth, tunneling
