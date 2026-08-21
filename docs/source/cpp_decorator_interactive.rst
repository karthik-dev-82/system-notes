Decorator Pattern: Play With It
======================================

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

Wrapping one object around another to add behavior, without touching
either one's class, is the entire pattern. The part that's easy to
miss is that wrapping is composition, not addition -- *which* wrapper
sits on the outside changes what the whole chain actually does, not
just the order operations happen to run in.

.. raw:: html
   :file: _static/cpp_decorator_widget.html

Nesting, Not Just Sequencing
------------------------------------

Every decorator here implements the same one-method interface as the
thing it wraps, and only ever calls *that* interface on whatever it's
holding -- it has no idea whether the object inside it is the raw data
source or another decorator three layers deep:

.. code-block:: cpp

   struct DataSource {
       virtual Bytes process(Bytes data) const = 0;
       virtual ~DataSource() {}
   };

   struct RawSource : DataSource {
       Bytes process(Bytes data) const override { return data; }
   };

   struct CompressingDecorator : DataSource {
       std::unique_ptr<DataSource> inner;
       CompressingDecorator(std::unique_ptr<DataSource> in) : inner(std::move(in)) {}
       Bytes process(Bytes data) const override {
           return compress(inner->process(std::move(data)));
       }
   };

   struct EncryptingDecorator : DataSource {
       std::unique_ptr<DataSource> inner;
       EncryptingDecorator(std::unique_ptr<DataSource> in) : inner(std::move(in)) {}
       Bytes process(Bytes data) const override {
           return encrypt(inner->process(std::move(data)));
       }
   };

   // Compress first, encrypt last:
   auto a = std::make_unique<EncryptingDecorator>(
       std::make_unique<CompressingDecorator>(std::make_unique<RawSource>()));

   // Encrypt first, compress last:
   auto b = std::make_unique<CompressingDecorator>(
       std::make_unique<EncryptingDecorator>(std::make_unique<RawSource>()));

Both of these compile, run, and produce a chain of the exact same
interface calling into the exact same interface -- the *only*
difference between ``a`` and ``b`` is which constructor argument went
where. That structural part is real and compiled here. What *isn't*
real in this snippet is ``compress()``/``encrypt()`` themselves --
they're a toy run-length-encoder and a single-byte XOR, standing in
for the pattern's shape, not its payload. Try them on 50 repeated
bytes and both orderings shrink to the same 2 bytes, which is the
opposite of what the widget above shows with genuine compression and
encryption. That's not a contradiction -- it's the point. A toy XOR
cipher is linear: XOR-ing a run of identical bytes with a constant key
just produces a different run of identical bytes, so the data is
exactly as compressible afterward as before. Real encryption doesn't
have that property on purpose -- its whole job is to make the output
indistinguishable from random noise, which is precisely what destroys
a compressor's ability to find anything to exploit. The interactive
demo above uses real ``CompressionStream`` gzip and real AES-GCM
specifically so that difference shows up for real, not just in theory.

See :doc:`cpp_command_interactive`, :doc:`cpp_singleton_interactive`,
:doc:`cpp_observer_interactive`, and :doc:`cpp_strategy_interactive`
for the other modern-C++ pattern widgets in this series.
