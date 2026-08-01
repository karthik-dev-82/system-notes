Personal Notes
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
