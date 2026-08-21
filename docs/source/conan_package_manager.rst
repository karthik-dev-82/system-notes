Conan Package Manager Guide
=============================

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

     div.document div.admonition {
       background: #f7f6f2;
       border: 1px solid #cdd6cc;
       border-left: 4px solid #a67c1f;
       border-radius: 4px;
       padding: 14px 18px;
       margin: 4px 0 22px;
     }
     div.document div.admonition p.admonition-title {
       font-weight: 700;
       color: #a67c1f;
       margin: 0 0 8px;
       font-size: 0.72rem;
       letter-spacing: 0.06em;
       text-transform: uppercase;
     }
     div.document div.admonition p:last-child { margin-bottom: 0; }
     div.document div.admonition.warning,
     div.document div.admonition.attention,
     div.document div.admonition.caution { border-left-color: #b0432a; }
     div.document div.admonition.warning p.admonition-title,
     div.document div.admonition.attention p.admonition-title,
     div.document div.admonition.caution p.admonition-title { color: #b0432a; }
     div.document div.admonition.tip,
     div.document div.admonition.hint,
     div.document div.admonition.important { border-left-color: #3d5c3d; }
     div.document div.admonition.tip p.admonition-title,
     div.document div.admonition.hint p.admonition-title,
     div.document div.admonition.important p.admonition-title { color: #3d5c3d; }
   </style>

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
   CMakeToolchain # Writes a toolchain file CMake reads automatically
   CMakeDeps      # Writes find_package() config files for each dependency

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

   This guide targets **Conan 2.x**, the current major version. If
   you run into a tutorial or an older codebase using ``from conans
   import ConanFile`` (plural) or generators named ``cmake``,
   ``cmake_find_package``, or ``cmake_find_package_multi``, that's
   Conan 1.x -- those generator names were removed in 2.x in favor of
   ``CMakeToolchain``/``CMakeDeps``, shown throughout this page. Check
   ``conan --version`` if you're not sure which one a project expects.

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
``CMakeToolchain``/``CMakeDeps`` for CMake projects,
``MSBuildToolchain``/``MSBuildDeps`` for Visual Studio,
``AutotoolsToolchain``/``AutotoolsDeps`` for Make-based/Autotools
projects.

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

   # Search for available packages on a remote
   conan search boost -r=conancenter

   # Show the dependency graph for a package
   conan graph info .

   # Create your own package (name/version come from the recipe)
   conan create .

   # Upload a package to a remote (requires an explicit remote and confirmation)
   conan upload mypackage/1.0 -r=myremote --confirm

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
   CMakeToolchain
   CMakeDeps

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
   CMakeToolchain
   CMakeDeps

For a Network Application
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: ini

   [requires]
   boost/1.82.0
   openssl/3.1.2
   libcurl/8.2.1
   protobuf/3.21.12

   [generators]
   CMakeToolchain
   CMakeDeps

Remember
-------------

* **Conan** = your package delivery robot
* **conanfile** = your shopping list
* **Conan Center** = the warehouse
* **generators** = the translator

With Conan, setting up a complex C++ project goes from hours to
minutes.
