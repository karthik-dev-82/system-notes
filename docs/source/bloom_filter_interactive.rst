Bloom Filters: Play With It
==================================

A Bloom filter answers exactly one question -- "have I possibly seen
this before?" -- using a fixed-size bit array instead of storing the
actual items. It trades a small, tunable chance of a wrong "maybe" for
a huge memory saving, and it comes with a guarantee most data
structures don't bother making explicit: it can never wrongly say no.

The Core Idea
--------------------

* Start with an array of ``m`` bits, all zero.
* To **add** an item, run it through ``k`` different hash functions,
  each producing a position in the array, and set all ``k`` of those
  bits to 1.
* To **test** an item, hash it the same ``k`` ways and check those
  positions. If *any* of them is still 0, the item was **definitely
  never added** -- one of its bits would have to be set otherwise. If
  *all* of them are 1, the item is **probably** in the set -- but
  those bits could have all been set by *other* items' insertions
  landing on the same positions by coincidence.

That asymmetry is the entire trick: false negatives are structurally
impossible (bits only ever get set, never cleared), while false
positives are a real, quantifiable, tunable probability.

Play With It
------------------

.. raw:: html
   :file: _static/bloom_filter_widget.html

Reading the False-Positive Panel
---------------------------------------

The formula shown, ``p ≈ (1 - e^(-kn/m))^k``, is the standard textbook
estimate for a Bloom filter's false-positive rate given ``m`` bits,
``k`` hash functions, and ``n`` items inserted. The widget doesn't just
state it -- click **Run 2,000 Random Probes** after adding a few dozen
words and watch the *measured* rate (real hash collisions on a real
bit array, testing strings that were genuinely never added) converge
toward what the formula predicts. They won't match to the decimal --
the formula assumes perfectly uniform, independent hashing, and this
widget's ``k`` hash functions are derived from combining just two real
ones (a real, standard technique called Kirsch-Mitzenmacher double
hashing, not an approximation invented for this demo) -- but the order
of magnitude holds up, which is the actual claim worth trusting from
either the formula or a real implementation.

Shrink ``m`` or push ``k`` up past its useful point (after inserting a
few dozen words) and watch the measured rate climb -- there's a real
optimal ``k`` for a given fill ratio, ``k = (m/n) ln 2``: too few hash
functions waste the array's ability to discriminate between items, too
many set bits faster than they gain any real selectivity.

Where This Shows Up
--------------------------

* **Chrome's Safe Browsing** used a Bloom filter to avoid a network
  round-trip for every URL you visit -- most URLs are obviously safe,
  and only a "maybe malicious" result needs a real lookup.
* **Cassandra and HBase** keep one Bloom filter per on-disk table
  file, so a read for a key that isn't in that file can skip the disk
  read entirely instead of seeking through it to find nothing.
* **Bitcoin light clients (SPV nodes)** used Bloom filters to ask full
  nodes for only the blocks that might contain a wallet's transactions,
  without revealing exactly which addresses the wallet cared about.
* See :doc:`rate_limiting_interactive` for another "cheap gate in
  front of an expensive resource" primitive that's frequently deployed
  in the same request path -- a Bloom filter to skip obviously-invalid
  keys for free, a rate limiter to cap how many requests get through
  at all.
* See :doc:`consistent_hashing_interactive` for the other place this
  page's FNV-1a hash function shows up on this site -- a reminder that
  "a good general-purpose string hash" is reusable infrastructure, not
  a one-off choice per data structure.
