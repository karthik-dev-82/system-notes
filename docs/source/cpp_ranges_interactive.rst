C++20 Ranges: Play With It
=================================

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
