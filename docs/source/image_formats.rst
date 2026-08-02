Image Formats: The Quick Guide
====================================

Think of image formats like different types of containers for your
lunch:

SVG (Scalable Vector Graphics)
------------------------------------

**The Recipe Card**

What it is: instructions for drawing shapes, not actual pixels. Like
telling someone "draw a circle, radius 5cm" vs. showing them a photo
of a circle.

Advantages:

* Infinitely scalable (looks sharp at *any* size -- billboard or
  thumbnail)
* Tiny file size for simple graphics
* Editable (change colors, shapes easily)

Disadvantages:

* Only good for simple graphics (logos, icons, diagrams)
* Can't do realistic photos
* Slower for complex images

Use for: logos, icons, charts, UI elements, anything that needs to
resize.

PNG (Portable Network Graphics)
-------------------------------------

**The Tupperware Container**

What it is: a grid of colored pixels with transparency support.

Advantages:

* Supports transparency (see-through backgrounds)
* Lossless (perfect quality, no blur)
* Great for text, sharp edges

Disadvantages:

* Large file sizes
* Gets blurry when scaled up

Use for: screenshots, graphics with text, images needing transparency,
web graphics.

JPEG (Joint Photographic Experts Group)
-----------------------------------------------

**The Vacuum-Sealed Bag**

What it is: compressed pixels that throw away some detail.

Advantages:

* Small file sizes
* Great for photos with lots of colors
* Universal support

Disadvantages:

* Lossy (loses quality each time you save)
* No transparency
* Bad for text/sharp edges (creates fuzzy "artifacts")

Use for: photos, realistic images, social media uploads.

Image Format Decision Tree
--------------------------------

.. uml::

   !theme plain
   title Image Format Decision Tree
   start
   if (Need to scale to any size?) then (yes)
     :Use SVG;<<#LightGreen>>
     stop
   else (no)
     if (Need transparency?) then (yes)
       :Use PNG;<<#LightBlue>>
       stop
     else (no)
       if (Is it a photo?) then (yes)
         :Use JPEG;<<#LightSalmon>>
         stop
       else (no)
         if (Has text or sharp edges?) then (yes)
           :Use PNG;<<#LightBlue>>
           stop
         else (no)
           :Use JPEG;<<#LightSalmon>>
           stop
         endif
       endif
     endif
   endif

Quick Comparison Table
------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 40 40

   * - Format
     - Best For
     - Avoid For
   * - SVG
     - Logos, icons, charts
     - Photos
   * - PNG
     - Screenshots, text, transparency
     - Large photos
   * - JPEG
     - Photos, complex images
     - Text, logos

Memory Trick
-----------------

* **SVG** = Scalable -> size doesn't matter
* **PNG** = Perfect quality -> no compression blur
* **JPEG** = Jammed smaller -> compressed for photos
