Bloom Filters: Play With It
==================================

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
* See :doc:`cassandra_interactive` for the LSM-tree write path these
  per-SSTable filters actually sit on top of -- memtables, SSTables,
  and compaction, with a live read-amplification counter that shows
  exactly what a Bloom filter is saving you from checking.
