Singleton: Thread-Safe Static Init, Play With It
===================================================

C++11's function-local static variables are guaranteed thread-safe to
initialize -- exactly once, no matter how many threads race to call
``getInstance()`` at the same moment. This is the mechanism itself,
side by side with the naive unsynchronized pattern it replaced.

.. raw:: html
   :file: _static/cpp_singleton_widget.html
