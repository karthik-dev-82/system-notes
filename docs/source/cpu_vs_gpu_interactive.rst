CPU vs. GPU: Play With It
===============================

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

A CPU is a handful of powerful, general-purpose cores -- each one can
run any instruction, branch, and change plans instantly, but there
are only a few of them (4-16 in most consumer chips). A GPU is
thousands of much simpler cores that all run the *same* instruction
on *different* data at once -- none of them can improvise, but there
are thousands. That trade-off -- few flexible workers vs. many
identical ones -- is the entire architectural story; see
:doc:`processor_architecture` for how a CPU chip is actually built
around that flexibility, and :doc:`cuda_gpu_architecture` for why
neural-network math specifically suits the GPU's shape, and why
NVIDIA's CUDA software is the reason renting an NVIDIA GPU is the
default choice.

This page is about a narrower, often-missed question: given that
trade-off, **when does the GPU actually win**? A GPU doesn't do
anything for free -- moving data onto it and starting work there
costs a fixed amount of time before a single useful operation
happens, regardless of how big the job is. For a small enough job,
that fixed cost is *more expensive than just doing the whole thing on
the CPU*.

Play With It
------------------

.. raw:: html
   :file: _static/cpu_vs_gpu_widget.html

Drag matrix size **N** and watch the two lines cross. Multiplying two
N x N matrices takes roughly N\ :sup:`3` operations -- not N -- which
is why the crossover happens at a surprisingly small N: work grows
*much* faster than the size number suggests. The other two sliders
let you explore *why* the crossover point isn't a fixed universal
number: more GPU transfer/launch overhead pushes it right (the GPU
needs a bigger job to be worth it); more parallelism pushes it left
(each unit of work finishes faster once it's running, so the fixed
cost gets paid back sooner).

Why This Isn't a Toy Simplification
------------------------------------------

This is a real, well-documented phenomenon, not a simplified teaching
model: moving data across the PCIe bus to GPU memory and synchronizing
a kernel launch both take real, measurable time that has nothing to
do with the actual computation. Benchmark a tiny matrix multiply on a
real GPU and it will frequently lose to the CPU for exactly this
reason -- the job finishes before the overhead has even been paid
back. The lesson generalizes past matrix multiplication specifically:
**any** time work gets handed to a separate pool of parallel workers
-- a thread pool, a distributed job queue, a GPU -- there's a real
minimum job size below which the dispatch cost isn't worth paying.

Where Machine Learning Actually Lands
--------------------------------------------

Training a neural network multiplies matrices with millions of
entries, over and over, for thousands of training examples across
many epochs -- nowhere close to the small-N region where a CPU would
win. That's the entire reason GPU (and TPU) training exists: the
workload is so far past the crossover point that the fixed transfer
cost becomes negligible next to the sheer amount of parallel work
being done.

**Does this require understanding PyTorch or TensorFlow specifically?
No.** Everything on this page is about the hardware trade-off itself,
which is completely independent of any particular framework. PyTorch,
TensorFlow, JAX, and every other ML framework exist to do the same
one job: let you write ordinary-looking code (like ``tensor1 @
tensor2``) and have the framework decide, underneath, whether that
runs on the CPU or gets shipped to a GPU -- so you don't have to
hand-write the data-transfer and kernel-launch machinery yourself.
Which specific framework does that dispatching is a separate,
software-design question (eager execution vs. static computation
graphs, how each one builds and optimizes that graph) -- a real,
distinct topic, but not a prerequisite for anything on this page.

Remember
------------

#. A CPU has few, flexible cores; a GPU has thousands of simple,
   identical ones -- that's the whole shape difference underneath
   every CPU-vs-GPU comparison.
#. A GPU pays a fixed transfer/launch cost before any work happens.
   For small enough jobs, that fixed cost is more expensive than just
   running the whole thing on the CPU -- the GPU can genuinely be the
   slower choice.
#. Matrix multiply work scales as N\ :sup:`3`, which is why the
   crossover point arrives at a surprisingly small N -- and why ML
   training workloads, which are enormous by comparison, sit so far
   past it that the fixed cost stops mattering at all.
#. This crossover is a hardware/scheduling fact, independent of
   PyTorch, TensorFlow, or any other framework -- those exist to
   automate the dispatch decision, not to change when it's worth
   making.

See Also
--------------

:doc:`processor_architecture` for how a CPU chip is actually built
around flexibility rather than raw core count. :doc:`cuda_gpu_architecture`
for why matrix multiplication specifically suits a GPU's shape, and
the separate (CUDA-specific) software story on top of this page's
hardware one. :doc:`pytorch_basics_interactive` for what actually runs
past this page's crossover point -- a real training loop, built on
the exact same matrix-multiply operation this page's N is the size of.
