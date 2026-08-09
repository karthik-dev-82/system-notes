USB Device Binding: Play With It
================================

"Everything is a file" hides a real decision the kernel has to make
every time you plug something in: **which driver, if any, gets to
claim this device and create its `/dev` node?**

There are really only two paths:

* **Standard USB class.** If the device declares one of the handful of
  official USB device classes -- CDC-ACM (serial), Mass Storage, HID,
  Video (UVC), Audio (UAC), Printer -- a generic driver the kernel
  already ships claims it immediately. This is why an Arduino Uno
  works the instant you plug it in: no install step, because CDC-ACM
  support is already built in.
* **Vendor-specific chip.** If the device doesn't declare a standard
  class, the kernel has nothing generic to fall back on. It needs a
  driver that matches that exact chip's vendor/product ID --
  ``ftdi_sio``, ``cp210x``, ``ch341``, ``pl2303``. No matching driver
  installed means the device is fully visible on the USB bus (it shows
  up in ``lsusb``) but never gets a ``/dev`` node at all.

Play With It
------------------

Plug devices in, watch which ones bind immediately and which ones sit
unclaimed, then toggle a vendor driver on to fix an unclaimed device
without ever unplugging it. Try plugging in more than one vendor-chip
device in a row and see how ``/dev/ttyUSB*`` numbering is one shared
pool across every vendor chip -- not a separate counter per chip.

.. raw:: html
   :file: _static/usb_binding_widget.html

See :doc:`linux_devices` for the full taxonomy this widget's device
catalog is drawn from, including the block/character/network/terminal/
pseudo device categories this widget doesn't cover.
