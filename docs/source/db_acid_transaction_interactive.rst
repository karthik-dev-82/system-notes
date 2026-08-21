ACID Transactions: Play With It
====================================

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

     div.document div.admonition {
       background: #f7f6f2;
       border: 1px solid #cdd6cc;
       border-left: 4px solid #a67c1f;
       border-radius: 4px;
       padding: 14px 18px;
       margin: 4px 0 22px;
     }
     div.document div.admonition p.admonition-title {
       font-weight: 700;
       color: #a67c1f;
       margin: 0 0 8px;
       font-size: 0.72rem;
       letter-spacing: 0.06em;
       text-transform: uppercase;
     }
     div.document div.admonition p:last-child { margin-bottom: 0; }
     div.document div.admonition.warning,
     div.document div.admonition.attention,
     div.document div.admonition.caution { border-left-color: #b0432a; }
     div.document div.admonition.warning p.admonition-title,
     div.document div.admonition.attention p.admonition-title,
     div.document div.admonition.caution p.admonition-title { color: #b0432a; }
     div.document div.admonition.tip,
     div.document div.admonition.hint,
     div.document div.admonition.important { border-left-color: #3d5c3d; }
     div.document div.admonition.tip p.admonition-title,
     div.document div.admonition.hint p.admonition-title,
     div.document div.admonition.important p.admonition-title { color: #3d5c3d; }
   </style>

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

Play With It: Atomicity
--------------------------------

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

Isolation: The Other Half of ACID
----------------------------------------

Atomicity, above, is about one transaction: does it happen completely
or not at all. **Isolation** is a different question entirely: what
can *two transactions running at the same time* see of each other's
work before either one commits? Get this wrong and you don't get a
crash -- you get a number that's quietly wrong, which is worse.

There are four classic anomalies concurrent transactions can produce,
and four SQL isolation levels, each defined by which of those
anomalies it prevents:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 30 20 20 20 10

   * - Anomaly
     - Read Committed
     - Repeatable Read
     - Serializable
     - What it means
   * - Dirty read
     - Prevented
     - Prevented
     - Prevented
     - Reading another transaction's *uncommitted* write
   * - Non-repeatable read
     - Allowed
     - Prevented
     - Prevented
     - The same row read twice in one transaction returns two different values
   * - Phantom read
     - Allowed
     - Prevented
     - Prevented
     - The same query run twice in one transaction returns a different set of rows
   * - Write skew (serialization anomaly)
     - Allowed
     - Allowed
     - Prevented
     - Two transactions each make a decision from a snapshot that the other one is about to invalidate

Two of those cells are Postgres-specific, not SQL-standard minimums --
Postgres's dirty-read prevention holds even at the level *called*
"Read Uncommitted" (which Postgres just maps to Read Committed,
because its storage engine makes a dirty read structurally impossible
no matter what you ask for), and its Repeatable Read closes off
phantom reads too, which the standard doesn't actually require at that
level. The widget below doesn't just assert this table -- it runs the
real interleaving and lets you watch each cell get filled in yourself.

Play With It: Two Transactions, One Row
------------------------------------------------

.. raw:: html
   :file: _static/db_isolation_levels_widget.html

Pick **Write Skew** and run it at **Repeatable Read** first -- both
transactions read "2 doctors on call," both independently decide it's
safe to go off call, both commit, and the invariant ("at least one
doctor on call") silently breaks, even though neither transaction ever
saw the other's uncommitted data and neither read the same row twice
with different results. That's the specific gap snapshot isolation
(which is what Repeatable Read actually is, in Postgres and most other
real databases) doesn't close. Switch to **Serializable** and run the
exact same scenario again: this time the second commit gets rejected
outright with a serialization failure, and the invariant survives --
not because the database re-checked the business rule, but because it
noticed the two transactions' reads and writes formed exactly the
dependency cycle that makes their combination unsafe.

See Also
-------------

See :doc:`databases_postgresql_mongodb_redis` for the guide this
example comes from, including the original ``BEGIN
TRANSACTION`` / ``COMMIT`` SQL. See :doc:`db_index_scan_interactive`
and :doc:`db_redis_structures_interactive` for the other two widgets
in this series, built on the same dataset.

See :doc:`cap_theorem_interactive` for the distributed-systems version
of this same shape of question -- there, it's what a node does when it
can't reach another node it needs to stay consistent with; here, it's
what one transaction can see of another's in-flight work on the same
node. Different scale, same underlying tension between serving a
request now and guaranteeing the answer is actually correct.
