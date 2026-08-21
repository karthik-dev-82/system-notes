Bitcoin, Distributed Ledgers & Zcash Explained
=================================================

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
