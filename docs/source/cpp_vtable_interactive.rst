Virtual Functions & vtables: Play With It
================================================

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

Every object of a polymorphic class carries one hidden extra field: a
pointer to its own class's table of virtual function addresses (the
*vtable*). That single fact -- the vptr always points at the *actual*
class's vtable, never at whatever type you're currently referring to
the object through -- explains two things at once: why calling a
virtual function through a base pointer still runs the derived
override, and why forgetting one keyword on a base class destructor
is a real, well-documented bug.

Virtual Dispatch: How "The Right Override" Actually Gets Found
------------------------------------------------------------------------

.. raw:: html
   :file: _static/cpp_vtable_widget.html

The first tab creates a ``Dog`` or a ``Cat``, stores it through a
``Base*``, and calls ``speak()``. In virtual mode, the call follows the
object's own vptr to its own vtable and reaches the override that
actually matches the object -- ``Dog::speak`` for a ``Dog``, no matter
that the pointer says ``Base*``. Flip to non-virtual mode and the exact
same code compiles and runs, but resolves ``speak()`` at compile time
based solely on the pointer's declared type -- so it calls
``Base::speak`` every time, regardless of what the pointer actually
points at. Nothing crashes; it just silently calls the wrong function,
which is often worse.

.. code-block:: cpp

   struct Base { virtual void speak() { std::cout << "Base::speak\n"; } };
   struct Dog : Base { void speak() override { std::cout << "Dog::speak\n"; } };

   Base* p = new Dog();
   p->speak();   // "Dog::speak" -- dispatches through p's vptr

The Non-Virtual Destructor Bug
------------------------------------

The second tab applies the exact same mechanism to destruction, where
getting it wrong is worse than calling the wrong greeting -- it's a
real, cited case of undefined behavior. ``delete`` on a ``Base*`` only
dispatches through the vtable if ``~Base()`` is declared ``virtual``.
If it isn't, ``delete p`` resolves to ``Base::~Base()`` at compile
time, exactly like the non-virtual ``speak()`` call above -- and
``Derived::~Derived()`` simply never runs. Anything the derived part
of the object owned (the demo's heap-allocated ``resource``, but just
as easily a file handle, a mutex, a socket) is never released.

.. code-block:: cpp

   struct Base {
       virtual ~Base() {}   // the fix is exactly this word, even on an empty body
   };
   struct Derived : Base {
       int* resource = new int(99);
       ~Derived() { delete resource; }
   };

   Base* p = new Derived();
   delete p;   // virtual ~Base() -> full chain runs: Derived::~Derived(), then Base::~Base()

This is precisely the same shape of bug as the heap-leak tab on
:doc:`cpp_memory_interactive` and the multi-exit-path leak from
:doc:`cpp_raii_smart_pointers_interactive` -- a piece of cleanup that
should run but doesn't, because nothing forced it to. The fix here is
narrower and cheaper than either of those: any base class meant to be
deleted through a base pointer needs a virtual destructor, full stop,
even if its body is empty. It's also why ``std::unique_ptr<Base>``
doesn't make this problem go away on its own -- it still just calls
``delete`` on the raw pointer it holds, so the base class still needs
a virtual destructor for that ``delete`` to do the right thing.
