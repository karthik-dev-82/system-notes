Consistent Hashing: Play With It
================================

:doc:`hash_load_balancer` establishes the numbers: going from 3 to 4
servers reshuffles 75% of users under naive modulo hashing, but only
about 25% under consistent hashing. This page is the mechanism behind
that second number, made visible -- a real ring, with real servers and
keys placed on it by hashing their names, where you can add and remove
servers yourself and watch exactly which keys move.

Play With It
------------------

Both servers and keys are placed on the same ring by hashing their
names down to a position on it. Every key belongs to whichever server
comes next going clockwise. Add a server and watch only the keys in
its new slice of the ring move to it; remove one and watch only its
former keys get picked up by whoever's next -- everyone else on the
ring never even notices.

.. raw:: html
   :file: _static/consistent_hash_widget.html

Reading the Comparison Panel
------------------------------------

Every time you add or remove a server, the panel on the right computes
*two* numbers for that exact same event: what naive modulo hashing
(``key_hash % server_count``, recomputed from scratch) would have
done, versus what actually happened on the ring -- each measured
against a large hidden sample of keys, not just the handful drawn as
dots, so the numbers are stable across reloads rather than swinging
with which few keys happen to be visible.

The part that reliably holds is the *order of magnitude*: naive
modulo always reshuffles the large majority of keys, consistent
hashing always reshuffles dramatically fewer. The exact
consistent-hashing percentage moves around more than the "~25%"
headline figure suggests, though -- with only a handful of real
servers, exactly how much ring space the new or removed server ends
up owning is genuine variance, not measurement error, and it gets
worse at low virtual-node counts (see below). That's not a canned
statistic -- it's the same comparison from :doc:`hash_load_balancer`
recomputed live, so you're seeing the real spread, not a number
tuned to always land on the textbook figure.

Why the Virtual-Node Slider Matters
--------------------------------------------

Set virtual nodes to 1 and hit Reset a few times: the "keys per
server" bars can come out quite lopsided, purely because of where each
server's single ring position happened to land -- one server might
own a huge arc, another a tiny sliver, entirely by chance of the hash.
That's not a flaw in the demo; it's the real, documented weakness of a
naive one-point-per-server ring. Turn virtual nodes up and each server
gets spread across many small arcs instead of one big one, and the
totals balance out far more reliably -- the same fix real systems
(Cassandra, DynamoDB-style partitioning, most CDNs) actually use, often
with virtual node counts in the hundreds per physical server.

See :doc:`hash_load_balancer` for the modulo-hashing walkthrough this
page builds on, including the exact 75%-vs-25% figures and the
production use cases (sticky sessions, cache routing, CDN edge
selection) that make any of this matter in the first place.

See :doc:`kafka_topic_interactive` for the same "same key, same owner,
every time" hashing idea applied to a message log instead of a server
ring -- Kafka's partition routing is a simpler, fixed-partition-count
cousin of the reshuffling problem this page solves for servers.
