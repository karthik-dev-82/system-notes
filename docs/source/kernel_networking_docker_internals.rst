Linux Kernel Networking, Docker, iptables & OverlayFS
==========================================================

A bite-sized guide covering how networking works inside the Linux
kernel, how Docker containers run, how filesystems and networks
interact, and the inspection tools (``tcpdump``, ``netstat``) plus deep
dives into ``iptables`` and OverlayFS.

.. seealso::
   :doc:`network_interfaces` covers the veth/bridge/NAT basics from the
   networking side; this page focuses on the kernel mechanics
   underneath (netfilter chains, OverlayFS internals) and on
   :doc:`docker_dev_environment`'s companion piece, container internals.

1. Linux Kernel Networking -- The Post Office Analogy
----------------------------------------------------------

Think of the kernel as a giant post office inside your computer.

**The journey of a packet (incoming):**

1. **NIC** (Network Interface Card) -- the mailbox on your street.
   Receives raw electrical signals.
2. **Device Driver** -- the postman who picks up mail from the mailbox
   and brings it inside.
3. **Network Stack (TCP/IP layers)** -- the sorting room. Each layer
   peels off one envelope:

   * Link layer (Ethernet) -- checks the street address
   * IP layer -- checks the city/country
   * TCP/UDP layer -- checks which apartment (port)

4. **Socket** -- the mailbox of a specific app (e.g., Chrome, SSH).
5. App reads data via system calls like ``recv()``.

Outgoing is the same in reverse -- app writes to socket, kernel adds
envelopes, NIC sends signals out.

.. uml::

   !theme plain
   skinparam defaultFontSize 12
   rectangle "Application (Chrome)" as App #LightGreen
   rectangle "Socket" as Sock #LightBlue
   rectangle "TCP / UDP Layer" as L4 #LightBlue
   rectangle "IP Layer" as L3 #LightBlue
   rectangle "Ethernet Layer" as L2 #LightBlue
   rectangle "Device Driver" as Drv #LightSalmon
   rectangle "NIC Hardware" as NIC #LightSalmon
   rectangle "Outside Network" as Net #GreenYellow
   App <--> Sock
   Sock <--> L4
   L4 <--> L3
   L3 <--> L2
   L2 <--> Drv
   Drv <--> NIC
   NIC <--> Net
   note right of L4
     Ports live here
     (e.g., 80, 443, 22)
   end note
   note right of L3
     IP addresses live here
     Routing decisions made
   end note

2. How Docker Runs Inside the Kernel
------------------------------------------

**Key idea:** a Docker container is NOT a mini-VM. It's just a regular
Linux process wearing a costume.

The kernel uses two main tricks:

Namespaces -- "The Illusion Glasses"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each container gets its own private view of the system. Like giving
someone glasses that show only their own room, even though they're in a
shared house.

Types of namespaces:

* **PID namespace** -- sees only its own processes
* **NET namespace** -- its own network interfaces, IP, routes
* **MNT namespace** -- its own filesystem mounts
* **UTS namespace** -- its own hostname
* **IPC, USER** -- its own users, message queues

.. note::
   Two more namespace types exist on modern kernels -- **Cgroup**
   (isolates the view of cgroup hierarchies) and **Time** (lets a
   container have its own boot/monotonic clock offsets, since Linux
   5.6). They're real, just less central to how Docker isolates a
   container day-to-day than the six above.

Cgroups -- "The Resource Meter"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Limits how much CPU, RAM, disk I/O each container can use. Like a power
strip with a circuit breaker per outlet.

.. uml::

   !theme plain
   rectangle "Linux Kernel (shared by all)" as Kernel #LightSalmon
   rectangle "Container A Process" as CA #LightGreen
   rectangle "Container B Process" as CB #LightBlue
   rectangle "Host Process" as Host #GreenYellow
   CA --> Kernel
   CB --> Kernel
   Host --> Kernel
   note top of CA
     Sees only its own:
     PIDs, network, files
     (via namespaces)
   end note
   note top of CB
     Different namespace
     Different illusion
   end note
   note bottom of Kernel
     ONE kernel for everyone
     No virtualization
     cgroups limit resources
   end note

3. Filesystem in Containers
--------------------------------

Layered cake analogy:

* **Base image** (e.g., Ubuntu) = bottom layer, read-only
* **App layer** (your code) = middle layer, read-only
* **Container writable layer** = top layer, the only one you can write
  to

Uses OverlayFS -- the kernel merges these layers so the container sees
one filesystem. Changes only go to the top layer (copy-on-write -- like
tracing paper on top of a book).

**Volumes** = a tunnel from the host filesystem into the container,
bypassing the layers. Useful for databases.

(Deep internals covered in :ref:`overlayfs-internals` below.)

4. Container Networking
----------------------------

Each container has its own NET namespace (its own private network
stack). To talk to the world:

* Docker creates a virtual ethernet pair (**veth**) -- like a magic pipe
  with two ends.
* One end goes inside the container (looks like ``eth0``).
* The other end attaches to a bridge (``docker0``) on the host -- a
  virtual switch.
* The host uses ``iptables`` NAT to translate container IPs ↔ host IP
  for outside traffic.

.. uml::

   !theme plain
   rectangle "Container A\n(eth0: 172.17.0.2)" as CA #LightGreen
   rectangle "Container B\n(eth0: 172.17.0.3)" as CB #LightBlue
   rectangle "docker0 bridge\n(virtual switch)" as Bridge #LightSalmon
   rectangle "Host eth0\n(real NIC)" as HostNIC #GreenYellow
   rectangle "Internet" as Net
   CA <--> Bridge : veth pair
   CB <--> Bridge : veth pair
   Bridge <--> HostNIC : iptables NAT
   HostNIC <--> Net
   note right of Bridge
     All containers
     plug in here
     like a switch
   end note
   note bottom of HostNIC
     NAT rewrites
     source IP so
     outside world
     sees host IP
   end note

5. Inspection Tools
------------------------

netstat (or modern ss) -- "Who's on the phone?"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Shows current network connections, listening ports, and which process
owns them.

.. code-block:: bash

   netstat -tulnp      # TCP/UDP listening ports with PID
   ss -tulnp           # modern, faster equivalent

**Analogy:** a list of every phone line in the building -- which
extensions are active, who's calling whom, and which employee is on the
line.

Common columns:

* **Proto** -- TCP or UDP
* **Local Address** -- your side
* **Foreign Address** -- the other side
* **State** -- ``LISTEN``, ``ESTABLISHED``, ``TIME_WAIT``
* **PID/Program** -- which process

tcpdump -- "Wiretap the post office"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Captures actual packets going through a network interface. Shows the
real letters being delivered.

.. code-block:: bash

   tcpdump -i eth0                    # watch eth0
   tcpdump -i any port 80             # only HTTP traffic
   tcpdump -i docker0 -nn             # watch container traffic
   tcpdump -w capture.pcap            # save for Wireshark

**Analogy:** standing at the post office sorting room and reading every
envelope as it passes through.

Quick comparison:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 40 40

   * - Tool
     - What it shows
     - Analogy
   * - ``netstat``/``ss``
     - Connection state (snapshot)
     - Phone directory
   * - ``tcpdump``
     - Actual packets (live stream)
     - Wiretap

6. iptables -- The Kernel's Bouncer System
------------------------------------------------

**Big idea:** ``iptables`` is a set of rules that the kernel checks on
every packet entering, leaving, or passing through. Think of it as
bouncers at different doors of a nightclub -- each bouncer has a list
and decides: let in, kick out, or redirect.

.. note::
   On modern kernels, ``iptables`` is actually a frontend to
   **netfilter** (the real engine inside the kernel). Newer systems use
   ``nftables``, but the concepts are the same.

The 4 Main Tables (Each Bouncer Has a Specialty)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 15 35 50

   * - Table
     - Job
     - Analogy
   * - ``filter``
     - Allow/block packets
     - Bouncer checking the guest list
   * - ``nat``
     - Rewrite addresses/ports
     - Receptionist changing your name tag
   * - ``mangle``
     - Modify packet headers
     - Tailor adjusting your outfit
   * - ``raw``
     - Skip connection tracking
     - VIP fast-lane

The 5 Chains (Doors Where Bouncers Stand)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   !theme plain
   skinparam defaultFontSize 12
   rectangle "Incoming Packet" as In #GreenYellow
   rectangle "PREROUTING\n(before routing decision)" as Pre #LightSalmon
   rectangle "Routing Decision" as Route #LightBlue
   rectangle "INPUT\n(for local process)" as Input #LightGreen
   rectangle "Local Process" as App #LightGreen
   rectangle "FORWARD\n(passing through)" as Fwd #LightSalmon
   rectangle "OUTPUT\n(from local process)" as Out #LightGreen
   rectangle "POSTROUTING\n(before leaving)" as Post #LightSalmon
   rectangle "Outgoing Packet" as Wire #GreenYellow
   In --> Pre
   Pre --> Route
   Route --> Input : destined for us
   Route --> Fwd : destined elsewhere
   Input --> App
   App --> Out
   Out --> Post
   Fwd --> Post
   Post --> Wire
   note right of Pre
     NAT happens here
     for incoming
     (DNAT)
   end note
   note right of Post
     NAT happens here
     for outgoing
     (SNAT, MASQUERADE)
   end note

Memorize this flow:

* **PREROUTING** -- first stop for arriving packets
* **INPUT** -- packets for this machine
* **FORWARD** -- packets just passing through (e.g., router, Docker
  host)
* **OUTPUT** -- packets created by this machine
* **POSTROUTING** -- last stop before leaving

Rules and Targets
~~~~~~~~~~~~~~~~~~~~~

Each rule says: "If packet matches X, then do Y"

Common targets (Y):

* ``ACCEPT`` -- let it through
* ``DROP`` -- silently discard (bouncer pretends you don't exist)
* ``REJECT`` -- discard + send error reply (bouncer says "go away")
* ``DNAT`` -- change destination address
* ``SNAT`` / ``MASQUERADE`` -- change source address
* ``LOG`` -- write to syslog, then continue

Real Examples
~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Block all incoming SSH except from 192.168.1.0/24
   iptables -A INPUT -p tcp --dport 22 -s 192.168.1.0/24 -j ACCEPT
   iptables -A INPUT -p tcp --dport 22 -j DROP

   # View current rules
   iptables -L -v -n              # filter table
   iptables -t nat -L -v -n       # nat table

   # How Docker hides containers behind host IP (MASQUERADE)
   iptables -t nat -A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE

How Docker Uses iptables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When you run ``docker run -p 8080:80 nginx``, Docker silently writes
rules like:

.. uml::

   !theme plain
   rectangle "External Client\nhits host:8080" as Ext #GreenYellow
   rectangle "PREROUTING\nDNAT rule" as Pre #LightSalmon
   rectangle "Container nginx\n172.17.0.2:80" as Cont #LightGreen
   rectangle "Reply packet" as Reply #LightBlue
   rectangle "POSTROUTING\nMASQUERADE" as Post #LightSalmon
   rectangle "Client sees reply\nfrom host IP" as Client #GreenYellow
   Ext --> Pre
   Pre --> Cont : rewrite dest\nto 172.17.0.2:80
   Cont --> Reply
   Reply --> Post
   Post --> Client : rewrite source\nto host IP
   note bottom of Pre
     DNAT
     Destination
     Network
     Address
     Translation
   end note
   note bottom of Post
     SNAT or MASQUERADE
     Source
     Network
     Address
     Translation
   end note

Two NAT tricks in play:

* **DNAT at PREROUTING** -- "Mail addressed to host:8080? Actually
  deliver to container 172.17.0.2:80"
* **MASQUERADE at POSTROUTING** -- "Container talking to outside?
  Replace its private IP with my public IP"

Connection Tracking (conntrack)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The kernel remembers every connection in a table so reply packets are
automatically NATed back correctly. Like a coat check ticket -- you
don't need to explain yourself when you come back.

.. code-block:: bash

   cat /proc/net/nf_conntrack       # see live connection table

.. _overlayfs-internals:

7. OverlayFS Internals -- The Tracing Paper Trick
------------------------------------------------------

**Big idea:** OverlayFS lets you stack filesystems so a process sees a
merged view, but writes only land on the top layer. The lower layers
stay read-only and shareable between containers.

The 4 Directory Roles
~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 15 30 55

   * - Role
     - What it is
     - Analogy
   * - ``lowerdir``
     - Read-only base layers
     - Pages of a printed book
   * - ``upperdir``
     - Writable layer
     - Tracing paper on top
   * - ``workdir``
     - Kernel scratch space
     - Pencil/eraser the kernel uses
   * - ``merged``
     - What the container sees
     - The combined view through tracing paper

.. uml::

   !theme plain
   rectangle "Merged View\n(what container sees)" as Merged #GreenYellow
   rectangle "upperdir\n(writable layer)" as Upper #LightGreen
   rectangle "lowerdir 2\n(app layer, read-only)" as L2 #LightBlue
   rectangle "lowerdir 1\n(OS base, read-only)" as L1 #LightBlue
   rectangle "workdir\n(kernel scratch)" as Work #LightSalmon
   Merged --> Upper : writes go here
   Merged ..> L2 : reads fall through
   Merged ..> L1 : reads fall through
   Upper ..> Work : kernel uses\nfor atomic ops
   note right of Upper
     All new files
     All modifications
     All deletions (whiteouts)
   end note
   note right of L1
     Shared between
     many containers
     Never modified
   end note

How a Read Works
~~~~~~~~~~~~~~~~~~~~

Container asks: "Give me ``/etc/hosts``"

Kernel searches top-down:

1. Look in ``upperdir/etc/hosts`` → not there
2. Look in ``lowerdir2/etc/hosts`` → not there
3. Look in ``lowerdir1/etc/hosts`` → found! return it

First match wins. Think of it like flipping through transparent sheets
-- the topmost visible mark is what you see.

How a Write Works -- Copy-Up
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is the magic. When the container modifies a file that lives in a
lower layer:

.. uml::

   !theme plain
   skinparam defaultFontSize 12
   start
   :Container writes to /etc/hosts;
   if (File in upperdir?) then (yes)
     :Write directly to upperdir;<<#LightGreen>>
   else (no)
     :Find file in lowerdir;<<#LightSalmon>>
     :Copy entire file to upperdir;<<#LightSalmon>>
     :This is "copy-up";<<#LightSalmon>>
     :Apply write to upper copy;<<#LightGreen>>
   endif
   :Lower layer untouched;
   stop

**Important consequence:** writing one byte to a huge file copies the
entire file up first. This is why databases inside containers should
use volumes (bypass OverlayFS entirely).

How a Delete Works -- Whiteouts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can't actually delete a file from a read-only lower layer. So
OverlayFS uses a clever trick: whiteouts.

A whiteout is a special character device with major/minor ``0/0``
placed in the ``upperdir`` at the path of the "deleted" file. The
kernel sees it and pretends the file doesn't exist anymore.

**Analogy:** you can't tear a page out of the book underneath. But you
can put a black sticker on the tracing paper where that page would show
through.

For deleted directories, OverlayFS sets an extended attribute
``trusted.overlay.opaque="y"`` on the directory in ``upperdir`` --
meaning "don't show me anything from lower layers for this dir."

A Real Docker Example
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Find an overlay mount
   mount | grep overlay

You'll see something like:

.. code-block:: text

   overlay on /var/lib/docker/overlay2/abc123/merged type overlay
   (rw,lowerdir=L1:L2:L3,upperdir=U,workdir=W)

Inside ``/var/lib/docker/overlay2/``:

* Each layer is a directory with a hash name
* ``diff/`` holds that layer's actual files
* ``link`` is a short symlink name
* ``lower`` is a file listing parent layers

.. uml::

   !theme plain
   rectangle "Image: nginx" as Img #LightBlue
   rectangle "Layer 1: ubuntu base\n(shared by many images)" as L1 #LightBlue
   rectangle "Layer 2: nginx install" as L2 #LightBlue
   rectangle "Layer 3: config files" as L3 #LightBlue
   rectangle "Container 1 upperdir" as C1 #LightGreen
   rectangle "Container 2 upperdir" as C2 #LightGreen
   Img --> L1
   L1 --> L2
   L2 --> L3
   L3 --> C1
   L3 --> C2
   note right of L1
     Read-only
     ONE copy on disk
     Saves huge space
   end note
   note right of C1
     Only this container's
     changes live here
   end note

**Why this is brilliant:** 100 containers from the same image share the
same lower layers on disk. Only their tiny upper layers differ. Massive
disk savings.

Quick Commands to Explore
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # See overlay mounts
   findmnt -t overlay

   # Inspect a Docker container's layers
   docker inspect <container> | grep -A5 GraphDriver

   # Check disk usage of containers vs images
   docker system df -v

Quick Recap (Everything in One Place)
------------------------------------------

**Kernel networking:**
Layered post office -- each layer (Ethernet → IP → TCP/UDP → Socket)
peels an envelope.

**Docker:**
Regular processes wearing costumes made of namespaces (illusion) and
cgroups (limits). Same kernel as the host -- no VM.

**Container filesystem:**
Layered cake using OverlayFS; writes land on top via copy-up, deletes
use whiteouts. Lower layers shared across containers → big disk
savings.

**Container networking:**
veth pairs plug each container into the ``docker0`` virtual switch.
``iptables`` NAT (DNAT + MASQUERADE) bridges container IPs to the
outside world.

**iptables:**
4 tables (``filter``, ``nat``, ``mangle``, ``raw``), 5 chains
(PRE/IN/FWD/OUT/POST-ROUTING). Rules match packets → apply targets
(``ACCEPT``, ``DROP``, ``DNAT``, ``MASQUERADE``). ``conntrack``
remembers connections so replies auto-NAT back.

**Inspection tools:**
``netstat``/``ss`` -- phone directory (who's connected, listening, by
which process). ``tcpdump`` -- wiretap (actual packets flowing on the
wire).
