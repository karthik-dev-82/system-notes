Virtual Functions & vtables: Play With It
================================================

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
