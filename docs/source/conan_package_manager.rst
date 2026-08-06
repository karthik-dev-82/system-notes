Conan Package Manager Guide
=============================

What is Conan?
--------------------

Conan = Amazon Prime for C++ libraries. Just like Amazon delivers
packages to your door, Conan delivers code libraries to your project.
No more hunting down dependencies manually.

The Problem It Solves
----------------------------

Building C++ projects without Conan is like building a LEGO spaceship
when the special pieces are scattered in different friends' houses.
You'd have to:

* Visit each friend's house
* Figure out which version fits
* Carry them all back
* Keep track of everything

Conan is your delivery service that knows exactly what you need and
brings it to you.

How Conan Works
------------------------

.. code-block:: text

   Your Project -> Shopping List (conanfile) -> Conan -> Package Warehouse -> Your Computer

1. Write what you need in ``conanfile.txt``
2. Give the list to Conan
3. Conan finds packages in the warehouse
4. Downloads the right versions
5. Installs them locally
6. Ready to use in your project

Conanfile Structure Explained
------------------------------------

Option 1: Simple conanfile.txt
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: ini

   # === WHAT YOU NEED (Dependencies) ===
   [requires]
   boost/1.82.0        # Need Boost library, version 1.82.0
   openssl/3.0.5       # Need OpenSSL for encryption
   zlib/1.2.13         # Need zlib for compression

   # === HOW TO PACKAGE IT ===
   [generators]
   cmake              # Create files that CMake understands
   cmake_find_package # Create find_package() files

   # === SPECIAL SETTINGS ===
   [options]
   boost:shared=True    # Want Boost as shared library (.dll/.so)
   openssl:shared=False # Want OpenSSL as static library (.lib/.a)

   # === WHERE TO FIND PACKAGES ===
   [imports]
   bin, *.dll -> ./bin  # Copy all DLLs to my bin folder
   lib, *.so -> ./lib   # Copy all .so files to my lib folder

Option 2: Python conanfile.py (more power!)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: python

   from conan import ConanFile

   class MyProjectConan(ConanFile):
       # === BASIC INFO ===
       name = "MyGame"                     # Your project name
       version = "1.0"                     # Your version
       settings = "os", "compiler", "arch" # What affects the build

       # === WHAT YOU NEED ===
       requires = [
           "sdl/2.0.20",        # Graphics library
           "openal/1.22.2",     # Sound library
           "bullet3/3.24",      # Physics library
       ]

       # === BUILD SETTINGS ===
       default_options = {
           "sdl:shared": True,      # SDL as shared library
           "bullet3:shared": False, # Bullet as static library
       }

       # === HOW TO BUILD ===
       generators = "CMakeToolchain", "CMakeDeps"  # Modern CMake integration

.. note::

   This mixes two different Conan major versions. The ``.py``
   example's ``from conan import ConanFile`` import and its
   ``CMakeToolchain``/``CMakeDeps`` generators are **Conan 2.x**
   syntax. The ``.txt`` example's ``cmake``, ``cmake_find_package``,
   and ``cmake_find_package_multi`` generators are **Conan 1.x**
   terminology -- they were removed in Conan 2.x in favor of the same
   ``CMakeToolchain``/``CMakeDeps`` generators shown in the ``.py``
   example. Conan 1.x also imports ``ConanFile`` from ``conans``
   (plural), not ``conan``. Check ``conan --version`` before copying
   either style, and don't mix them within one project.

Key Sections Breakdown
------------------------------

``[requires]`` -- Your Shopping List
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Lists all the libraries you need with exact versions:
``library_name/version``. Think of it as "I need this exact LEGO set
number."

``[generators]`` -- The Translator
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Tells Conan how to explain the libraries to your build system --
``cmake`` for CMake projects, ``visual_studio`` for Visual Studio,
``makefile`` for Make-based projects.

``[options]`` -- Customization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fine-tune how libraries are built: ``shared=True/False`` for dynamic
(``.dll``/``.so``) vs. static (``.lib``/``.a``), ``with_ssl=True/False``
to include SSL support or not.

``[imports]`` -- File Organization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Tells Conan where to put files after download: ``pattern, files ->
destination``.

Essential Conan Commands
------------------------------

.. code-block:: bash

   # Install all dependencies from conanfile
   conan install .

   # Install with specific build type
   conan install . --build=missing

   # Search for available packages
   conan search boost --remote=conancenter

   # Show information about a package
   conan info .

   # Create your own package
   conan create . myuser/stable

   # Upload package to server
   conan upload MyPackage/1.0@myuser/stable --all

Real-World Example: Game Project
------------------------------------------

.. code-block:: ini

   [requires]
   # Graphics & Window
   sdl/2.26.5
   glew/2.2.0
   # Audio
   openal/1.22.2
   # Physics
   box2d/2.4.1
   # Networking
   libcurl/8.2.1
   # Compression
   zlib/1.3

   [generators]
   cmake
   cmake_find_package_multi

   [options]
   sdl:shared=True
   libcurl:with_ssl=True
   libcurl:with_zlib=True

Why Each Part Matters
------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 35 45

   * - Section
     - Purpose
     - Without it
   * - ``requires``
     - Lists dependencies
     - You'd manually download each library
   * - ``generators``
     - Build system integration
     - You'd manually configure build paths
   * - ``options``
     - Customizes libraries
     - You'd get default settings (might not work)
   * - ``imports``
     - Organizes files
     - Files scattered everywhere

Tips for Success
----------------------

* **Start simple** -- use ``conanfile.txt`` first, upgrade to ``.py``
  when needed
* **Lock versions** -- always specify exact versions (``1.82.0``, not
  just ``1.82``)
* **Use** ``--build=missing`` -- builds packages if pre-built ones
  don't exist
* **Check Conan Center** -- most popular libraries are already there
* **Test locally** -- run ``conan install .`` before pushing code

Common Patterns
----------------------

For a Modern C++ Project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: ini

   [requires]
   fmt/10.1.0            # Better string formatting
   spdlog/1.12.0         # Fast logging
   catch2/3.4.0          # Testing framework
   nlohmann_json/3.11.2  # JSON handling

   [generators]
   CMakeToolchain
   CMakeDeps

For a Game Project
~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: ini

   [requires]
   sfml/2.6.0        # Simple multimedia library
   imgui/1.89.8      # Immediate mode GUI
   bullet3/3.24      # Physics
   lua/5.4.6         # Scripting

   [generators]
   cmake

For a Network Application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: ini

   [requires]
   boost/1.82.0
   openssl/3.1.2
   libcurl/8.2.1
   protobuf/3.21.12

   [generators]
   cmake
   cmake_find_package

Remember
-------------

* **Conan** = your package delivery robot
* **conanfile** = your shopping list
* **Conan Center** = the warehouse
* **generators** = the translator

With Conan, setting up a complex C++ project goes from hours to
minutes.
