Move Semantics: Play With It
===================================

:doc:`cpp_raii_smart_pointers_interactive` showed ``unique_ptr``
transferring ownership via ``std::move`` -- stealing a single pointer
and nulling out the source. Move semantics is the same idea
generalized to any type that owns a resource, and the reason it
exists at all is performance: constructing one object *from* another
doesn't have to mean copying its contents, if the source object is
about to be discarded anyway.

The Problem Move Semantics Solves
------------------------------------------

Picture a ``Buffer`` class that owns a heap-allocated array. Before
C++11, constructing a new ``Buffer`` from an existing one had exactly
one option: the copy constructor, which allocates a fresh array and
copies every element into it -- correct, but O(n) in the buffer's
size, every single time, even in situations like returning a local
``Buffer`` by value where the source is about to be destroyed anyway
and copying its contents is pure waste.

.. raw:: html
   :file: _static/cpp_move_semantics_widget.html

Toggle between the two constructors and run the same 5-element buffer
through both. Copy mode allocates a new array and copies each element
one at a time -- watch the counters climb. Move mode does neither: it
hands the destination the exact same array the source already had,
and leaves the source empty. Same observable result (a fully-formed
``dest`` object), radically different cost.

.. code-block:: cpp

   class Buffer {
       int* data;
       size_t size;
   public:
       // Copy: O(n) -- new allocation, every element copied
       Buffer(const Buffer& other) : size(other.size) {
           data = new int[size];
           for (size_t i = 0; i < size; i++) data[i] = other.data[i];
       }

       // Move: O(1) -- steal the pointer, empty the source
       Buffer(Buffer&& other) noexcept
           : data(other.data), size(other.size) {
           other.data = nullptr;
           other.size = 0;
       }
   };

``std::move`` Doesn't Move Anything
------------------------------------------

The single most common misconception is that calling ``std::move(x)``
does something to ``x``. It doesn't -- it's a cast, full stop:
``static_cast<Buffer&&>(x)``. That cast just changes which overload
the compiler picks (the move constructor instead of the copy
constructor) when the result gets used to construct or assign
something. The widget's log makes this explicit: "``std::move(source)``
-- just a cast" is always logged as its own line, separate from the
line where the move constructor actually runs and the theft happens.
Call ``std::move`` on something and then never use the result, and
nothing happens at all -- the source is completely unaffected.

What "Moved-From" Actually Means
------------------------------------------

After a move, ``source`` in the widget still exists as a real,
destructible object -- it isn't gone, it's just empty. This
``Buffer``'s move constructor makes a specific, deliberate promise
(``nullptr``, size zero); the C++ standard's blanket guarantee for
standard-library types is weaker and worth knowing precisely: a
moved-from object is left in a *valid but unspecified* state -- safe
to destroy or reassign, but its contents shouldn't be assumed. Writing
your own move constructor to leave a specific, documented empty state
(as this one does) is good practice precisely because it's stronger
than the minimum the language requires.
