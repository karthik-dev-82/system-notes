Watchdog Timer: Play With It
===================================

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

Imagine you're playing a video game and have to press a button every
10 seconds to prove you're still playing. If you don't -- maybe the
game froze -- the console automatically restarts it. That's exactly
what a **watchdog timer** does for a computer: a hardware countdown
that a program must keep resetting to say "I'm alive." If the program
crashes or freezes and stops resetting it, the watchdog forces a
reset.

The Basic Idea
--------------------

.. uml::

   !theme plain
   skinparam backgroundColor white
   participant "Your Program" as App
   participant "Watchdog Timer" as WDT
   WDT -> WDT: Start counting down from 10...
   note right: 10... 9... 8... 7...
   App -> WDT: "I'm alive!" (reset)
   WDT -> WDT: Start over from 10
   note right: Back to 10!
   App -> WDT: "I'm alive!" (reset)
   WDT -> WDT: Start over from 10
   == Program Crashes! ==
   WDT -> WDT: 10... 9... 8... 7... 6... 5... 4... 3... 2... 1... 0
   note right: No reset received!
   WDT -> App: RESTART THE COMPUTER!
   note right: Something went wrong!

Without a watchdog, a crashed program just sits there frozen forever
-- not good if it's controlling something important. With one, the
system automatically restarts itself and tries again.

Real-World Examples
--------------------------

**Wi-Fi router.** Code that must "pet the watchdog" every few seconds:

.. code-block:: c

   while (router_is_on) {
       check_internet();
       handle_wifi_connections();
       update_lights();

       pet_the_watchdog();  // "I'm still working!"
   }
   // If the router freezes (a bug), it stops petting the watchdog,
   // and the router automatically reboots itself.

If your router freezes, you don't have to unplug it -- the watchdog
restarts it for you.

**Mars rover.** The rover is millions of miles away; nobody can walk
over and press reset.

.. code-block:: c

   void main_loop() {
       while (1) {
           take_pictures();
           drive_around();
           send_data_to_earth();
           check_solar_panels();

           reset_watchdog();  // must do this every 30 seconds
       }
   }

Without a watchdog, a frozen rover computer is a dead mission. With
one, it reboots and keeps exploring.

**Microwave.** A tiny computer controls the heating element:

.. code-block:: c

   while (microwave_plugged_in) {
       check_buttons();
       control_heating();
       update_display();
       check_door_sensor();

       watchdog_kick();  // "Everything's fine!"
   }
   // If it freezes with heating ON, the watchdog forces a restart --
   // a real safety mechanism, not just a convenience.

**Heart monitor.** In a hospital, this must never silently stop:

.. code-block:: c

   void monitor_loop() {
       while (patient_connected) {
           read_heart_sensor();
           display_heartbeat();
           check_alarms();

           if (heartbeat_critical) {
               sound_alarm();
           }

           kick_watchdog();  // every 100 milliseconds
       }
   }

If the monitor freezes, the watchdog restarts it within 100ms so
doctors don't miss a critical alarm.

**Self-driving car.** The computer controlling the car must never
freeze mid-drive -- and here the watchdog's job isn't just "reboot,"
it's "hand off to something safe immediately":

.. uml::

   !theme plain
   skinparam backgroundColor white
   participant "Main Computer" as Main
   participant "Watchdog (Safety Chip)" as WDT
   participant "Backup System" as Backup
   Main -> WDT: Reset every 50ms
   note right: Normal driving
   Main -> Main: Process cameras
   Main -> Main: Control steering
   Main -> Main: Control brakes
   Main -> WDT: Reset timer
   == Computer Crashes! ==
   WDT -> WDT: 50ms passes... no reset!
   WDT -> Backup: EMERGENCY! Take over!
   Backup -> Backup: Safely stop the car
   note right: Pull over safely

This is a real pattern in safety-critical automotive systems: a
watchdog on a dedicated safety chip, wired not just to reboot the main
computer but to trigger a completely separate backup system to bring
the vehicle to a safe stop.

Play With It
------------------

.. raw:: html
   :file: _static/watchdog_timer_widget.html

The counter ticks down in real time. Click **Pet the Watchdog** before
it hits 0 to keep the program alive, or click **Freeze Program** to
simulate a crash and watch the reset fire on its own. Switch to
**Window Watchdog** mode and the green zone in the bar below the
counter is the *only* range where a pet is accepted -- petting inside
the hatched red zone is itself a fault, covered next.

How Long Should the Timeout Be?
--------------------------------------

Too short, and normal work doesn't have time to finish before the
timer resets it -- false alarms. Too long, and a real crash takes
forever to detect. Illustrative orders of magnitude for the examples
above:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 30 40 30

   * - Device
     - Example
     - Typical Watchdog Timeout
   * - Microwave
     - Kitchen appliance
     - ~1 second
   * - Wi-Fi router
     - Home networking
     - ~5 seconds
   * - Medical device
     - Heart monitor
     - ~100 milliseconds
   * - Mars rover
     - Space exploration
     - ~30 seconds
   * - Self-driving car
     - Safety-critical control
     - ~50 milliseconds

The Window Watchdog
--------------------------

A regular watchdog says "reset me anytime before I hit zero, I don't
care when." A **window watchdog** is pickier: "you must reset me
between, say, 3 and 7 seconds remaining -- not at 8, not at 2." This
is real hardware, not a teaching simplification -- it's how, for
example, STM32 microcontrollers' Window Watchdog (WWDG) peripheral
actually works, as a distinct peripheral from their simpler
Independent Watchdog (IWDG).

Petting too *early* (before the window opens) is treated as a fault
just like petting too *late* -- because a program that resets the
watchdog suspiciously early is often a sign that it skipped work it
was supposed to do, not that it's healthy. This is the real,
mechanism-level version of "don't pet too eagerly": in the widget
above, switch to Window Watchdog mode and click **Pet the Watchdog**
immediately after a reset -- you'll trigger an immediate too-early
fault, every time, because the counter hasn't dropped into the valid
window yet.

The Golden Rule
--------------------

The rule "only pet the watchdog once you have real evidence the
program is healthy" is correct and important -- but it's not really
about *code order* (pet-before-work vs. pet-after-work make little
practical difference in a single straight-line loop, since either way
a true infinite hang still gets caught within one timeout period). The
real anti-pattern is petting the watchdog from somewhere that runs
*unconditionally*, independent of whether the actual application logic
is making progress -- most commonly, kicking the watchdog from a
periodic hardware timer interrupt that fires on its own schedule no
matter what the main program is doing:

.. code-block:: c

   // BAD -- an independent timer interrupt keeps petting the watchdog
   // on its own schedule, whether or not the real program is stuck
   void timer_interrupt_handler() {
       pet_the_watchdog();  // fires every N ms no matter what
   }
   void main_loop() {
       while (1) {
           do_critical_work();  // can hang forever -- the ISR keeps
                                 // petting anyway, so the watchdog
                                 // never notices
       }
   }

   // GOOD -- the pet is gated on evidence the critical work actually
   // completed, in the same context that does the work
   void main_loop() {
       while (1) {
           do_critical_work();
           pet_the_watchdog();  // only reached if the work above returned
       }
   }

The window watchdog above is the sharper, hardware-enforced version of
this same idea: it doesn't just want *a* pet, it wants a pet that
arrives on a schedule consistent with real work actually happening.

Remember
------------

#. A watchdog is a countdown that a program must keep resetting; if it
   ever reaches zero, the system forces a reset -- the entire
   mechanism is "prove you're alive, or get restarted."
#. Pick the timeout to fit normal work: long enough that legitimate
   work never trips it, short enough that a real hang is caught
   quickly. A heart monitor and a Mars rover do not have the same
   answer.
#. A window watchdog rejects a pet that arrives too early, not just
   too late -- an unexpectedly early pet is often a sign of skipped
   work, not health.
#. The real danger isn't code order, it's petting the watchdog from
   somewhere that runs independently of whether the actual work is
   progressing -- an interrupt handler that pets on its own schedule
   defeats the entire mechanism.

See Also
--------------

:doc:`resilience_patterns_interactive` for the same "detect a failure
automatically and take a safe recovery action" idea at the
distributed-systems and software level, instead of a hardware
countdown. :doc:`priority_inversion_interactive` for another real,
mission-critical embedded reliability story. :doc:`can_arbitration_interactive`
for another hardware-level mechanism from the same corner of embedded
systems.
