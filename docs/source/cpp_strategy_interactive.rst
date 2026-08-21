Strategy Pattern: Play With It
=====================================

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

A checkout function that computes a cart's total shouldn't need to
know or care *how* the discount works -- only that whatever object
it's handed can produce a number from a cart. That's Strategy: pull
the algorithm out from behind an interface, and let the context
delegate to whichever implementation it's holding, without ever
branching on which one it is.

.. raw:: html
   :file: _static/cpp_strategy_widget.html

The Interface and the Context
------------------------------------

Every pricing algorithm above implements the same one-method
interface, and ``checkout()`` only ever calls that method -- it has no
idea "10% off" or "buy 2 get 1 free" exist:

.. code-block:: cpp

   struct PricingStrategy {
       virtual double calc(const Cart& cart) const = 0;
       virtual ~PricingStrategy() {}
   };

   struct NoDiscount : PricingStrategy {
       double calc(const Cart& cart) const override { return subtotalOf(cart); }
   };

   struct PercentOff : PricingStrategy {
       double pct;
       PercentOff(double p) : pct(p) {}
       double calc(const Cart& cart) const override { return subtotalOf(cart) * (1 - pct); }
   };

   struct Buy2Get1Free : PricingStrategy {
       double calc(const Cart& cart) const override {
           double total = 0;
           for (const auto& i : cart) {
               int free = i.qty / 3;
               total += i.price * (i.qty - free);
           }
           return total;
       }
   };

   double checkout(const Cart& cart, const PricingStrategy& strategy) {
       return strategy.calc(cart);   // never changes when a new strategy is added
   }

Every number in the widget's cart demo comes straight out of this
exact code -- ``{Widget: $12x3, Gadget: $25x1, Gizmo: $8x5}`` totals
``$101`` with no discount, ``$90.90`` at 10% off, and ``$81`` under buy-2-
get-1-free, verified with real ``assert()`` calls before this page ever
shipped.

The Payoff: What Adding a Strategy Actually Costs
---------------------------------------------------------------

The second panel in the widget shows the same four strategies written
as one function with an if/else chain instead. Both versions work
identically today -- the difference only shows up the moment a fifth
strategy needs adding. The branch-based version means reopening a
function that's already shipped and passing tests for the other four
cases, and every line of it lands back in your diff. The Strategy
version means writing one new, independent class; ``checkout()``
itself has zero new lines, because it was never coupled to *which*
strategies exist in the first place.

See :doc:`cpp_command_interactive`, :doc:`cpp_singleton_interactive`,
:doc:`cpp_observer_interactive`, and :doc:`cpp_decorator_interactive` for
the other modern-C++ pattern widgets in this series.
