Bitcoin, Distributed Ledgers & Zcash Explained
=================================================

Bitcoin & Distributed Ledgers
------------------------------------

**The School Lunch Ledger Analogy:** Imagine your class keeps track of
who owes lunch money in a notebook. In a traditional system, one
teacher holds that notebook (centralized). With Bitcoin, every student
has an identical copy of the notebook, and when someone pays, everyone
updates their copy together (distributed).

.. uml::

   !theme plain

   package "Traditional Banking" #LightBlue {
   }

   note right of "Traditional Banking"
     One bank keeps ALL records
     ..
     You trust the bank
     ..
     Bank can freeze accounts
   end note

   package "Bitcoin Network" #LightGreen {
   }

   note right of "Bitcoin Network"
     Everyone has a copy of records
     ..
     No single authority
     ..
     Transparent and permanent
   end note

   "Traditional Banking" -down-> "Bitcoin Network": Evolution

How Bitcoin Works
------------------------

1. **Transaction Broadcasting** -- you announce "I'm sending 1 Bitcoin
   to Alice"
2. **Miners Verify** -- special computers (miners) check you actually
   have that Bitcoin
3. **Block Creation** -- verified transactions get bundled into a
   "block"
4. **Chain Connection** -- the new block connects to previous blocks
   (hence "blockchain")
5. **Network Agreement** -- everyone's ledger updates simultaneously

.. uml::

   !theme plain

   start
   :Transaction broadcast to network;<<#LightBlue>>
   :Miners verify transaction;<<#LightSalmon>>
   :Transaction added to block;<<#GreenYellow>>
   :Block added to chain;<<#LightGreen>>
   :Everyone's ledger updated;
   stop

Key Innovation: Proof of Work
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Mining uses hard math puzzles that require massive computing power.
This makes it incredibly expensive to fake transactions -- rewriting
history would require out-computing more than the rest of the honest
network combined, which is why this is often called the "51% attack"
threshold.

What is Zcash?
--------------------

Zcash is like Bitcoin's privacy-focused cousin.

**The Glass House vs. Regular House Analogy:**

* **Bitcoin** = a glass house where everyone can see your furniture
  (transactions are public)
* **Zcash** = a regular house with curtains (transactions can be
  private)

Zcash uses special cryptography called **zero-knowledge proofs** --
think of it as proving you have a key to a room without showing the
key itself.

.. uml::

   !theme plain

   rectangle "Bitcoin" #LightBlue
   rectangle "Zcash" #LightGreen

   note right of "Bitcoin"
     All transactions visible
     ..
     Everyone sees amounts
     ..
     Public addresses
   end note

   note right of "Zcash"
     Optional privacy
     ..
     Shielded transactions
     ..
     Hidden amounts and addresses
   end note

How Bitcoin and Zcash Relate
------------------------------------

Bitcoin and Zcash are not opposites -- they're both cryptocurrencies,
and their prices tend to move together with the broader crypto market
rather than offsetting each other the way, say, gold and stocks
sometimes do. What actually differs between them is transparency, not
market behavior:

* **Bitcoin** -- digital gold, widely accepted, transparent
* **Zcash** -- privacy-focused, smaller network, optional transparency

Think of it like regular mail (Bitcoin) vs. sealed envelope mail
(Zcash) -- both deliver letters, but one shows what you're sending.
