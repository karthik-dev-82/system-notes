Linux Network Interfaces - The Simple Explanation
=====================================================

What's a Network Interface?
-------------------------------

**Analogy:** Think of network interfaces like mailboxes. Your house might have:

* A physical mailbox on the street (hardware)
* A PO Box at the post office (virtual)
* An office mailbox at work (another virtual one)

All receive mail for you, but they're different "interfaces" to the postal
system!

**In Linux:** A network interface is how your computer sends and receives
data on a network. It's like a doorway for network traffic.

.. note::
   The names below (``eth0``, ``wlan0``, ...) are the classic naming scheme.
   Most modern distros now use "predictable network interface names" instead
   (e.g. ``enp0s3``, ``wlp2s0``), based on hardware bus location. Same
   concepts apply — just don't be surprised if ``ip link show`` on a recent
   machine doesn't say ``eth0``.

.. _decoding-interface-names:

Decoding Predictable Interface Names
------------------------------------------

The new-style names aren't random -- each letter/number segment encodes
where the device sits, using ``systemd``'s naming scheme
(``systemd.net-naming-scheme``).

**Prefix -- what kind of interface:**

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 15 85

   * - Prefix
     - Meaning
   * - ``en``
     - Ethernet
   * - ``wl``
     - WLAN (Wi-Fi)
   * - ``ww``
     - WWAN (cellular/mobile broadband modem)

**Suffix -- where the device is attached:**

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 75

   * - Pattern
     - Meaning
   * - ``o<index>``
     - On-board device index, as numbered by the firmware/BIOS
       (e.g. ``eno1`` -- typically the built-in NIC on a server/desktop)
   * - ``s<slot>``
     - Hotplug slot index (e.g. ``ens33`` -- common on VMware VMs)
   * - ``p<bus>s<slot>``
     - PCI geographic location: bus number then slot number
       (e.g. ``enp0s3`` -- common on VirtualBox/KVM VMs)
   * - ``x<mac>``
     - Built from the interface's MAC address (e.g.
       ``enx78e7d1ea46da``) -- the fallback when nothing about the
       physical location is stable, common for USB Ethernet adapters

Putting it together, using the two examples from the note above:

* ``enp0s3`` = Ethernet, PCI bus ``0``, slot ``3``
* ``wlp2s0`` = **W**\ ireless **L**\ AN, PCI bus ``2``, slot ``0``

A trailing ``f<function>`` or ``d<dev_port>`` can show up too, for
multi-function PCI cards or NICs with more than one physical port -- e.g.
``enp0s3f1`` for the second function on that same PCI slot.

.. note::
   If none of these are stable enough (some virtualized/cloud setups
   fall back further), you'll still occasionally see the classic
   ``eth0``/``wlan0`` style -- it's the last resort in the scheme, not
   gone entirely.

Types of Network Interfaces
--------------------------------

1. Physical Interfaces (Real Hardware)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**The Big Idea:** These are actual physical network cards plugged into your
computer.

.. code-block:: text

   eth0    = First Ethernet port (wired cable)
   eth1    = Second Ethernet port
   wlan0   = WiFi adapter
   wlan1   = Second WiFi adapter

**Analogy:** Like having multiple doors in your house - a front door, back
door, and garage door. Each is a real, physical entrance.

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "Your Computer" {
     component "eth0\n(Physical)" as eth0 #lightgreen
     component "wlan0\n(Physical)" as wlan0 #lightgreen
   }
   cloud "Internet via Cable" as cable
   cloud "Internet via WiFi" as wifi
   eth0 -down-> cable
   wlan0 -down-> wifi
   note right of eth0: Real network card\nPhysical hardware
   note right of wlan0: Real WiFi chip\nPhysical hardware

**How to see them:**

.. code-block:: bash

   ip link show
   # or
   ifconfig

2. Loopback Interface (``lo``)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**The Big Idea:** A special interface that points back to yourself. Like
talking to yourself in the mirror!

* **Name:** ``lo`` (loopback)
* **IP Address:** Always ``127.0.0.1`` (or ``localhost``)

**Analogy:** It's like sending a letter to yourself. You write it, put it in
your own mailbox, and take it back out. It never leaves your house!

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "Your Computer" {
     component "Application A" as AppA
     component "Application B" as AppB
     component "lo (127.0.0.1)" as lo #lightblue
   }
   AppA -> lo: Send data
   lo -> AppB: Deliver data
   note right: Never leaves\nthe computer!

**Use case:**

* Testing web servers locally: ``http://localhost:8080``
* Database on same machine: Connect to ``127.0.0.1:3306``

3. Virtual Interfaces (Software-Based)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These don't have physical hardware - they're created by software!

a) Virtual Ethernet Pairs (``veth``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**The Big Idea:** a virtual cable with exactly two ends (a "pair").
Whatever goes in one end comes out the other. You can wire those two
ends into any two network namespaces you like -- Docker's specific
choice is to put one end inside a container and leave the other end on
the host.

**Analogy:** imagine two tin cans connected by a string. Whatever you
say into one can, the other can hears! It's a private phone line.

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "Container" {
     component "eth0" as veth0 #yellow
   }
   rectangle "Host" {
     component "veth1234...\n(host-side end)" as veth1 #LightBlue
   }
   veth0 <--> veth1 : Virtual cable\n(one veth pair)
   note bottom of veth1
     This host-side end plugs into
     the docker0 bridge (next section)
     so the container can reach the
     outside world -- and other
     containers, via the bridge.
   end note

**Use case:** Docker gives every container its own veth pair, connecting
that container to the host -- specifically, to the ``docker0`` bridge
on the host side (see next section).

b) Bridge Interfaces (``br0``, ``docker0``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**The Big Idea:** A virtual network switch that connects multiple interfaces
together.

**Analogy:** Like a power strip! You plug multiple devices into one power
strip, and they all get electricity. A bridge lets multiple network
interfaces share the same network.

.. uml::

   !theme plain
   skinparam backgroundColor white
   component "docker0\n(Bridge)" as bridge #orange
   component "Container 1\nveth-abc" as c1
   component "Container 2\nveth-def" as c2
   component "Container 3\nveth-ghi" as c3
   component "Host eth0" as eth0 #lightgreen
   c1 -down-> bridge
   c2 -down-> bridge
   c3 -down-> bridge
   bridge -down-> eth0
   note right of bridge: Virtual switch\nconnects everyone!

**Use case:**

* Docker creates ``docker0`` bridge
* All containers connect to this bridge
* Bridge connects to your physical network

**See bridges:**

.. code-block:: bash

   brctl show
   # or
   ip link show type bridge

c) TUN/TAP Interfaces
^^^^^^^^^^^^^^^^^^^^^^^^

**The Big Idea:**

* **TUN** = Tunnel for IP packets (Layer 3) - Operates at IP level. Used by
  most VPNs (OpenVPN, WireGuard). Only handles IP packets.
* **TAP** = Virtual Ethernet card (Layer 2) - Operates at Ethernet level.
  Can handle any Ethernet traffic (ARP, IPv6, etc.). Used when you need a
  full virtual network card, like connecting VMs to a bridge.

**Analogy:** TUN is like a dedicated secret tunnel for cars only (IP
packets). TAP is like a complete road that handles cars, bikes, pedestrians
- everything (all Ethernet traffic).

**Use cases:**

* ``tun0``: VPNs! When you connect to a VPN, it creates a ``tun0`` interface
* ``tap0``: VM networking, creating a virtual Ethernet card that acts like
  it's plugged into a network

Most VPNs use ``tun`` because they only need to tunnel IP traffic, which is
more efficient.

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "Your Computer" {
     component "Application" as app
     component "tun0\n(VPN tunnel)" as tun #pink
     component "eth0\n(Physical)" as eth #lightgreen
   }
   cloud "VPN Server" as vpn
   cloud "Internet" as internet
   app -> tun: Traffic goes to VPN
   tun -> eth: Encrypted packets
   eth -> internet
   internet -> vpn: Through encrypted tunnel

d) VLAN Interfaces (``eth0.10``, ``eth0.20``)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**The Big Idea:** Split one physical network card into multiple virtual
networks.

**Analogy:** Like apartments in a building. The building has one entrance
(physical network card), but inside are separate apartments (VLANs) with
their own doorbells.

.. uml::

   !theme plain
   skinparam backgroundColor white
   component "eth0 (Physical)" as eth0 #lightgreen
   component "eth0.10\nVLAN 10\nDevelopment" as vlan10 #lavender
   component "eth0.20\nVLAN 20\nProduction" as vlan20 #lavender
   component "eth0.30\nVLAN 30\nGuest WiFi" as vlan30 #lavender
   eth0 -down-> vlan10
   eth0 -down-> vlan20
   eth0 -down-> vlan30
   note bottom: One physical card,\nmultiple virtual networks!

**Use case:** Separating different types of traffic on the same cable!

Real-Life Example: Your Smart Home
--------------------------------------

Imagine you have one ethernet cable running through your house wall (like
one big pipe). Instead of drilling more holes for more cables, you create
virtual lanes inside that one cable!

.. uml::

   skinparam backgroundColor white
   skinparam shadowing false
   rectangle "Physical Cable (eth0)\n🔌 One pipe with 3 lanes" as physical #lightgreen {
     rectangle "VLAN 10: Family Devices\n📱💻 Tablets, laptops" as vlan10 #lightblue
     rectangle "VLAN 20: Security Cameras\n📹 Always recording" as vlan20 #yellow
     rectangle "VLAN 30: Guest WiFi\n👥 Visitors' phones" as vlan30 #pink
   }
   note right of physical
     Same cable, but traffic
     never mixes! Like HOV lanes
     on a highway 🛣️
   end note

**Why This Matters:**

* **Without VLANs:** Guests on your WiFi could potentially see your security
  camera feeds! 😱
* **With VLANs:**

  * Your cameras (VLAN 20) only talk to your recording system
  * Guests (VLAN 30) can only reach the internet
  * Your family devices (VLAN 10) can access everything they need

All traveling on the same physical cable, but completely separated like
cars in different highway lanes that can't cross over!

How One Physical Card Has Multiple Interfaces
---------------------------------------------------

The Magic: Virtual Interfaces on Top of Physical
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Think of it like this:

.. code-block:: text

   Physical eth0 (the actual network card)
       ├── eth0 (main IP: 192.168.1.10)
       ├── eth0.10 (VLAN 10)
       └── eth0.20 (VLAN 20)

**Analogy:** Your house (physical) has one street address, but inside you
have multiple rooms (virtual interfaces), each with a different purpose!

The old ``ifconfig`` (net-tools) world used to show extra IPs on the same
card as separately-named aliases, ``eth0:0``, ``eth0:1``, and so on. The
modern ``iproute2`` commands below do the same job -- one card answering to
multiple IPs -- but without a separate alias name: running ``ip addr show``
afterward lists all the addresses under the same ``eth0``.

Example: Multiple IPs on One Card
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Main interface
   ip addr add 192.168.1.10/24 dev eth0

   # Add more IPs to same physical card!
   ip addr add 192.168.1.11/24 dev eth0
   ip addr add 192.168.1.12/24 dev eth0

   # Now one network card responds to 3 different IP addresses,
   # all listed under the same "eth0" (no eth0:0/eth0:1 aliases)

**Why would you do this?**

* Web server hosting multiple websites
* Testing different network configurations
* Running multiple services on different IPs

Docker Networking (How It All Fits Together)
--------------------------------------------------

The Default Docker Setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "Host Computer" {
     component "eth0\n(Physical)\n192.168.1.100" as eth0 #lightgreen
     component "docker0\n(Bridge)\n172.17.0.1" as docker0 #orange
     rectangle "Container 1" {
       component "eth0 in container\n172.17.0.2" as c1_eth
       component "veth-abc" as veth1 #yellow
     }
     rectangle "Container 2" {
       component "eth0 in container\n172.17.0.3" as c2_eth
       component "veth-def" as veth2 #yellow
     }
     c1_eth -up-> veth1
     veth1 -up-> docker0
     c2_eth -up-> veth2
     veth2 -up-> docker0
     docker0 -up-> eth0
   }
   cloud "Internet" as internet
   eth0 -up-> internet

**How it works:**

1. Docker creates a bridge called ``docker0`` (like a virtual switch)
2. Each container gets a veth pair (like a virtual cable)
3. One end goes in the container, one end plugs into ``docker0``
4. Bridge connects to host's physical network (``eth0``)
5. NAT magic lets containers reach the internet

**Think of it like:** An apartment building (``docker0``) where each
apartment (container) has an intercom (veth) connected to the main
switchboard (``docker0``), which connects to the outside phone line
(``eth0``).

Bridging vs NAT (The Two Key Concepts)
--------------------------------------------

Bridge Mode - "Everyone Gets a Real Address"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**The Big Idea:** All devices on the bridge act like they're on the same
physical network.

**Analogy:** Like an office with multiple phone extensions. Everyone has
the same area code and can call each other directly.

.. uml::

   !theme plain
   skinparam backgroundColor white
   cloud "Router\n192.168.1.1" as router
   rectangle "Bridge (br0)" as bridge #orange {
     component "Container 1\n192.168.1.10" as c1
     component "Container 2\n192.168.1.11" as c2
     component "Host\n192.168.1.5" as host
   }
   router <-down-> bridge
   note right: All devices have IPs\non the SAME network\n(192.168.1.x)

**What happens:**

* Container 1 has IP: ``192.168.1.10``
* Container 2 has IP: ``192.168.1.11``
* Your laptop can ping them directly!
* They all appear on your home network

**Use case:** VMs that need to be visible on your LAN

NAT Mode - "Hidden Behind One Address"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**The Big Idea:** Containers hide behind the host's IP address. The host
translates addresses for them.

**Analogy:** Like a company with one main phone number. When you call, the
receptionist forwards your call to the right person's extension. From
outside, you only see the main number!

.. uml::

   !theme plain
   skinparam backgroundColor white
   cloud "Internet" as internet
   rectangle "Host (NAT Gateway)\n192.168.1.100" as host #lightgreen {
     rectangle "Container 1\n172.17.0.2" as c1
     rectangle "Container 2\n172.17.0.3" as c2
   }
   c1 -> host: Want to access\ngoogle.com
   host -> internet: Request from\n192.168.1.100\n(host's IP, not container's!)
   internet -> host: Response
   host -> c1: Forward response
   note right of host: Host rewrites packets:\n- Outgoing: Replace container IP with host IP\n- Incoming: Replace host IP with container IP

**What happens:**

*Container perspective:*

* Container IP: ``172.17.0.2``
* Wants to visit: ``google.com``

*What NAT does:*

1. Container sends packet with source IP: ``172.17.0.2``
2. Host changes it to: ``192.168.1.100`` (host's real IP)
3. Internet sees request from ``192.168.1.100``
4. Response comes back to ``192.168.1.100``
5. Host changes destination to ``172.17.0.2``
6. Container receives response!

**Think of it like:** Your home WiFi! All your devices (phone, laptop, TV)
have private IPs like ``192.168.1.x``, but to the internet they all appear
to come from one public IP address. Your router does NAT!

Bridge vs NAT Comparison
~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 35 40

   * - Aspect
     - Bridge
     - NAT
   * - Container IPs
     - Real IPs on your network (``192.168.1.x``)
     - Private IPs (``172.17.0.x``)
   * - Visible from outside?
     - ✅ Yes!
     - ❌ No (unless port forwarded)
   * - IP addresses used
     - More (each container needs one)
     - Fewer (all share host IP)
   * - Security
     - Less (containers exposed)
     - More (containers hidden)
   * - Analogy
     - Office with phone extensions
     - Company with one main number
   * - Use case
     - VMs on LAN
     - Docker containers (default)

.. note::
   **Worth knowing:** Docker's *default* network driver is also called
   "bridge" (it's what creates ``docker0``), but that default driver is the
   **NAT** case above, not the "everyone gets a real LAN IP" case. To get
   true Bridge Mode behavior for a container — a real IP on your LAN — you'd
   use a driver like ``macvlan``/``ipvlan``, or attach it to your host's own
   ``br0`` the way a VM would be. The name "bridge" gets reused for both the
   underlying Linux bridge device and Docker's default (NAT'd) network
   driver, which is a common source of confusion.

Port Forwarding with NAT
-----------------------------

**The Problem:** Containers use NAT, so they're hidden. How does the world
access a web server in a container?

**The Solution:** Port forwarding!

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor "User on Internet" as user
   cloud "Internet" as internet
   rectangle "Host\n192.168.1.100" as host #lightgreen
   rectangle "Container\n172.17.0.2\nNginx on port 80" as container
   user -> internet: Visit 192.168.1.100:8080
   internet -> host: Request to port 8080
   host -> host: Port forward rule:\n8080 -> 172.17.0.2:80
   host -> container: Forward to container port 80
   container -> host: Response
   host -> internet: Send response
   internet -> user: Website loads!
   note right of host: Rule: "Traffic to my port 8080\ngoes to container's port 80"

**Docker command:**

.. code-block:: bash

   docker run -p 8080:80 nginx
   # Means: Forward host's port 8080 to container's port 80

**Think of it like:** The receptionist (host) knows "When someone asks for
extension 8080, forward them to extension 80 in room 172.17.0.2"

Real-World Example: Web Server Setup
------------------------------------------

**Scenario:** Run 3 web servers on one Linux machine

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "Physical Server" {
     component "eth0\n(Physical)\n203.0.113.10" as eth0 #lightgreen
     component "docker0\n(Bridge)" as bridge #orange
     rectangle "Nginx Container\n172.17.0.2" {
       component "Port 80" as nginx80
     }
     rectangle "Apache Container\n172.17.0.3" {
       component "Port 80" as apache80
     }
     rectangle "Node.js Container\n172.17.0.4" {
       component "Port 3000" as node3000
     }
     nginx80 -up-> bridge
     apache80 -up-> bridge
     node3000 -up-> bridge
     bridge -up-> eth0
   }
   cloud "Internet" as internet
   internet -down-> eth0
   note right of eth0
   Port forwarding:
   - 203.0.113.10:80 -> Nginx:80
   - 203.0.113.10:8080 -> Apache:80
   - 203.0.113.10:3000 -> Node.js:3000
   end note

**Setup commands:**

.. code-block:: bash

   # Start 3 web servers with port forwarding
   docker run -d -p 80:80 nginx
   docker run -d -p 8080:80 httpd
   docker run -d -p 3000:3000 node-app

   # Now:
   # http://203.0.113.10:80    -> Nginx
   # http://203.0.113.10:8080  -> Apache
   # http://203.0.113.10:3000  -> Node.js

Virtual Network Namespaces
--------------------------------

**The Big Idea:** Each container has its own private view of the network.
It's like each container lives in a separate universe!

**Analogy:** Imagine each container gets its own imaginary house. Inside
that house, it can have its own ``eth0``, its own ``lo``, its own IP
addresses. But it's all virtual - they don't interfere with each other!

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "Host Network Namespace" {
     component "eth0 (real)" as host_eth #lightgreen
     component "docker0" as docker0 #orange
     component "lo" as host_lo
   }
   rectangle "Container 1 Namespace" {
     component "eth0 (virtual)" as c1_eth #yellow
     component "lo" as c1_lo #lightblue
     note right: Container thinks it has\nits own eth0, but it's\nreally a veth!
   }
   rectangle "Container 2 Namespace" {
     component "eth0 (virtual)" as c2_eth #yellow
     component "lo" as c2_lo #lightblue
   }
   c1_eth -up-> docker0
   c2_eth -up-> docker0

**What this means:**

* Each container sees ``eth0`` inside itself
* But it's actually a veth end connected to the bridge
* Containers are isolated - they can't see each other's interfaces
* Host manages all the real networking

**Think of it like:** Each container plays a video game where they think
they're the only player, but really the host computer is running all the
games simultaneously!

Summary Cheat Sheet
------------------------

Interface Types
~~~~~~~~~~~~~~~~~~

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 15 15 20 50

   * - Type
     - Real or Virtual?
     - Example
     - Use Case
   * - Physical
     - ✅ Real
     - ``eth0``, ``wlan0``
     - Actual network card
   * - Loopback
     - Virtual
     - ``lo``
     - Talk to yourself (127.0.0.1)
   * - Bridge
     - Virtual
     - ``docker0``, ``br0``
     - Virtual network switch
   * - veth pair
     - Virtual
     - ``veth0`` ↔ ``veth1``
     - Connect containers
   * - VLAN
     - Virtual
     - ``eth0.10``
     - Separate networks on one cable
   * - TUN/TAP
     - Virtual
     - ``tun0``
     - VPN tunnels

Networking Modes
~~~~~~~~~~~~~~~~~~~

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 15 20 25 40

   * - Mode
     - Visibility
     - IP Type
     - Analogy
   * - Bridge
     - External
     - Real IPs (``192.168.1.x``)
     - Office phone extensions
   * - NAT
     - Hidden
     - Private IPs (``172.17.0.x``)
     - Company main number

Key Commands
~~~~~~~~~~~~~~

.. code-block:: bash

   # See all network interfaces
   ip link show
   ip addr show

   # See bridges
   brctl show

   # See Docker networks
   docker network ls

   # See routing table
   ip route show

The Big Picture
--------------------

One physical network card can support:

* Multiple IP addresses (aliases)
* Multiple VLANs (separate networks)
* A bridge connecting many containers
* NAT hiding many containers behind one IP

All at the same time!

**It's like:** One building (physical card) with multiple businesses
(interfaces), each with their own phone system (networking), some shared
(bridge), some private (NAT), but all using the same internet connection
(physical network)!

**Final thought:** Linux networking is super flexible! The same piece of
hardware can be sliced and diced a hundred different ways using software.
That's the power of virtualization! 🚀
