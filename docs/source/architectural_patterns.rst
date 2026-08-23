Architectural Patterns: The Shapes Systems Take
=======================================================

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

Everything else in the System Design section is a **technique** --
sharding, caching, rate limiting, consensus. This page is one level up:
the **shapes** a system can take, within which those techniques get
applied. A microservice architecture can shard its data; an
event-driven system can use consistent hashing; the techniques aren't
tied to one shape. Five shapes, each with a real trade-off and a link
to where it already shows up on this site.

Client-Server: The Default Shape
--------------------------------------------

One or more clients send requests to a server (or a cluster of them);
the server processes and responds. This is the shape almost every
other page on this site quietly assumes -- :doc:`rest_api_interactive`,
:doc:`tcp_udp_interactive`, :doc:`dns_resolution_interactive` are all
client-server underneath.

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor Client1
   actor Client2
   rectangle Server #LightBlue
   Client1 -> Server : request
   Server -> Client1 : response
   Client2 -> Server : request
   Server -> Client2 : response

**The trade-off:** simple to reason about -- one place to look when
something's wrong -- but the server is a single scaling and failure
unit. Everything in :doc:`hash_load_balancer_interactive` and
:doc:`consistent_hashing_interactive` exists to turn "the server" into
"a pool of servers" without the client having to know or care.

Microservices: Client-Server, Decomposed
------------------------------------------------

Instead of one server handling everything, the backend is split into
many independently-deployable services, each owning its own data,
talking to each other over the network instead of in-process function
calls.

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor Client
   rectangle "API Gateway" as gw #LightBlue
   rectangle "Orders Service" as orders #LightSalmon
   rectangle "Inventory Service" as inv #LightGreen
   rectangle "Payments Service" as pay #LightYellow
   Client -> gw
   gw -> orders
   orders -> inv : "check stock"
   orders -> pay : "charge card"

**The trade-off:** each service can be deployed, scaled, and owned
independently -- but a single client request can now fan out into
several network calls instead of one function call, and a transaction
that used to be one database commit is now a coordination problem
across services. :doc:`rest_vs_rpc_interactive` covers how those
inter-service calls actually work and what happens when one is slow or
fails. :doc:`rate_limiting_interactive` becomes something each service
needs on its own inbound traffic, not just the edge. **One real gap
worth naming honestly:** at real scale, services need a way to find
each other's current network location as instances come and go --
service discovery -- which doesn't have its own deep-dive on this site
yet.

Serverless: No Server to Reason About At All
------------------------------------------------------

Code runs as functions triggered by events (an HTTP request, a queue
message, a schedule), and the platform handles provisioning and
scaling -- there's no server to patch, size, or keep warm yourself.

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor Client
   rectangle "Event Source\n(HTTP / Queue / Schedule)" as trigger #LightBlue
   rectangle "Function\n(spun up on demand)" as fn #LightGreen
   Client -> trigger
   trigger -> fn : invoke
   fn -> trigger : result

**The trade-off, and it's a real one, not a footnote:** a function
that hasn't run recently has no warm execution environment sitting
around -- the platform has to provision one from scratch before your
code runs at all. This is a **cold start**, and it's the single most
cited criticism of the model: the exact same code can respond in
single-digit milliseconds on a warm invocation and take an order of
magnitude longer (sometimes much more, depending on runtime and
package size) on a cold one. You pay per invocation instead of for an
always-on server, which is a genuine cost win for spiky or low-traffic
workloads and a genuine latency risk for anything that can't tolerate
an occasional slow first hit.

Event-Driven: Decoupled in Time, Not Just Space
------------------------------------------------------------

Components communicate by publishing and reacting to events instead of
calling each other directly. A producer doesn't know or care who's
listening, or when they'll get around to processing the event -- that
decoupling is the entire point.

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "Order Service\n(producer)" as prod #LightBlue
   queue "order-placed" as topic
   rectangle "Email Service" as email #LightGreen
   rectangle "Inventory Service" as inv #LightSalmon
   rectangle "Analytics Service" as an #LightYellow
   prod -> topic : publish
   topic -> email : consume
   topic -> inv : consume
   topic -> an : consume

This is exactly what :doc:`kafka_topic_interactive` demonstrates in
real depth -- partitions, consumer groups, and what happens to
delivery guarantees when a broker dies. Contrast it directly against
request/response: in the client-server and microservices shapes above,
the caller is blocked waiting for an answer; here, the producer moves
on immediately and has no idea how many consumers exist or when
they'll process the event. :doc:`long_poll_vs_ws_interactive` covers
the opposite problem -- how a *client* finds out an event happened
without the server needing to know the client's address at publish
time.

Peer-to-Peer: No Privileged Node At All
------------------------------------------------

Every node can act as both client and server; there's no central
coordinator that everything else depends on.

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "Node A" as a #LightBlue
   rectangle "Node B" as b #LightGreen
   rectangle "Node C" as c #LightSalmon
   rectangle "Node D" as d #LightYellow
   a <-> b
   a <-> c
   b <-> d
   c <-> d
   b <-> c

**The trade-off:** no single point of failure and no central
bottleneck to scale -- but no single source of truth either, which
means the hard problems (how do you find peers at all, how do you
agree on shared state, how do you stop a bad actor from lying) all
move from "ask the server" to "the protocol itself has to solve this."
:doc:`bitcoin_distributed_ledgers_zcash` is a real, worked P2P system
where every participant holds an identical copy of the ledger instead
of trusting one central bank. :doc:`consistent_hashing_interactive`
covers the exact mechanism (a hash ring) that real P2P systems like
Chord-style DHTs use to answer "which peer is responsible for this
piece of data" without any central directory.

At a Glance
------------------

.. list-table::
   :header-rows: 1
   :widths: 16 21 21 21 21

   * - Pattern
     - Coupling
     - Scaling unit
     - Failure characteristic
     - On this site
   * - Client-Server
     - Client knows the server's address
     - The server (vertically, or a pool behind a load balancer)
     - Server down = every client blocked
     - :doc:`rest_api_interactive`
   * - Microservices
     - Services know each other's APIs
     - Each service independently
     - One service down = only its dependents blocked
     - :doc:`rest_vs_rpc_interactive`
   * - Serverless
     - Caller knows the trigger, not the runtime
     - Automatic, per-invocation
     - Cold start latency, not downtime
     - (no dedicated page yet)
   * - Event-Driven
     - Producer doesn't know consumers exist
     - Consumers scale independently of producers
     - A stuck consumer delays itself, not the producer
     - :doc:`kafka_topic_interactive`
   * - Peer-to-Peer
     - No node is privileged
     - Adding peers adds capacity directly
     - No single point of failure; consistency is the hard part
     - :doc:`bitcoin_distributed_ledgers_zcash`

Remember
------------

#. These are shapes, not techniques -- sharding, caching, and
   consensus apply *within* any of them, not instead of them.
#. Client-server and microservices are both request/response;
   event-driven is the real alternative to "the caller waits for an
   answer."
#. Serverless's real cost isn't money, it's the cold-start tail
   latency on infrequently-invoked functions.
#. Peer-to-peer trades away a single point of failure for having to
   solve peer discovery and consistency without any central authority
   to defer to.

See Also
--------------

:doc:`consistent_hashing_interactive`, :doc:`kafka_topic_interactive`,
and :doc:`bitcoin_distributed_ledgers_zcash` for the deepest existing
worked examples of the event-driven and peer-to-peer shapes on this
site. :doc:`rest_vs_rpc_interactive` and :doc:`rate_limiting_interactive`
for the inter-service mechanics microservices architectures depend on.
