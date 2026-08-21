Image Formats: The Quick Guide
====================================

.. raw:: html

   <style>
     div.document {
       background: #eef1ee;
       color: #1c231d;
       font-family: Georgia, "Iowan Old Style", "Times New Roman", serif;
       line-height: 1.68;
       font-size: 17px;
       border: 1px solid #cdd6cc;
       border-radius: 4px;
       padding: 40px 48px 48px;
       margin: 12px 0 24px;
     }
     div.document h1 {
       font-family: inherit;
       font-weight: 400;
       font-size: 2.4rem;
       line-height: 1.12;
       color: #1c231d;
       border-bottom: 1px solid #cdd6cc;
       padding-bottom: 18px;
       margin: 0 0 30px;
     }
     div.document h2 {
       font-family: inherit;
       font-weight: 400;
       font-style: italic;
       font-size: 1.5rem;
       color: #1c231d;
       margin: 44px 0 10px;
       padding-top: 26px;
       border-top: 1px solid #cdd6cc;
     }
     div.document h2:first-of-type { border-top: none; padding-top: 0; margin-top: 30px; }
     div.document h3 {
       font-family: inherit;
       font-weight: 700;
       font-style: normal;
       font-size: 1.14rem;
       color: #7a2f3d;
       margin: 26px 0 8px;
     }
     div.document .headerlink {
       color: #5c675d;
       opacity: 0.5;
       text-decoration: none;
       font-size: 0.7em;
       margin-left: 8px;
     }
     div.document .headerlink:hover { opacity: 1; }
     div.document p { margin: 0 0 17px; }
     div.document strong { color: #1c231d; font-weight: 700; }
     div.document a { color: #7a2f3d; text-decoration: underline; text-decoration-color: #7a2f3d55; text-underline-offset: 2px; }
     div.document a:hover { text-decoration-color: #7a2f3d; }
     div.document ul, div.document ol { margin: 0 0 17px; padding-left: 26px; }
     div.document li { margin-bottom: 7px; }
     div.document hr { border: none; border-top: 1px solid #cdd6cc; margin: 40px 0; }

     div.document code.docutils.literal {
       font-family: ui-monospace, "SF Mono", Menlo, monospace;
       font-size: 0.86em;
       background: #f2f0ea;
       border: 1px solid #d8d4c8;
       color: #4a2f14;
       padding: 1px 5px;
       border-radius: 2px;
     }

     div.document div.highlight {
       background: #f2f0ea;
       border: 1px solid #d8d4c8;
       border-left: 3px solid #7a2f3d;
       border-radius: 0;
       padding: 14px 18px;
       margin: 4px 0 22px;
       overflow-x: auto;
     }
     div.document div.highlight pre {
       background: transparent;
       color: #2a2a24;
       font-family: ui-monospace, "SF Mono", Menlo, monospace;
       font-size: 0.86rem;
       line-height: 1.6;
       margin: 0;
     }
     div.document .highlight .c1 { color: #7a7266; font-style: italic; }
     div.document .highlight .k, div.document .highlight .kn, div.document .highlight .nb { color: #3d5c3d; font-weight: 600; }
     div.document .highlight .s1, div.document .highlight .s2 { color: #7a2f3d; }
     div.document .highlight .gp, div.document .highlight .gh { color: #7a2f3d; font-weight: 700; }
     div.document .highlight .nv, div.document .highlight .ss,
     div.document .highlight .vc, div.document .highlight .vg,
     div.document .highlight .vi, div.document .highlight .vm { color: #4a4470; }
     div.document .highlight .o, div.document .highlight .go { color: #6a6a5e; }

     div.document table.docutils {
       width: 100%;
       border-collapse: collapse;
       background: #ffffff;
       border: 1px solid #cdd6cc;
       margin: 6px 0 24px;
       font-size: 0.92rem;
       font-family: -apple-system, "Segoe UI", sans-serif;
     }
     div.document table.docutils th.head {
       text-align: left;
       padding: 9px 14px;
       font-size: 0.72rem;
       letter-spacing: 0.06em;
       text-transform: uppercase;
       color: #7a2f3d;
       border-bottom: 2px solid #7a2f3d;
       font-weight: 700;
     }
     div.document table.docutils td {
       padding: 9px 14px;
       border-bottom: 1px solid #cdd6cc;
       vertical-align: top;
     }
     div.document table.docutils tr.row-even { background: #f7f6f2; }
     div.document table.docutils tr.row-odd { background: transparent; }
     div.document table.docutils tr:last-child td { border-bottom: none; }

     div.document p.plantuml { text-align: center; margin: 30px 0; }
     div.document p.plantuml img {
       max-width: 100%;
       height: auto;
       background: #ffffff;
       border: 1px solid #cdd6cc;
       padding: 20px;
     }
   </style>

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
