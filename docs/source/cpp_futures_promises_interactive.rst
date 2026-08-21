Futures & Promises: Play With It
=======================================

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
   </style>

**Analogy:** a restaurant buzzer. You order (start the work), get a
buzzer (the future), and go do other things -- it lights up when the
food's ready. You only wait if you walk up to collect before it's done.

**Core idea:** the gentle entry into async C++. A future is a receipt
for a value you'll get later; a promise is the contract to provide it.
``std::async`` is the easy button that wires both up for you, without
touching ``std::thread`` or a mutex directly.

The Easy Way: ``std::async``
------------------------------------

.. code-block:: cpp

   #include <future>

   auto fut = std::async([]{ return 6 * 7; });  // starts work (maybe on a new thread)
   // ... do other stuff ...
   int answer = fut.get();   // blocks ONLY here, and only if not ready yet -> 42

``get()`` is the only place blocking can happen. Everything before it
runs free.

The Vocabulary
------------------

.. list-table::
   :header-rows: 1
   :widths: 22 30 48

   * - Thing
     - Role
     - Analogy
   * - ``std::future``
     - holds the result you'll receive
     - the buzzer
   * - ``std::promise``
     - the producer's end; sets the value
     - a signed contract
   * - ``std::async``
     - easiest way to launch async work
     - a delivery service
   * - ``get()``
     - wait (if needed) and take the value
     - pick up the order
   * - ``wait_for()``
     - wait with a timeout
     - "give it 5 minutes"

The promise writes once, the future reads once, through a shared
one-time channel.

Play With It
------------------

Both launch policies below run the exact rules described in this page
-- a real discrete-time simulation, not an animation timed to look
right.

.. raw:: html
   :file: _static/cpp_futures_promises_widget.html

Run Many in Parallel
------------------------

.. code-block:: cpp

   std::vector<std::future<int>> futs;
   for (int i = 1; i <= 5; ++i)
       futs.push_back(std::async(square, i));   // 5 tasks at once
   for (auto& f : futs)
       std::cout << f.get() << " ";              // collect results

Gotchas
------------

.. code-block:: cpp

   auto fut = std::async(calc);
   int a = fut.get();   // OK
   int b = fut.get();   // throws std::future_error -- the value was
                         // already moved out; the future is now invalid

``get()`` works once. The value moves out; calling it again throws.

Launch policy matters:

.. code-block:: cpp

   std::async(std::launch::async, work);     // forces a new thread
   std::async(std::launch::deferred, work);  // lazy -- runs on get(), same thread
   std::async(work);                         // implementation chooses -> can surprise you

If you actually want parallelism, pass ``std::launch::async``
explicitly.

A discarded ``std::async`` future blocks in its destructor -- the
returned future's destructor waits for the task to finish. "Fire and
forget" doesn't actually forget; it just moves the wait from ``get()``
to the closing brace. Don't ignore the return value expecting true
fire-and-forget.

.. note::
   There's a second, sneakier gotcha the widget above makes easy to
   trigger and easy to miss in prose: a ``std::launch::deferred``
   future that gets destroyed *before* anything ever calls ``get()``
   or ``wait()`` on it **never runs its work at all** -- not delayed,
   not queued behind something else, simply never executed. The
   deferred policy only runs the function the instant something
   actually asks for the result; if nothing ever does, nothing ever
   happens. This is real, documented ``std::async`` behavior, not an
   edge case invented for this page.

When NOT To
------------------

* You need fine control over threads, scheduling, or shared state --
  use threads and a mutex directly (see
  :doc:`threads_processes_synchronization`).
* The work is trivially fast -- ``async``'s overhead isn't worth it.

Remember
------------

#. Future = receipt; promise = the contract to fill it.
#. ``std::async`` is the easiest start.
#. ``get()`` blocks only when you call it -- and only once.
#. Pass ``std::launch::async`` if you truly want a separate thread.
#. Don't ignore the returned future -- its destructor may block, and a
   discarded *deferred* future may simply never run at all.
#. This is "easy async"; threads (:doc:`threads_processes_synchronization`)
   are the manual-control version.
