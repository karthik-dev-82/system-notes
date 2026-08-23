Apache Kafka: Play With It
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

New to Kafka? Start here -- this page builds up the concepts one at a
time before you touch the interactive demo, so nothing in it assumes
you've used Kafka (or any message queue) before.

What Is Kafka?
------------------

Picture a post office that receives millions of letters a second.
Kafka is the sorting system behind it:

* It takes in messages from many senders at once.
* It organizes them into named categories (**topics**) -- think
  "Weather Updates" or, in the demo below, "sensor-readings".
* It makes sure everyone who wants a copy of a message gets one, even
  if they show up to read it at very different times.

The one habit worth unlearning before anything else: **Kafka doesn't
delete a message once someone has read it.** A normal queue is more
like a physical mailbox -- once you take the letter out, it's gone.
Kafka keeps every message around (for a configured retention period),
so a message can be read once, twice, or replayed from the beginning
days later. That single difference is why Kafka can do things a
simple queue can't: broadcast the same data to several independent
systems, and let any of them rewind and reprocess history.

Where Kafka Actually Gets Used
------------------------------------

* **Netflix** tracks what you're watching, in real time, to update
  recommendations.
* **Uber** streams the live location of every car and rider.
* **Banks** process transactions as a continuous stream rather than
  one-at-a-time requests.
* **IoT platforms** collect readings from thousands of sensors --
  exactly the scenario this page's demo uses.

Key Terms
--------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 40 40

   * - Term
     - What it means
     - Post office analogy
   * - Producer
     - Sends messages into a topic
     - Person mailing a letter
   * - Topic
     - A named category of messages
     - A category of mail (bills, ads, personal letters)
   * - Partition
     - One ordered, append-only log within a topic
     - One physical mail slot -- a topic is split across several of
       these for parallelism
   * - Consumer
     - Reads messages from a topic
     - Person checking a mailbox
   * - Consumer Group
     - A team of consumers that splits up the work of reading a topic
     - A family sharing one set of mailboxes between them
   * - Offset
     - A message's position within its partition -- and, separately,
       how far a consumer group has read
     - The tracking number on a specific piece of mail
   * - Broker
     - A Kafka server that stores partitions
     - The post office building itself
   * - Leader
     - The one replica of a partition that all reads and writes
       actually go through
     - The one mail slot clerks and customers actually use
   * - Follower
     - A replica that continuously copies the leader, ready to take
       over if it fails
     - A backup clerk shadowing the main one, ready to take the
       counter
   * - ISR (in-sync replicas)
     - The subset of replicas caught up closely enough to the leader
       to be trusted with taking over
     - Backup clerks who've actually kept up with today's mail, not
       ones who wandered off

The One Idea Everything Else Builds On
---------------------------------------------

A topic isn't one big pile of messages -- it's split into several
**partitions**, and each partition is its own strictly ordered,
append-only log. When a producer sends a message with a **key** (a
sensor ID, a user ID, whatever identifies "who this message is
about"), Kafka hashes that key to pick exactly one partition, every
time. The practical effect:

* Every message from the **same key** always lands in the **same
  partition**, in the exact order it was sent -- so per-key ordering
  is guaranteed.
* Messages from **different keys** can land in different partitions,
  and Kafka makes **no promise at all** about their order relative to
  each other.

That trade-off -- strict order *within* a key, no order guarantee
*across* keys -- is what lets Kafka split work across many partitions
(and many consumers) without losing the one ordering guarantee that
usually matters: what happened to *this* sensor, in what sequence.

Play With It
------------------

A topic with 3 partitions, fed by 4 sensors. Send a reading and watch
which partition it lands in -- send from the same sensor again and
watch it land in that exact same partition every time. Then poll with
the two starter consumer groups (each gets its own full copy of every
message), add a second consumer to one of them, and watch the
partitions get reassigned live without either consumer losing its
place.

.. raw:: html
   :file: _static/kafka_topic_widget.html

Walking Through What You Just Saw
----------------------------------------

* **Sending a reading** is the producer step -- the widget hashes the
  sensor ID you picked to choose a partition, exactly like a real
  Kafka client would.
* **The partition columns** are the actual partitions -- each one is
  its own ordered log, offsets counting up from 0.
* **The two starter groups** (``dashboard-group`` and
  ``alerting-group``) each maintain their *own* read position. Polling
  with one never affects what the other can still read -- that's the
  "everyone gets their own copy" behavior a plain queue doesn't give
  you.
* **"+ Add consumer"** simulates a new consumer joining a group. Kafka
  calls this a **rebalance**: the group's partitions get redivided
  among however many consumers are now in it. The widget's log
  explicitly confirms the one thing that's easy to assume breaks here
  and doesn't: nobody's read progress resets. The offset belongs to
  the *group's* tracking of that partition, not to whichever consumer
  instance happens to be reading it at the moment -- which is exactly
  why two different groups (``dashboard-group`` and
  ``alerting-group``) can each be at a completely different offset on
  the same partition.
* **"Replay from start"** resets a group's offsets back to zero. Since
  Kafka never deleted anything to let you read it the first time,
  this is all it takes to reprocess an entire topic's history from
  scratch.

When to Use Kafka (and When Not To)
-------------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 50 50

   * - Good fit
     - Not a good fit
   * - Live sensor/IoT data, clickstream and activity tracking
     - Storing files like photos or videos -- use object storage
   * - Financial transactions, order/payment events
     - A small app with a handful of users -- Kafka is real
       infrastructure to run and operate
   * - Log aggregation from many servers into one stream
     - Direct one-to-one messaging between two people -- simpler
       tools exist for that
   * - Feeding the same event stream to several independent systems
       (analytics, a dashboard, an alerting system) at once
     - Data that rarely changes -- a database already fits that better

Replication and Leader Election
--------------------------------------

Everything above treats a partition as if it just lives on one broker
forever. In production it's replicated across several, and that
replication has its own state machine -- one broker is the **leader**
for a given partition (every read and write for that partition goes
through it), the rest are **followers** that continuously fetch from
the leader to stay caught up. The set of replicas caught up closely
enough to be trustworthy is the **ISR** (in-sync replicas). When the
leader dies, one of two things happens, and which one is a config
choice, not an accident:

Play With It: Kill the Leader
--------------------------------------

.. raw:: html
   :file: _static/kafka_replication_widget.html

Kill the leader with **unclean.leader.election.enable** off (the
default, and has been since Kafka 0.11) and, if no follower was fully
caught up, the partition simply goes **unavailable** for writes rather
than risk silently losing data -- notice the banner and the rejected
produces. Turn the checkbox on, kill the leader again under the same
lagging-follower setup, and this time a stale replica gets promoted
anyway: the partition stays available, but whatever the old leader had
that the new one doesn't is gone. Read that back and it's exactly the
:doc:`CAP theorem <cap_theorem_interactive>` widget's AP-vs-CP choice,
under its real Kafka name -- refuse and stay correct, or serve and risk
correctness, decided per-partition by a config flag most people never
look at until an outage forces the question. ``min.insync.replicas``
paired with ``acks=all`` is Kafka's other half of that same choice,
enforced on the write path instead of the failover path: it rejects a
write outright the instant the ISR can't durably absorb it, rather
than ever accepting one it can't back up.

Reading the Log Divergence
--------------------------------

After forcing an unclean election, restart the deposed old leader and
click **Catch Up** on it. Its log doesn't grow to merge with the new
leader's -- it gets **truncated** down to match, even though the old
leader objectively had more messages. That's real Kafka replication
protocol behavior, not a simplification for this widget: a follower
always truncates its own log to the current leader's before fetching
forward, because the leader's log is authoritative by definition,
regardless of which broker has "more" data sitting on disk. Whatever
got discarded wasn't secretly kept anywhere -- it's exactly the
messages the election result already told you were lost.

A Minimal Real Producer and Consumer
-------------------------------------------

Once the concepts click, a real Kafka client looks like this
(``pip install kafka-python``, and an actual Kafka broker running
somewhere):

.. code-block:: python

   from kafka import KafkaProducer
   import json

   producer = KafkaProducer(
       bootstrap_servers=['localhost:9092'],
       value_serializer=lambda v: json.dumps(v).encode('utf-8'),
   )
   producer.send('sensor-readings', key=b'S1', value={'tempC': 22})
   producer.close()

.. code-block:: python

   from kafka import KafkaConsumer
   import json

   consumer = KafkaConsumer(
       'sensor-readings',
       bootstrap_servers=['localhost:9092'],
       group_id='dashboard-group',
       value_deserializer=lambda v: json.loads(v.decode('utf-8')),
   )
   for message in consumer:
       print(message.partition, message.offset, message.value)

Notice ``group_id`` is the only thing that decides which consumer
group this process belongs to -- everything about partition
assignment and offset tracking that the widget makes visible happens
automatically, based on that one string.

See Also
-------------

See :doc:`hash_load_balancer_interactive` and
:doc:`consistent_hashing_interactive` for the same "spread work across
several owners by hashing a key" idea applied to load balancing rather
than a message log -- the underlying trade-off (same key, same owner,
every time) is the same one driving Kafka's partitioning here.

See :doc:`cap_theorem_interactive` for the abstract version of the
availability-vs-consistency choice the replication widget above makes
concrete -- same tradeoff, same "which side gets to keep serving"
question, worked through on a real 2-node store instead of a Kafka
partition.

See :doc:`architectural_patterns` for where this fits in the bigger
picture -- Kafka is this site's deepest worked example of the
event-driven shape, where producers and consumers are decoupled in
time rather than blocking on each other's response.
