Singleton: Thread-Safe Static Init, Play With It
===================================================

C++11's function-local static variables are guaranteed thread-safe to
initialize -- exactly once, no matter how many threads race to call
``getInstance()`` at the same moment. This is the mechanism itself,
side by side with the naive unsynchronized pattern it replaced.

.. raw:: html
   :file: _static/cpp_singleton_widget.html

Safe mode above is exactly this: a function-local ``static`` is
guaranteed by the standard to construct on only one thread, with every
other thread that arrives during construction blocking until it's
done rather than racing past it. Unsafe mode is the naive pattern that
guarantee replaced.

.. code-block:: cpp

   class Widget {
   public:
       static Widget& getInstance() {
           static Widget instance;   // constructed exactly once -- C++11 guarantees this is thread-safe
           return instance;
       }
       Widget(const Widget&) = delete;
       Widget& operator=(const Widget&) = delete;
   private:
       Widget() = default;
   };

   // The pre-C++11 pattern Unsafe mode reproduces -- not thread-safe:
   Widget* instance = nullptr;
   Widget* getInstanceUnsafe() {
       if (!instance) instance = new Widget();   // two threads can both see nullptr here...
       return instance;                          // ...and both construct; one gets silently orphaned
   }

See :doc:`cpp_command_interactive`, :doc:`cpp_observer_interactive`,
:doc:`cpp_strategy_interactive`, and :doc:`cpp_decorator_interactive` for
the other modern-C++ pattern widgets in this series.
