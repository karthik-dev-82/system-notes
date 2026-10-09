ADAM-6052: Play With It
==============================

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

The ADAM-6052 is a small box that sits between machinery and a
computer network. On one side, wires from switches, sensors and lamps
screw into it. On the other side, one Ethernet cable plugs in. That
lets a computer far away **see** whether something is on or off,
**count** how many times it pulsed, and **switch** things on or off.
It has 8 pins for listening (inputs) and 8 pins for acting (outputs).

The poster below goes in order, from the box itself outward: the
module, how an input is wired, what an input can do, counting a
spinning wheel, driving a load, the network, a full worked example
(a park-brake signal reaching both a dashboard and a lamp), and
cleaning up a bouncing switch. Every picture is clickable, and every
panel has a plain-words explanation underneath.

Play With It
------------------

.. raw:: html

   <iframe id="adamPoster" src="_static/adam_6052_poster.html"
           title="ADAM-6052 illustrated poster"
           style="width:100%; height:3000px; border:1px solid #cdd6cc; border-radius:4px; background:#ffffff;"
           loading="lazy"></iframe>
   <script>
   window.addEventListener('message', function (e) {
     var f = document.getElementById('adamPoster');
     if (f && e.source === f.contentWindow && e.data && e.data.adamPosterHeight) {
       f.style.height = (e.data.adamPosterHeight + 4) + 'px';
     }
   });
   </script>

The poster is also available on its own page:
`open the poster in a full window <_static/adam_6052_poster.html>`__.

The Questions Beginners Hit First
-----------------------------------------

**Does an input switching change an output?** No. An input and an
output are independent. An input changing updates the module's input
light and its stored value, which anything on the network can read. An
output only turns on when something tells it to: software sends a
command, a rule inside the module does it, or the module's
peer-to-peer feature passes an input to another ADAM's output.

**How does a dashboard get a signal?** Over Ethernet, not through an
output. The dashboard reads the input's value using Modbus TCP, or the
module publishes it as an MQTT message. An "output" here means a
physical pin that switches power to a load such as a lamp or a buzzer.

**What is the difference between dry and wet contact?** A dry contact
is a plain switch that carries no voltage of its own; open reads 1 and
closed to ground reads 0. A wet contact is a wire that already carries
voltage from a powered sensor; 10 to 30 volts reads 1 and 0 to 3 volts
reads 0. The module does not promise a correct reading between 3 and
10 volts.

**What does "source type" mean for an output?** When the output turns
on, the pin pushes voltage out, and the load connects from that pin to
ground. The opposite design, sink type, connects the load to ground
instead. Mixing the two up is a common wiring mistake.

What Is Not Confirmed
---------------------------

The module figures come from search results quoting an ADAM-6052
datasheet copy and distributor listings, not from Advantech's own PDF,
and several listings are for the ADAM-6052-D variant. Confirm against
the datasheet for your exact unit. Also not confirmed: whether the
inputs have a configurable filter, the exact steps to set up a rule or
a peer-to-peer mapping, and where the output power supply connects.

Remember
------------

#. An input listens and an output acts. They are separate, and nothing
   copies one to the other unless you set that up.
#. Data reaches a dashboard over Ethernet, not through an output pin.
#. Every input can be a plain on/off input, a counter, or a frequency
   input, up to 3 kHz (3,000 pulses per second).
#. A switch with moving contacts bounces. A debounce wait must be
   longer than the bounce, or one push counts as several.

See Also
--------------

:doc:`can_arbitration_interactive` for another hardware-level
mechanism from the same corner of embedded systems.
:doc:`watchdog_timer_interactive` for how a controller recovers when
it stops responding. :doc:`tcp_udp_interactive` for the TCP that
Modbus TCP runs on top of.
