SLAM: The Chicken-and-Egg Loop, Play With It
===============================================

"You need a map to know where you are, but you need to know where you
are to make a map" is the right intuition, but the actual mechanism
that breaks the chicken-and-egg deadlock is concrete: use your noisy
motion estimate as a *starting guess*, then correct that guess by
matching the new scan against the map you've already built. That
correction step -- scan matching -- is what this widget makes real.

Play With It
------------------

Same true path, same noisy odometry commands, run through two
strategies side by side. The left map just integrates the noise
directly and drifts. The right map uses the exact same noisy command
only as a starting guess, then refines it with real point-to-point ICP
(Iterative Closest Point) against the map built so far. Take a few
steps and watch the two error lines pull apart -- then click "Run 100
trials" to see the live aggregate statistic instead of taking the
claim on faith.

.. raw:: html
   :file: _static/slam_scan_matching_widget.html

See :doc:`lidar_pointcloud_interactive` for the sensor half of this
picture on its own, and :doc:`lidar_slam` for the full write-up both
widgets are built from.
