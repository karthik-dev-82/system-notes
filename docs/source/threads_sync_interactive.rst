Threads & Synchronization: Play With It
==============================================

:doc:`threads_processes_synchronization` covers what a mutex, a
semaphore, a condition variable, and a deadlock *are*. This page is
about actually *driving* them -- for the two trickiest ideas (race
conditions and deadlock), you control the exact order the threads
take their steps yourself, including trying to construct the bug on
purpose.

Play With It
------------------

Four scenarios, deliberately in the order they motivate each other:

1. **Race Condition** -- two threads incrementing a shared counter, with
   full manual control over which thread takes its next micro-step.
   Step them yourself and try to cause the bug, or press the demo
   button for a guaranteed one. Flip to "With Mutex" and notice you
   *can't* cause it no matter how you order the steps.
2. **Semaphore Slots** -- a counting semaphore with an adjustable
   number of slots. Turn it down to ``N=1`` and watch it become,
   exactly, a mutex.
3. **Condition Variable** -- the same producer at the same pace, with
   the consumer either busy-polling or genuinely asleep until
   notified. Watch the "checks performed" counter for the entire
   point of the exercise.
4. **Deadlock** -- two threads, two locks. In one mode you can
   construct a real deadlock; in the other, provably, you cannot.

.. raw:: html
   :file: _static/threads_sync_widget.html

Why Manual Stepping, Not Just an Animation
--------------------------------------------------

The race-condition and deadlock scenarios above let you click "Step
Thread A" / "Step Thread B" instead of just watching a fixed
animation, on purpose. The whole reason these bugs are dangerous in
real systems is that they depend on an interleaving you don't control
and usually can't reproduce on demand. Watching a canned animation of
"the bug happening" tells you it's possible; choosing the interleaving
yourself -- and noticing that plenty of *other* orders you could pick
give the right answer -- makes the actual danger click: it isn't that
unsynchronized code is always wrong, it's that it's only *sometimes*
wrong, on a schedule you don't get to see or test for. That's exactly
why these bugs pass code review and testing and then show up in
production under load.

The Common Thread
------------------------

All four scenarios are really one idea wearing different clothes:
**multiple threads touching shared state, and something has to
decide who goes when.**

* A mutex decides "exactly one, ever."
* A semaphore decides "up to N, at once" -- a mutex is just the
  ``N=1`` case, not a different mechanism.
* A condition variable adds "and let the ones who have nothing to do
  actually sleep instead of spinning."
* A deadlock is what happens when the "who goes when" rule itself
  contains a contradiction -- two threads each waiting on something
  only the other one can give up.

See :doc:`threads_processes_synchronization` for the C++ code
(``std::mutex``, ``std::counting_semaphore``,
``std::condition_variable``) behind each of these, and for how they
map onto the kitchen/restaurant analogies used throughout that page.
