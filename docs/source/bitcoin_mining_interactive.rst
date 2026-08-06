Bitcoin Mining: Play With It
==============================

"Miners verify transactions" and "mining uses hard math puzzles" are
easy to read past without ever seeing what actually happens. This
widget runs the real algorithm -- genuine SHA-256, computed live in
your browser, no simulation -- at a small enough difficulty to watch
it happen in seconds instead of the ten minutes a real Bitcoin block
takes across the whole network.

Play With It
------------------

A small blockchain gets mined in front of you, one block at a time.
Once it's built, edit an old block's data and watch its hash change
instantly, its validity flip to red, and the block after it break too
-- even though you never touched that one. Then hit "Repair" and watch
the widget actually redo the proof-of-work to fix it, one block at a
time, cascading forward exactly the way a real rewrite would have to.

.. raw:: html
   :file: _static/bitcoin_mining_widget.html

Why Tampering Is Expensive, Not Just Detected
-------------------------------------------------------

The important thing this widget makes concrete: catching a tampered
block is free (recompute a hash, compare two strings), but *fixing*
one costs real, unavoidable work. Every block after the tampered one
has to be re-mined too, because each one's validity depends on
correctly recording the hash of the block before it:

.. list-table::
   :header-rows: 1
   :widths: 30 35 35

   * - Action
     - Cost
     - Why
   * - Detecting the tamper
     - Instant
     - Just recompute one hash and compare it to what the next block
       recorded
   * - Fixing the tampered block
     - One proof-of-work search
     - Its data changed, so its old nonce no longer produces a
       qualifying hash -- a new one has to be found
   * - Fixing every block after it
     - One proof-of-work search *each*
     - Each one recorded the *previous* hash, which just changed --
       so each one is now broken too, all the way to the end

Scale this up to real Bitcoin's difficulty and block count, and
"rewrite the last 6 blocks" stops being a five-second click and
becomes a race against the combined computing power of every other
miner on the network still extending the real chain -- which is what
the 51% in "51% attack" actually refers to.

See Also
-------------

For the plain-language overview of the whole system -- distributed
ledgers, transaction broadcasting, and how Zcash's privacy model
compares -- see :doc:`bitcoin_distributed_ledgers_zcash`.
