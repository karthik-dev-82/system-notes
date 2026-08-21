Move Semantics: Play With It
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

See :doc:`cpp_ranges_interactive` for the other half of "avoid the
copy" in modern C++ -- a ``std::views`` pipeline that never
materializes its data at all, rather than moving data you already own.
