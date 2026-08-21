C++20 Ranges: Play With It
=================================

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

:doc:`cpp_move_semantics_interactive` showed one way modern C++ avoids
unnecessary copies: transferring ownership instead of duplicating
data. Ranges show another: a ``std::views`` pipeline never copies the
underlying container at all. Each stage is a thin, composable window
over whatever came before it, and none of them run until something
actually asks for a value.

The Conveyor Belt
------------------------

.. raw:: html
   :file: _static/cpp_ranges_widget.html

Build a pipeline above, then click **Step**. Nothing happens when you
change a stage's predicate or add a new one -- the pipeline is just a
description at that point, and the banner says so explicitly: "0 calls
made so far." Only **Step** or **Materialize** actually pulls a value,
and pulling triggers exactly the stages needed to produce it, in
order, visible in the event log below.

Laziness Is Guaranteed; the Exact Call Count Isn't
---------------------------------------------------------------------

The default pipeline here -- ``filter(even) | transform(square) |
take(3)`` over ``{1..10}`` -- is lifted directly from a real C++20
program, and compiling that exact program (GCC 13, ``-std=c++20``)
confirms two things this widget models faithfully: zero calls happen
before the loop starts, and the loop never touches all ten source
elements. ``take(3)`` really does short-circuit the upstream filter
and transform.

What it *doesn't* model exactly is the number of times the predicate
gets called while short-circuiting. This widget's pull-based model
calls the filter predicate the textbook-minimal number of times needed
to find each match. Real GCC calls it a bit more than that -- 8 times
here, not 6 -- because ``filter_view``'s iterator eagerly searches
ahead to the *next* matching element on every ``++``, rather than
waiting until that element is actually asked for. Both behaviors are
legitimately "lazy" in the sense the standard guarantees (nothing
before iteration, no full materialization); only the exact call count
is an implementation detail, not a portable guarantee. If you rely on
a predicate's side effects for anything other than its return value,
that's worth knowing before you find out the hard way.

Order Changes the Answer, Not Just the Speed
---------------------------------------------------------------------

Rebuild the pipeline as ``filter(even) | take(3)`` and you get
``2 4 6``. Swap the order to ``take(3) | filter(even)`` and you get
just ``2`` -- because ``take`` already cut the input down to
``{1, 2, 3}`` before ``filter`` ever saw elements 4 through 10. This
isn't a quirk of the widget's model; it's exactly what real
``std::views`` pipelines do, verified against compiled g++ output for
every ordering this widget lets you build, including
``views::reverse | views::take(3)`` (``10 9 8``) and
``views::drop(3) | views::filter(even)`` (``4 6 8 10``). A ``|``
pipeline reads top to bottom like a sentence, but it's still function
composition -- the order of composition matters exactly as much as it
would with nested function calls.

Views Describe Work; Actions Do It
---------------------------------------------------------------------

Everything above is a *view*: lazy, non-owning, and inert until
iterated. The pipeline builder's **Materialize all (eager)** button
still doesn't change that -- it just pulls every remaining value in
one click instead of one at a time. The real eager/lazy line in C++ is
between views and *actions* -- ``std::ranges::sort``,
``std::ranges::copy``, or a container constructor -- which run
immediately and produce a concrete result the moment you call them,
because they aren't views at all. ``std::ranges::to<std::vector>()``
is the modern C++23 spelling of "materialize this view into a
container," but check your toolchain before reaching for it: it
compiles under ``-std=c++23`` with GCC 14's libstdc++, but not with
GCC 13's, even under the same flag (confirmed by trying it). The
portable eager alternative, working since C++20, is a plain
constructor: ``std::vector<int> vec(view.begin(), view.end());``.

A View Can Outlive What It Points At
---------------------------------------------------------------------

The pipeline above always operates on a vector that outlives it, so
there's nothing to go wrong. The second demo on this page shows the
case where that's not true: a function that builds a view over a
*local* container and returns the view, not the container. The view
doesn't copy what it's looking at -- it stores a reference -- so once
the function returns and that local variable's stack frame is
destroyed, the view is left pointing at freed memory. Nothing about
this fails to compile; the type system has no way to know the
container won't outlive the view over it. Compiling that exact
scenario with ``-fsanitize=address`` confirms it's not a theoretical
concern -- it's a real, reported ``stack-use-after-return`` the moment
the caller iterates the dangling view.

Common Views at a Glance
---------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - View
     - What it does
   * - ``views::filter(pred)``
     - Keep only elements where ``pred`` returns true
   * - ``views::transform(fn)``
     - Map each element through ``fn``
   * - ``views::take(n)``
     - Stop after the first ``n`` elements
   * - ``views::drop(n)``
     - Skip the first ``n`` elements
   * - ``views::reverse``
     - Iterate back to front (needs a bidirectional range)
   * - ``views::take_while(pred)``
     - Stop at the first element where ``pred`` fails
   * - ``views::iota(a, b)``
     - Generate ``a, a+1, ..., b-1`` lazily, with no backing container at all

See :doc:`cpp_move_semantics_interactive` for the other half of "avoid
the copy" in modern C++ -- transferring ownership of something you
already own, rather than never materializing it in the first place.
