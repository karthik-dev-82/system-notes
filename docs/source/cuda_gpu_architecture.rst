The CUDA Moat
==================

Why one company's chips became the bottleneck for the entire AI
buildout -- untangled into the two separate stories people usually
blend together. First, the hardware reason: neural networks are
almost entirely one repeated operation (matrix multiplication), and a
GPU's thousands of simple cores are exactly the right shape for that,
regardless of vendor. Second, the software reason, which *is*
vendor-specific: CUDA is NVIDIA's own fifteen-year toolchain, and it's
the reason renting an NVIDIA GPU is the safe default even when
competing silicon is comparable. Closes with how thousands of these
chips get wired together (NVLink, NVSwitch) to act like one machine.

.. raw:: html
   :file: _static/cuda_moat_widget.html

See Also
--------------

See :doc:`processor_architecture` for the CPU side of the same "where
does memory/I-O actually connect" question this page asks about GPUs.
See :doc:`cpu_vs_gpu_interactive` for the more basic question this
page assumes an answer to: given the core-count trade-off, when does
handing work to the GPU actually pay off?
