LIDAR and SLAM for GPS-Denied Navigation
=============================================

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

     div.document div.admonition {
       background: #f7f6f2;
       border: 1px solid #cdd6cc;
       border-left: 4px solid #a67c1f;
       border-radius: 4px;
       padding: 14px 18px;
       margin: 4px 0 22px;
     }
     div.document div.admonition p.admonition-title {
       font-weight: 700;
       color: #a67c1f;
       margin: 0 0 8px;
       font-size: 0.72rem;
       letter-spacing: 0.06em;
       text-transform: uppercase;
     }
     div.document div.admonition p:last-child { margin-bottom: 0; }
     div.document div.admonition.warning,
     div.document div.admonition.attention,
     div.document div.admonition.caution { border-left-color: #b0432a; }
     div.document div.admonition.warning p.admonition-title,
     div.document div.admonition.attention p.admonition-title,
     div.document div.admonition.caution p.admonition-title { color: #b0432a; }
     div.document div.admonition.tip,
     div.document div.admonition.hint,
     div.document div.admonition.important { border-left-color: #3d5c3d; }
     div.document div.admonition.tip p.admonition-title,
     div.document div.admonition.hint p.admonition-title,
     div.document div.admonition.important p.admonition-title { color: #3d5c3d; }
   </style>

How robots and vehicles see and map their surroundings when GPS isn't
available -- underground tunnels, indoor spaces, and anywhere else a
satellite signal can't reach. Underground mining is used as the running
example throughout since it's one of the toughest, most well-documented
cases, but the same two technologies show up anywhere GPS doesn't work.

LIDAR: Light Detection and Ranging
---------------------------------------

.. seealso::
   See :doc:`lidar_pointcloud_interactive` for a hands-on version of
   this section -- click to place a scanner, cast real rays against
   real walls, and see the exact round-trip time-of-flight math behind
   every point-cloud dot.


**The Bat Analogy:** think of how a bat navigates in the dark by
sending out sound waves and listening for echoes. LIDAR works the same
way, but uses laser light instead of sound.

How LIDAR Works
~~~~~~~~~~~~~~~~~~~

1. Shoots laser beams in all directions (like a lighthouse spinning)
2. Measures bounce-back time (light travels super fast, so timing is in
   nanoseconds)
3. Calculates distance using: ``Distance = (Speed of Light x Time) / 2``
4. Creates a **point cloud** -- millions of dots showing where surfaces
   are

.. uml::

   !theme plain
   rectangle "LIDAR Scanner" as lidar #LightBlue
   rectangle "Laser Pulse Out" as out #LightGreen
   rectangle "Reflection from Wall" as wall #LightSalmon
   rectangle "Return Signal" as return #GreenYellow
   rectangle "Distance Calculation" as calc #LightBlue
   lidar --> out
   out --> wall
   wall --> return
   return --> lidar
   lidar --> calc
   note right of calc
     Distance = (Speed x Time) / 2
     ..
     Example:
     Light travels 300,000 km/s
     If echo returns in 0.00001 sec
     Distance = 1.5 km
   end note

Types Used in the Field
~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Terrestrial LIDAR:** sits on a tripod, scans stationary

* Used for: mapping tunnel/room walls, measuring volumes

**Mobile LIDAR:** mounted on vehicles/robots

* Used for: continuous scanning while moving through a space

SLAM: Simultaneous Localization and Mapping
-------------------------------------------------

.. seealso::
   See :doc:`slam_scan_matching_interactive` for a hands-on version of
   this section -- the same noisy motion command fed into raw dead
   reckoning versus real ICP scan-matching correction, side by side,
   with a live 100-trial statistic instead of a single anecdotal run.


**The Blindfolded Explorer Analogy:** imagine you're blindfolded in an
unknown room. As you walk and touch walls, you're doing two things at
once:

1. Figuring out where **you** are (Localization)
2. Drawing a map of the room (Mapping)

That's SLAM! It's the "chicken and egg" problem: you need a map to know
where you are, but you need to know where you are to make a map.

.. uml::

   !theme plain
   start
   repeat
     :Scan Environment;
     note right
       Uses LIDAR to capture
       surrounding geometry
     end note
     :Match with Previous Scans;
     note right
       Looks for features seen before
       ..
       Like recognizing a corner or
       a support beam you passed earlier
     end note
     :Estimate Position;
     :Update Map;
   repeat while (Continue Mapping?)
   stop

Where GPS Doesn't Work
----------------------------

GPS needs a clear line of sight to satellites, so it fails (or gets
unreliably noisy) in plenty of ordinary places, not just mines:

* **Underground mines and tunnels** -- solid rock overhead blocks the
  signal entirely
* **Indoor spaces** -- warehouses, factories, parking garages
* **Dense urban canyons** -- tall buildings reflect and block signals
* **Caves and underwater** -- no signal penetration at all
* **Dense forest canopy** -- heavy attenuation
* **Other planets/moons** -- there's no GPS constellation to receive
  from in the first place (this is exactly why Mars rovers navigate
  using stereo cameras and wheel odometry instead -- Curiosity and
  Perseverance don't carry a scanning LIDAR unit; their autonomous
  driving and hazard avoidance is vision-based, not laser-based)

LIDAR + SLAM is the standard answer to all of these: build your own
local reference frame from the environment itself, instead of relying
on an external signal that isn't there.

Why SLAM Is Hard in GPS-Denied Environments
-------------------------------------------------

.. uml::

   !theme plain
   package "SLAM Algorithm Challenges" as challenges #LightBlue {
   }
   rectangle "Drift & Loop Closure" as drift #LightSalmon
   rectangle "Repetitive Geometry" as geo #LightGreen
   rectangle "Dust and Moisture" as dust #GreenYellow
   rectangle "Dynamic Environment" as dynamic #LightBlue
   challenges --> drift
   challenges --> geo
   challenges --> dust
   challenges --> dynamic
   note bottom of drift
     Every scan-match has small error
     ..
     Errors compound over a long run
     ..
     Fix: recognize a place you've
     already mapped ("loop closure")
     and snap the accumulated error
     back down -- but that recognition
     step is its own hard problem
   end note
   note bottom of geo
     Many tunnels/corridors/rooms
     look similar
     ..
     Hard to tell one section from another
     ..
     Like a maze of identical hallways
   end note
   note bottom of dust
     Reduces laser accuracy
     ..
     Creates noise in data
   end note
   note bottom of dynamic
     Equipment moving
     ..
     Layout changing
     (new excavation, rearranged storage)
     ..
     Map keeps changing
   end note

LIDAR + SLAM Working Together
-----------------------------------

.. uml::

   !theme plain
   rectangle "Mobile Platform" as platform #LightBlue
   rectangle "LIDAR Scanner" as scanner #LightGreen
   rectangle "SLAM Algorithm" as slam #LightSalmon
   rectangle "3D Map" as map #GreenYellow
   rectangle "Vehicle Position" as pos #LightBlue
   platform --> scanner
   scanner --> slam
   slam --> map
   slam --> pos
   pos --> platform
   note right of slam
     Processes LIDAR data
     ..
     Tracks where platform moved
     ..
     Builds consistent 3D map
     ..
     Corrects drift over time
   end note

Real Applications
----------------------

**Autonomous vehicles:** load-haul-dump (LHD) machines in mines
navigate without drivers

* SLAM tells them exactly where they are
* LIDAR sees obstacles and tunnel walls

**Tunnel/structure inspection:** detect deformations and hazards

* Compare new scans to old maps
* Find areas where walls are shifting

**Ventilation planning:** know exact tunnel volumes

* Calculate air flow requirements
* Position fans optimally

**Drone surveys:** fly through dangerous or inaccessible areas

* Create maps without risking humans
* Check structural integrity

.. note::
   None of this is mining-specific. The same LIDAR+SLAM combination
   powers warehouse robots, indoor delivery robots, self-driving cars
   in tunnels and parking garages, search-and-rescue drones in
   collapsed buildings, and planetary rovers -- anywhere GPS can't
   reach, this is the general-purpose answer.

Key Advantages in GPS-Denied Environments
-----------------------------------------------

1. **Safety:** less human exposure to hazards
2. **Accuracy:** millimeter-level precision
3. **Speed:** map large areas in hours, not weeks
4. **Documentation:** permanent digital record
5. **Dark-friendly:** works in zero-light conditions

The Simple Truth
---------------------

* **LIDAR** = the eyes that see in the dark using laser light
* **SLAM** = the brain that figures out "where am I?" and "what does
  this place look like?" at the same time
* **Together** = a system that can navigate and map places humans can't
  safely or easily reach, or that GPS simply can't see into

Going Deeper
----------------

Everything above is the intuition-level picture. If you want to see it
actually built end-to-end -- real hardware, a real SLAM implementation,
not just the analogy -- `How to Make an Autonomous Mapping Robot Using
SLAM <https://www.youtube.com/watch?v=xqjVTE7QvOg>`_ (Kai Nakamura)
walks through a full project. Fair warning: it moves fast into real
implementation detail, so it's worth having the concepts above settled
first.
