Bash Miscellaneous
===================

A curated collection of practical reference guides, command-line cheat sheets,
and DevOps workflows for Linux administration, container management, version
control, and system diagnostics.

`Download this whole site as a single PDF <bash-miscellaneous.pdf>`_ --
handy for offline reading or revision.

.. note::
   The PDF is built and published alongside this site by
   `the CI workflow <https://github.com/karthik-dev-82/bash-miscellaneous/blob/main/.github/workflows/docs.yml>`_,
   not tracked as a source file, so this link only works on the deployed
   site (not in a local ``sphinx-build`` output unless you've run the PDF
   build yourself).

.. toctree::
   :maxdepth: 2
   :caption: Guides

   bashrc_reference
   developer_commands
   system_monitoring_commands
   network_interfaces

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
