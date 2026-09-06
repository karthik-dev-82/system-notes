PyTorch Basics: Play With It
===================================

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
   </style>

Training a model is a loop: make a guess, measure how wrong it was,
figure out which direction reduces that wrongness, nudge the model
that way, and repeat thousands of times. PyTorch's whole job is
providing the machinery for that loop -- turning your data into
numbers, running the model's guess, and doing the calculus for you.
This page builds the smallest possible version of that loop for
real, not as an animation: an actual model, an actual loss, and
actual calculus, fitting an actual line to actual data.

Tensors: Everything Becomes a Grid of Numbers
--------------------------------------------------------

A tensor is just a grid of numbers -- a single number is a 0-D
tensor, a list is 1-D, a table is 2-D, and a stack of tables is 3-D
and beyond. The reason this matters: a photo becomes a grid of
pixel-brightness numbers, a sentence becomes a grid of word-code
numbers, sound becomes a grid of wave-height numbers -- and once
*anything* is a grid of numbers, the same fast, parallel hardware can
crunch all of it the same way. See :doc:`cpu_vs_gpu_interactive` for
exactly how much faster that grid-crunching gets once a problem is
big enough to be worth handing to a GPU.

Play With It
------------------

.. raw:: html
   :file: _static/pytorch_basics_widget.html

The dataset above -- six ``(x, y)`` points, shown as an actual 2-row
tensor -- is real, noisy data generated from an underlying
``y = 2x + 1`` relationship. The model is the simplest possible one:
``predict(x) = w*x + b``. Click **Step Once** to watch a single
forward pass, loss calculation, and gradient update happen, or
**Train 200 Steps** to watch ``w`` and ``b`` converge toward the true
2 and 1 while the loss curve drops.

Autograd: Real Calculus, Not a Black Box
------------------------------------------------

Training needs an answer to "which direction, and how much, do I
nudge each parameter to reduce the loss?" -- that's a derivative of
the loss with respect to each parameter, and PyTorch's *autograd*
computes it automatically instead of you deriving it by hand.
"Automatic" doesn't mean "trust me": click **Check Autograd** in the
widget above and it computes the gradient two completely different
ways at the model's current parameters -- once analytically (the
same closed-form derivative PyTorch's autograd would compute) and
once numerically, by nudging each parameter a tiny amount and
measuring how much the loss actually moved (a finite-difference
approximation of the same derivative). The two independent methods
agree to about nine decimal places. This is exactly the technique
PyTorch's own test suite (``gradcheck``) uses to verify that a
hand-written backward pass is genuinely correct calculus, not just
code that looks plausible.

From One Line to a Neural Network
------------------------------------------

``predict(x) = w*x + b`` is already a complete (if tiny) instance of
every piece a full neural network has: parameters to learn (``w``,
``b``), a forward pass, a loss, and a backward pass. A real network
stacks many of these -- called *layers* -- with a non-linear function
between them so the whole stack can bend into curves a single
straight line never could, rather than collapsing back into one big
linear equation. PyTorch ships pre-built layers (``Linear``, and many
others) specifically so you assemble that stack instead of
hand-deriving the calculus for every layer yourself -- but the loop
this page's widget runs (forward, loss, backward, update, repeat) is
identical to the loop training any of those larger networks, just
with more parameters and a longer gradient calculation.

Remember
------------

#. A tensor is a grid of numbers of any dimension -- the format
   everything (images, text, audio) gets converted into so the same
   hardware and math can operate on all of it.
#. Training is one loop, repeated: forward pass, measure loss,
   backward pass (compute gradients), update parameters. Every model
   from a one-line linear fit to a full deep network runs this exact
   loop.
#. Autograd computes real derivatives, and that correctness is
   checkable -- comparing the analytical gradient against a
   finite-difference numerical one (``gradcheck``) is the actual
   technique used to verify it, not a leap of faith.
#. Stacking layers with non-linear functions between them is what
   turns this page's straight-line fit into a network that can learn
   curved, complex relationships -- the training loop itself doesn't
   change.

See Also
--------------

:doc:`cpu_vs_gpu_interactive` for why this training loop is normally
run on a GPU rather than a CPU once the tensors involved get large.
:doc:`cuda_gpu_architecture` for why matrix multiplication --
literally what ``predict(x) = w*x + b`` becomes once ``x`` is a whole
batch of inputs at once -- is the specific operation GPUs are built
around.
