LIDAR and SLAM for GPS-Denied Navigation
=============================================

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
  from in the first place (this is exactly why Mars rovers use
  LIDAR/vision-based navigation)

LIDAR + SLAM is the standard answer to all of these: build your own
local reference frame from the environment itself, instead of relying
on an external signal that isn't there.

Why SLAM Is Hard in GPS-Denied Environments
-------------------------------------------------

.. uml::

   !theme plain
   package "GPS-Denied Challenges" as challenges #LightBlue {
   }
   rectangle "No GPS Signal" as gps #LightSalmon
   rectangle "Repetitive Geometry" as geo #LightGreen
   rectangle "Dust and Moisture" as dust #GreenYellow
   rectangle "Dynamic Environment" as dynamic #LightBlue
   challenges --> gps
   challenges --> geo
   challenges --> dust
   challenges --> dynamic
   note bottom of gps
     No satellite line-of-sight
     ..
     True underground, indoors,
     or off-world
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

Think of it as giving robots the ability to explore and remember a
space the way you might explore and remember a building you've walked
through -- except they do it in pitch darkness, with laser precision,
and without ever needing a satellite signal.

Going Deeper
----------------

Everything above is the intuition-level picture. If you want to see it
actually built end-to-end -- real hardware, a real SLAM implementation,
not just the analogy -- `How to Make an Autonomous Mapping Robot Using
SLAM <https://www.youtube.com/watch?v=xqjVTE7QvOg>`_ (Kai Nakamura)
walks through a full project. Fair warning: it moves fast into real
implementation detail, so it's worth having the concepts above settled
first.
