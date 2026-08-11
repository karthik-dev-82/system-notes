Decorator Pattern: Play With It
======================================

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
