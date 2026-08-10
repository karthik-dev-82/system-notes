ACID Transaction Atomicity: Play With It
============================================

.. note::

   Third in a small series built on the same 20-country dataset from
   :doc:`databases_postgresql_mongodb_redis` (full table:
   :doc:`db_country_dataset`). See :doc:`db_index_scan_interactive` and
   :doc:`db_redis_structures_interactive` for the first two, and
   :doc:`db_composite_index_interactive` for a fourth, on composite
   indexes and the leftmost prefix rule.

The guide's own example for atomicity is inserting a new country and
its capital together: Kenya, then Nairobi. "If EITHER insert fails,
BOTH are cancelled." That line is doing a lot of work, and it's worth
taking apart exactly what it means -- because a foreign key already
stops a capital from ever pointing at a country that doesn't exist,
transaction or not. What a transaction protects against is something
subtler: the *first* statement's effect surviving even though the
*second* one never landed.

Play With It
------------------

Run the demo with a transaction wrapping both inserts, then force the
capital insert to fail and run it again -- watch Kenya disappear along
with Nairobi, even though the country insert had already succeeded on
its own. Then switch off the transaction and force the same failure:
Kenya stays in the table, flagged as a country with no matching
capital, because there was never anything to roll it back to.

.. raw:: html
   :file: _static/db_acid_transaction_widget.html

What a Transaction Actually Buys You
-------------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 30 35 35

   * - Scenario
     - With a transaction
     - Without one
   * - Both statements succeed
     - Both committed
     - Both committed -- no difference here
   * - Capital insert fails
     - Country insert is undone too -- back to exactly the
       pre-transaction state
     - Country insert stays committed -- a country with no capital now
       exists
   * - A genuine FK violation (capital referencing a country that
       truly doesn't exist)
     - Rejected immediately, transaction or not
     - Rejected immediately, transaction or not

That third row is the one easy to miss: the foreign key constraint
does its job regardless of transactions. No capital in this widget
can ever reference a country that isn't there -- that check runs on
every single insert. A transaction isn't what prevents a *dangling
reference*; it's what prevents a *half-finished change* from becoming
permanent.

Why "Run It Twice" Is Worth Trying
------------------------------------------

Run the demo once successfully, then click "Run" again without
resetting. Both modes now fail identically -- on the very first
statement, with a genuine duplicate-key error, because Kenya already
exists. There's nothing left to roll back or leave behind, so the
transactional and non-transactional paths converge. The interesting
difference only ever shows up when the *first* statement of a
multi-statement change has already succeeded and the *next* one
hasn't -- which is exactly the gap between "Kenya inserted" and
"Nairobi inserted" that the widget lets you force open.

See Also
-------------

See :doc:`databases_postgresql_mongodb_redis` for the guide this
example comes from, including the original ``BEGIN
TRANSACTION`` / ``COMMIT`` SQL. See :doc:`db_index_scan_interactive`
and :doc:`db_redis_structures_interactive` for the other two widgets
in this series, built on the same dataset.
