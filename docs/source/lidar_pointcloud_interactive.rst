LIDAR Ray-Casting & Point Clouds: Play With It
=================================================

"Shoots lasers, measures bounce-back time, builds a point cloud" is
the right idea but skips the part that actually makes it work: turning
one measured round-trip time into one exact (x, y) dot requires real
ray-vs-wall geometry, not just a distance number floating in the air.

Play With It
------------------

Click anywhere in the open tunnel below to place the scanner. It casts
a ring of rays outward, finds exactly where each one first hits a
wall, and drops a point-cloud dot there -- all from real ray-segment
intersection math, not placed decorations. Inspect any individual ray
to see its actual round-trip time-of-flight calculation. Switch to
Mobile mode and move the scanner to a few different spots to watch the
point cloud fill in gaps a single stationary scan could never see.

.. raw:: html
   :file: _static/lidar_pointcloud_widget.html

See :doc:`lidar_slam` for the full write-up this widget is built from,
and the companion SLAM scan-matching widget for what happens when the
scanner's own position isn't known in advance either.
