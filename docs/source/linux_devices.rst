Complete Guide to Linux Devices
===================================

The Big Picture
--------------------

In Linux, everything is a file. Hardware devices appear as special files
you can read from or write to. Think of it like having magic mailboxes
where you drop messages to talk to hardware.

Main Device Categories
---------------------------

1. Block Devices (Storage)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**What:** handle data in fixed-size chunks (blocks) with random access.

**Analogy:** like a bookshelf -- grab any book directly without going
through others first.

**Examples:** hard drives, SSDs, USB flash drives, SD cards, CD/DVD
drives

In Linux:

.. code-block:: text

   /dev/sda      # First hard drive
   /dev/sda1     # First partition
   /dev/nvme0n1  # NVMe SSD
   /dev/mmcblk0  # SD card

Commands:

.. code-block:: bash

   lsblk                        # List all block devices
   mount /dev/sda1 /mnt/usb     # Mount drive
   mkfs.ext4 /dev/sdb1          # Format drive

2. Character Devices (Streaming)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**What:** handle data one character/byte at a time, sequentially.

**Analogy:** like a water hose -- data flows in order, can't skip ahead.

**Examples:** serial ports, mice, keyboards, audio devices, webcams

In Linux:

.. code-block:: text

   /dev/ttyS0          # Physical serial port
   /dev/ttyUSB0        # USB-to-serial adapter
   /dev/ttyACM0        # Arduino (CDC-ACM protocol)
   /dev/input/mouse0   # Mouse
   /dev/video0         # Webcam
   /dev/snd/pcmC0D0p   # Sound card

Commands:

.. code-block:: bash

   cat /dev/ttyUSB0              # Read serial data
   echo "LED ON" > /dev/ttyACM0  # Send to Arduino
   head -c 10 /dev/random        # Get random bytes

3. Network Devices (Special Case)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**What:** handle network communication. Don't appear in ``/dev/``!

**Analogy:** like a post office -- sends/receives data packets.

**Examples:** Ethernet cards, WiFi adapters, Bluetooth, VPN interfaces

In Linux:

.. code-block:: text

   eth0, wlan0          # Old naming style
   enp3s0, wlp2s0       # New predictable naming
   lo                   # Loopback (localhost)
   docker0              # Virtual network

.. seealso::
   See :doc:`network_interfaces` for a deep dive on interfaces
   specifically, and :ref:`decoding-interface-names` for what
   ``enp3s0``/``wlp2s0`` actually encode.

Commands:

.. code-block:: bash

   ip link show                              # List interfaces
   ip addr add 192.168.1.100/24 dev eth0     # Assign IP
   ifconfig                                  # Old way to list

4. Terminal Devices (TTY)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**What:** let humans interact with the computer through text.

**Analogy:** a two-way walkie-talkie between you and Linux.

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 20 30 30

   * - Type
     - Device Path
     - What It Is
     - How to Access
   * - Virtual Consoles
     - ``/dev/tty1`` to ``/dev/tty6``
     - Full-screen text terminals provided by the Linux kernel
     - Press ``Ctrl+Alt+F1`` -- ``F6``
   * - Pseudo-Terminals (PTY)
     - ``/dev/pts/0``, ``/dev/pts/1``, etc.
     - Terminal emulator windows in GUI or SSH sessions
     - Open terminal app or SSH in
   * - Physical Serial Terminals
     - ``/dev/ttyS0``, ``/dev/ttyS1``
     - Real hardware serial ports for remote login
     - Connect serial cable

Commands:

.. code-block:: bash

   tty                    # See which terminal you're using
   who                    # List all logged-in users and their terminals
   w                      # More detailed view (shows what users are doing)
   echo "Hi" > /dev/pts/1 # Send message to another user's terminal

5. Pseudo/Virtual Devices
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**What:** virtual devices created by the kernel, no physical hardware.

Important ones:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 15 35 50

   * - Device
     - Purpose
     - Example Usage
   * - ``/dev/null``
     - Black hole -- discards everything
     - ``command 2> /dev/null``
   * - ``/dev/zero``
     - Infinite zeros
     - ``dd if=/dev/zero of=file bs=1M count=100``
   * - ``/dev/random``
     - Random numbers, same CSPRNG as ``/dev/urandom`` on Linux 5.6+
     - ``head -c 32 /dev/random``
   * - ``/dev/urandom``
     - Pseudo-random, never blocks
     - ``head -c 32 /dev/urandom | base64``
   * - ``/dev/full``
     - Always reports "disk full"
     - Test error handling
   * - ``/dev/loop0``
     - Mount files as devices
     - ``mount -o loop file.iso /mnt``

On Linux 5.6+ (2020 onward -- every current mainstream distro),
``/dev/random`` and ``/dev/urandom`` are both backed by the same
CSPRNG and behave almost identically once it's initialized (a brief
moment during early boot). There's rarely a reason to prefer one over
the other on a modern system; ``/dev/urandom`` remains the safe
default choice either way.

USB Devices - Understanding the Layers
-------------------------------------------

The Key Concept
~~~~~~~~~~~~~~~~~~~

USB devices create multiple layers -- USB is just the transport
mechanism!

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "USB (transport only)" as usb #LightGray
   rectangle "Protocol layer\n(what the device speaks)" as proto #LightBlue
   rectangle "Device file\n(what you actually use)" as devfile #LightGreen
   usb -down-> proto : carries raw bytes
   proto -down-> devfile : kernel driver\ntranslates protocol
   note right of proto
     Mass Storage, CDC-ACM, HID,
     UVC, UAC, Printer, or a
     vendor-specific chip protocol
     (FTDI, CH340, CP210x, ...)
   end note

**Analogy:**

* USB = the postal truck (transportation)
* Protocol on top = the letter format (what the message means)

Example 1: Arduino Connected via USB
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**What happens:**

1. USB layer detects hardware:

   .. code-block:: bash

      lsusb  # Shows "Arduino Uno"
      # Creates: /dev/bus/usb/001/005

2. Serial layer created for communication:

   .. code-block:: text

      # Linux creates: /dev/ttyACM0
      # This "translates" USB to Arduino's serial protocol

**Why two devices?**

* Arduino speaks the serial protocol (UART), not raw USB
* ``/dev/ttyACM0`` is the translator
* USB just transports the serial data

You cannot do:

.. code-block:: bash

   echo "LED ON" > /dev/bus/usb/001/005  # Too low-level!

You must do:

.. code-block:: bash

   echo "LED ON" > /dev/ttyACM0  # Speaks Arduino's language!

Understanding CDC-ACM Protocol
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**What is CDC-ACM?**

* **CDC** = Communications Device Class (a USB standard for
  communication devices)
* **ACM** = Abstract Control Model (makes USB look like old-school
  serial ports)

**Analogy:** CDC-ACM is like a universal translator that makes your
modern USB device speak "old serial port language" so Linux can
understand it easily.

**Why Arduino uses CDC-ACM:**

* Arduino needs to send/receive text and data (like old modems did)
* CDC-ACM is perfect for this -- it's designed for devices that need
  serial communication
* Your computer already knows how to talk CDC-ACM (built into Linux)
* Creates ``/dev/ttyACM0`` automatically -- no special drivers needed!

**Other devices that use CDC-ACM:**

* 3D printer controllers
* GPS receivers
* Some microcontroller boards (Teensy, STM32)
* USB modems

Different USB Serial Protocols
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Not all USB serial devices use CDC-ACM! Here are the common ones:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 15 15 30 40

   * - Protocol
     - Device Name
     - Used By
     - Notes
   * - CDC-ACM
     - ``/dev/ttyACM0``
     - Arduino, 3D printers, modern microcontrollers
     - Standard USB device class, no driver needed
   * - FTDI
     - ``/dev/ttyUSB0``
     - Older Arduinos, many USB-serial adapters
     - Requires FTDI chip; ``ftdi_sio`` driver, very reliable
   * - CP210x
     - ``/dev/ttyUSB0``
     - ESP8266, ESP32, some dev boards
     - Silicon Labs chip, ``cp210x`` driver usually built-in
   * - CH340
     - ``/dev/ttyUSB0``
     - Cheap Arduino clones, budget adapters
     - Chinese chip, ``ch341`` driver -- built into modern kernels,
       older ones may need it installed
   * - PL2303
     - ``/dev/ttyUSB0``
     - Older USB-serial cables
     - Prolific chip, ``pl2303`` driver, common but aging

**Key difference:**

* ``ttyACM`` = uses the standard USB CDC device class (modern, built-in
  support)
* ``ttyUSB`` = uses a separate vendor-specific chip that converts USB to
  serial (needs that chip's specific driver)

CDC-ACM and FTDI/CP210x/CH340/PL2303 are two different kinds of thing,
not peers. CDC-ACM (like Mass Storage, HID, UVC, and UAC, further
below) is an official USB device **class**: a standard the kernel
already ships generic support for, which is why no extra driver is
needed. FTDI/CP210x/CH340/PL2303 are specific **vendor chips** with no
standard class descriptor -- each one needs its own dedicated kernel
driver (``ftdi_sio``, ``cp210x``, ``ch341``, ``pl2303``) to expose a
serial-like interface at all. That's why CDC-ACM "just works" while
the others depend on whether that particular chip's driver is
present.

**Analogy:**

* CDC-ACM = speaking English directly (everyone understands)
* FTDI/CH340/etc. = speaking through a translator (needs the right
  translator)

Example 2: External USB Hard Drive Connected
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**What happens:**

1. USB layer detects hardware:

   .. code-block:: bash

      lsusb  # Shows "Western Digital External HDD"
      # Creates: /dev/bus/usb/001/006

2. Storage layer created for file access:

   .. code-block:: text

      # Linux creates: /dev/sdb (entire drive)
      # Also creates: /dev/sdb1, /dev/sdb2 (partitions)

**Why this device structure?**

* Hard drive speaks the Mass Storage protocol, not raw USB
* ``/dev/sdb`` is the block device translator
* USB just transports the storage commands

You cannot do:

.. code-block:: bash

   cat /dev/bus/usb/001/006  # Too low-level! Makes no sense!

You must do:

.. code-block:: bash

   mount /dev/sdb1 /mnt/usb  # Speaks storage language!
   ls /mnt/usb               # Access your files

Key Difference: Arduino vs USB Hard Drive
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "USB Cable" as usb1 #LightGray
   rectangle "/dev/bus/usb/001/005\n(raw USB)" as raw1 #LightGray
   rectangle "/dev/ttyACM0\n(serial translator)" as tty #LightSalmon
   rectangle "echo data > /dev/ttyACM0\n(sequential byte stream)" as arduino_use #LightGreen
   usb1 -down-> raw1
   raw1 -down-> tty
   tty -down-> arduino_use

   rectangle "USB Cable " as usb2 #LightGray
   rectangle "/dev/bus/usb/001/006\n(raw USB)" as raw2 #LightGray
   rectangle "/dev/sdb\n(storage translator)" as sdb #LightBlue
   rectangle "mount /dev/sdb1 /mnt/usb\n(random access to blocks)" as hdd_use #LightGreen
   usb2 -down-> raw2
   raw2 -down-> sdb
   sdb -down-> hdd_use

**Think of it like:**

* Arduino = talking through a walkie-talkie (character stream)
* Hard drive = reading books from a library shelf (random access)

Both use the same USB truck for delivery, but the packages inside are
completely different!

Different USB Device Types
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   /dev/sda1          # USB storage (Mass Storage protocol)
   /dev/video0        # USB webcam (Video protocol)
   /dev/usb/lp0       # USB printer (Printer protocol)
   /dev/ttyACM0       # Arduino (CDC-ACM serial protocol)
   /dev/ttyUSB0       # FTDI/CH340 serial adapter
   /dev/hidraw0       # USB mouse/keyboard (HID protocol)

Common USB Protocol Types:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 35 45

   * - Protocol
     - What It Does
     - Device Examples
   * - Mass Storage (MSC)
     - Access files and folders
     - USB flash drives, external HDDs, cameras in storage mode
   * - CDC-ACM
     - Serial communication
     - Arduino Uno, modern microcontrollers
   * - HID (Human Interface Device)
     - Input from humans
     - Keyboards, mice, game controllers, joysticks
   * - Video (UVC)
     - Capture video
     - Webcams, capture cards
   * - Audio (UAC)
     - Play/record sound
     - USB microphones, USB speakers, audio interfaces
   * - Printer
     - Send documents to print
     - USB printers, some label makers
   * - Vendor-specific serial chip
     - Convert USB to serial (non-standard, needs its own driver)
     - FTDI/CP210x/CH340 adapters, ESP32 boards, older Arduinos

**Remember:** USB is just the cable and connector. The protocol (or
chip) on top determines what the device actually does, and whether it
needs a dedicated driver.

Device Type Comparison Table
---------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 15 25 15 15 30

   * - Type
     - Access
     - Appears in ``/dev/``
     - Speed
     - Examples
   * - Block
     - Random, by blocks
     - Yes
     - Fast
     - Hard drives, USB drives
   * - Character
     - Sequential, byte stream
     - Yes
     - Varies
     - Serial, mouse, audio, video
   * - Network
     - Packet-based
     - No
     - Fast
     - ``eth0``, ``wlan0``, WiFi
   * - Terminal
     - Text I/O
     - Yes
     - Fast
     - ``/dev/pts/0``, SSH sessions
   * - Pseudo
     - Virtual/special
     - Yes
     - N/A
     - ``/dev/null``, ``/dev/zero``

Input, Audio & Video Devices
---------------------------------

Input Devices
~~~~~~~~~~~~~~~~

.. code-block:: text

   /dev/input/event0   # Generic input events
   /dev/input/mouse0   # Mouse
   /dev/input/js0      # Joystick

Commands:

.. code-block:: bash

   cat /proc/bus/input/devices  # List input devices
   evtest /dev/input/event0     # Monitor events

Audio Devices
~~~~~~~~~~~~~~~~

.. code-block:: text

   /dev/snd/pcmC0D0p   # Playback (speakers)
   /dev/snd/pcmC0D0c   # Capture (microphone)

Commands:

.. code-block:: bash

   aplay -l                         # List sound cards
   aplay music.wav                  # Play audio
   arecord -d 10 -f cd output.wav   # Record 10 seconds

Video Devices
~~~~~~~~~~~~~~~~

.. code-block:: text

   /dev/video0   # First webcam
   /dev/fb0      # Framebuffer (screen)

Commands:

.. code-block:: bash

   v4l2-ctl --list-devices                    # List cameras
   ffmpeg -i /dev/video0 -frames:v 1 photo.jpg  # Capture photo

Identifying Device Types
-----------------------------

.. code-block:: bash

   # Check device type (b=block, c=character)
   ls -l /dev/sda
   # brw-rw---- = block device

   ls -l /dev/ttyS0
   # crw-rw---- = character device

   # List by type
   ls -l /dev/ | grep "^b"  # All block devices
   ls -l /dev/ | grep "^c"  # All character devices

   # See what's using a device
   lsof /dev/video0

   # Monitor device plug/unplug events
   udevadm monitor

Real-World Example: Arduino via USB
-----------------------------------------

When you connect Arduino to Linux:

1. **USB detection (physical layer):**

   * ``lsusb`` shows: "Arduino Uno"
   * USB handles power and electrical signals

2. **Serial device creation (protocol layer):**

   * Linux creates: ``/dev/ttyACM0``
   * Translates between USB transport and serial protocol
   * Arduino understands serial, not raw USB

3. **Terminal usage (user layer):**

   * You open a terminal window (uses ``/dev/pts/0``)
   * You type: ``echo "BLINK" > /dev/ttyACM0``
   * Path: Terminal → Serial device → USB hardware → Arduino

Three layers working together!

Understanding Your Terminal Questions
-------------------------------------------

Q1: Why do I see /dev/pts/2 in a GUI terminal?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Answer:** you're using a pseudo-terminal (PTY), not a physical serial
port!

Pseudo-terminals (``/dev/pts/*``) are created when you:

* Open a terminal emulator in your GUI (GNOME Terminal, Konsole, etc.)
* SSH into a machine
* Use ``screen`` or ``tmux``

Physical serial terminals (``/dev/ttyS0``) are only for:

* Direct serial cable connections
* Very old-style terminals
* Embedded systems with a serial console

**Think of it like:** PTY = virtual phone line, ``ttyS0`` = physical
phone jack.

Q2: What does the ``who`` output mean?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   alice     tty2         2025-10-06 10:33
   alice     pts/2        2025-10-06 10:33 (:0)

**Explanation:**

* ``tty2`` = a virtual console (``Ctrl+Alt+F2``) running in the
  background -- this is often where the graphical session's login is
  actually anchored
* ``pts/2`` = the pseudo-terminal backing your GUI terminal window
* ``who`` reports login sessions and terminals from ``utmp``; exactly
  what shows up for a graphical desktop session depends on your display
  manager (GDM/LightDM/SDDM) and desktop environment

Q3: SSH terminal output explained
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   bob  pts/0  2025-10-06 05:33 (203.0.113.50)

**Explanation:**

* ``pts/0`` = first pseudo-terminal on that remote machine
* ``203.0.113.50`` = your local machine's IP (where you SSH'd from) --
  shown here as a documentation-reserved address (RFC 5737); yours will
  be whatever your actual machine's IP is
* You're connected over the network, not a serial cable

**Why not ``/dev/ttyS0``?**

* ``/dev/ttyS0`` is only for direct physical serial connections
* SSH creates a virtual terminal over the network
* Modern remote access uses network PTYs, not serial ports

**Analogy:** it's like video calling (SSH/PTY) vs. using a landline
phone (serial port).

Q4: Can I access virtual consoles from a GUI session?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Answer:** yes! You can switch anytime.

From a GUI desktop:

* Press ``Ctrl+Alt+F1`` through ``Ctrl+Alt+F6`` to access virtual
  consoles
* Press ``Ctrl+Alt+F7`` (or ``F1``/``F2`` on some systems) to return to
  the GUI

**What's happening:**

* Virtual consoles (``tty1``-``tty6``) are always running in the
  background
* Your GUI runs on one of them too (historically ``tty7``; commonly
  ``tty1`` or ``tty2`` on modern systemd/Wayland setups)
* They're independent -- like having multiple screens

**Analogy:** think of it like alt-tabbing between full-screen apps, but
at a deeper system level.

Key Takeaways
-----------------

* **Block devices** = storage with random access (hard drives, USB
  sticks, SD cards)
* **Character devices** = sequential streaming data (serial ports, mice,
  keyboards, audio, video)
* **Network devices** = special case -- no ``/dev/`` files, managed
  differently
* **Terminal devices** = your conversation window with Linux

  * PTY (``/dev/pts/*``) = modern terminal emulators and SSH
  * Virtual console (``/dev/tty1``-``6``) = full-screen text terminals
    (``Ctrl+Alt+F1``-``6``)
  * Serial terminal (``/dev/ttyS0``) = physical serial cable connections

* **Pseudo devices** = virtual helpers (``/dev/null``, ``/dev/zero``,
  ``/dev/random``)
* **USB is a transport layer** -- devices on top use different
  protocols/classes (serial, storage, video, etc.), or vendor-specific
  chips when there's no standard class for the job
* **Layers matter:** write to the protocol layer (like ``/dev/ttyACM0``
  or ``/dev/sdb1``), not raw USB
* **Everything is a file** in Linux -- even hardware

Quick Reference: When Do I See What?
-------------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 35 35 30

   * - Situation
     - Device You'll See
     - Type
   * - Open terminal in GUI
     - ``/dev/pts/0``, ``/dev/pts/1``, etc.
     - Pseudo-terminal
   * - SSH into remote machine
     - ``/dev/pts/0``, ``/dev/pts/1``, etc.
     - Pseudo-terminal
   * - Press ``Ctrl+Alt+F1``-``F6``
     - ``/dev/tty1`` through ``/dev/tty6``
     - Virtual console
   * - Connect via serial cable
     - ``/dev/ttyS0``
     - Physical serial terminal
   * - Connect Arduino/device
     - ``/dev/ttyACM0`` or ``/dev/ttyUSB0``
     - USB serial adapter
   * - Connect USB hard drive
     - ``/dev/sdb``, ``/dev/sdb1``, etc.
     - USB block device
