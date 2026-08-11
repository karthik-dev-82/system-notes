Strategy Pattern: Play With It
=====================================

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
