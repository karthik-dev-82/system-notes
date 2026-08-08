Apache Kafka: Play With It
==============================

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
  the *partition*, not to whichever consumer instance happens to be
  reading it at the moment.
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
