Understanding spdlog Sinks & Architecture
=============================================

The Sprinkler System Analogy
---------------------------------

Think of spdlog like a sprinkler system in your yard:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 80

   * - Component
     - What It Does
   * - The Logger
     - Main water source/controller
   * - Sinks
     - Sprinkler heads that output water (log messages) to different
       locations

The Architecture: Three Layers
-----------------------------------

.. uml::

   !theme plain
   skinparam backgroundColor white
   rectangle "Your Code" as code
   rectangle "Logger\n(e.g. \"MyApp\")" as logger #LightBlue
   rectangle "Console Sink\n(own pattern + level)" as console #LightGreen
   rectangle "File Sink\n(own pattern + level)" as file #LightSalmon
   code -down-> logger : logger->info(...)
   logger -down-> console : formatted message
   logger -down-> file : formatted message
   note right of logger
     A logger has NO single shared
     formatter. Each sink formats
     (and filters by level)
     independently -- see the
     Quick Start Template below.
   end note

**Analogy:** think of it like a restaurant.

* Your code = customer placing an order
* Logger = waiter taking the order
* Sinks = different tables where food is served, each with its own way
  of plating (formatting) what arrives

Types of Sinks
------------------

Console Sink
~~~~~~~~~~~~~~~

= sprinkler watering your front lawn (``stdout``)

* ✅ You can see it immediately as it happens
* ✅ Great for real-time monitoring while developing
* ❌ Disappears once done (not permanent)

Example output:

.. code-block:: text

   [2025-10-06 14:32:15] [info] Server started on port 8080
   [2025-10-06 14:32:16] [info] Connected to database

File Sink
~~~~~~~~~~~~

= sprinkler with a rain barrel collecting water

* ✅ Saves everything for later review
* ✅ Permanent record you can analyze days/weeks later
* ✅ Useful for debugging issues that happened when you weren't watching

Creates files like:

.. code-block:: text

   logs/app_2025-10-06.txt
   logs/app_2025-10-07.txt

The Power: Multiple Sinks Simultaneously
---------------------------------------------

The beauty of spdlog is one logger can have multiple sinks attached:

.. code-block:: text

   logger->info("Sensor data received")
            |
       +----+----+
       |         |
   Console      File
   (see now)  (save forever)

**Key benefit:** when your code logs once, the message automatically
goes to every attached sink. You get:

* Real-time feedback
* A permanent audit trail
* No extra code needed

Basic Code Examples
------------------------

Example 1: Simple Console Logger
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The easiest way to start -- just print to screen!

.. code-block:: cpp

   #include "spdlog/spdlog.h"

   int main() {
       // Create a simple console logger
       auto console = spdlog::stdout_color_mt("console");

       // Log some messages
       console->info("Program started!");
       console->warn("This is a warning");
       console->error("Something went wrong!");

       return 0;
   }

Output:

.. code-block:: text

   [2025-10-06 14:32:15.123] [console] [info] Program started!
   [2025-10-06 14:32:15.124] [console] [warn] This is a warning
   [2025-10-06 14:32:15.125] [console] [error] Something went wrong!

Example 2: Simple File Logger
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Save everything to a file!

.. code-block:: cpp

   #include "spdlog/spdlog.h"
   #include "spdlog/sinks/basic_file_sink.h"

   int main() {
       // Create a file logger
       auto file_logger = spdlog::basic_logger_mt("file_log", "logs/myapp.txt");

       // Log some messages (goes to file)
       file_logger->info("Server starting...");
       file_logger->info("Loading configuration");
       file_logger->error("Failed to connect to database");

       return 0;
   }

Creates file ``logs/myapp.txt``:

.. code-block:: text

   [2025-10-06 14:32:15.123] [file_log] [info] Server starting...
   [2025-10-06 14:32:15.124] [file_log] [info] Loading configuration
   [2025-10-06 14:32:15.125] [file_log] [error] Failed to connect to database

Example 3: The Power Combo - Both Console AND File!
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This is what you should use in real projects!

.. code-block:: cpp

   #include "spdlog/spdlog.h"
   #include "spdlog/sinks/stdout_color_sinks.h"
   #include "spdlog/sinks/basic_file_sink.h"

   int main() {
       // Step 1: Create two sinks
       auto console_sink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
       auto file_sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>("logs/app.txt");

       // Step 2: Put both sinks in a list
       std::vector<spdlog::sink_ptr> sinks {console_sink, file_sink};

       // Step 3: Create logger with BOTH sinks
       auto logger = std::make_shared<spdlog::logger>("multi_sink", sinks.begin(), sinks.end());

       // Step 4: Register it so you can use it anywhere
       spdlog::register_logger(logger);

       // Step 5: Log once, goes to BOTH places!
       logger->info("This appears in console AND file!");
       logger->warn("Temperature too high: {} degrees", 105);
       logger->error("Sensor disconnected");

       return 0;
   }

Example 4: Using the Global Logger (Easiest for Beginners!)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once you register a logger as the default, you can use it from anywhere
without passing it around!

.. code-block:: cpp

   #include "spdlog/spdlog.h"
   #include "spdlog/sinks/stdout_color_sinks.h"
   #include "spdlog/sinks/basic_file_sink.h"

   // Setup function (call once at program start)
   void setup_logging() {
       auto console_sink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
       auto file_sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>("logs/app.txt");

       std::vector<spdlog::sink_ptr> sinks {console_sink, file_sink};
       auto logger = std::make_shared<spdlog::logger>("app", sinks.begin(), sinks.end());

       spdlog::set_default_logger(logger);  // Makes this the default!
   }

   // Now you can log from any function!
   void process_data() {
       spdlog::info("Processing started");  // No logger object needed!
       spdlog::warn("Low memory warning");
   }

   void connect_sensor() {
       spdlog::info("Connecting to sensor...");
       spdlog::error("Connection failed!");
   }

   int main() {
       setup_logging();  // Setup once

       // Now just use spdlog::info() anywhere!
       spdlog::info("Program started");
       process_data();
       connect_sensor();
       spdlog::info("Program ending");

       return 0;
   }

Log Levels: The Volume Knob
--------------------------------

spdlog has different "urgency" levels:

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 15 40 45

   * - Level
     - When to Use
     - Example
   * - ``trace``
     - Super detailed debug info
     - "Entering function calculate()"
   * - ``debug``
     - Developer debugging info
     - "Variable x = 42"
   * - ``info``
     - Normal operational messages
     - "Server started on port 8080"
   * - ``warn``
     - Something unusual but not broken
     - "Disk space low: 10% remaining"
   * - ``error``
     - Something failed but program continues
     - "Failed to save file"
   * - ``critical``
     - Very serious, might crash soon
     - "Out of memory!"

.. code-block:: cpp

   logger->trace("This is super detailed");
   logger->debug("Variable value: {}", x);
   logger->info("Normal operation");
   logger->warn("Something unusual");
   logger->error("Something failed!");
   logger->critical("CRITICAL FAILURE!");

**Pro tip:** you can set a minimum level to filter messages. Note that
the logger *methods* are named ``trace()``, ``debug()``, ``info()``,
``warn()``, ``error()``, and ``critical()``, but the
``spdlog::level::level_enum`` constant for the error level is spelled
``err``, not ``error``:

.. code-block:: cpp

   logger->set_level(spdlog::level::info);  // Only show info and above
   // Now trace() and debug() messages won't appear!

   logger->set_level(spdlog::level::err);   // Only show error and above
   // spdlog::level::error doesn't exist -- it won't compile

Advanced: Rotating File Sink
---------------------------------

What if your log file gets HUGE? Use a rotating sink!

.. code-block:: cpp

   #include "spdlog/sinks/rotating_file_sink.h"

   int main() {
       // Create rotating file: max 5MB per file, keep 3 old backups
       auto rotating = spdlog::rotating_logger_mt(
           "rotating_log",
           "logs/app.txt",
           1024 * 1024 * 5,  // 5 MB max size
           3                  // Keep 3 old files
       );

       rotating->info("This logs to rotating files");

       return 0;
   }

What happens once ``app.txt`` hits 5MB: it's renamed to ``app.1.txt``
(bumping any existing numbered files up by one), and a fresh ``app.txt``
starts. Once a 4th backup would be created, the oldest one is deleted:

.. code-block:: text

   logs/app.txt           <- Current file
   logs/app.1.txt         <- Previous file
   logs/app.2.txt         <- Older file
   logs/app.3.txt         <- Oldest file (deleted on the next rotation)

Real-World Usage
---------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 30 70

   * - Situation
     - What to Do
   * - During Development
     - Watch the console for immediate feedback
   * - When Bugs Happen in Production
     - Check the log files to see what went wrong
   * - Best Practice
     - Always use both sinks so you have options

Quick Start Template
-------------------------

Copy this to start any new project:

.. code-block:: cpp

   #include "spdlog/spdlog.h"
   #include "spdlog/sinks/stdout_color_sinks.h"
   #include "spdlog/sinks/rotating_file_sink.h"

   void init_logger() {
       // Console sink (with colors!)
       auto console_sink = std::make_shared<spdlog::sinks::stdout_color_sink_mt>();
       console_sink->set_level(spdlog::level::debug);
       console_sink->set_pattern("[%T] [%^%l%$] %v"); // time + colored level + message

       // Rotating file sink (5MB max, keep 3 files)
       auto file_sink = std::make_shared<spdlog::sinks::rotating_file_sink_mt>(
           "logs/app.txt", 1024 * 1024 * 5, 3);
       file_sink->set_level(spdlog::level::trace);  // Save everything to file
       file_sink->set_pattern("[%Y-%m-%d %H:%M:%S.%e] [%n] [%l] %v"); // full timestamp + logger name

       // Combine them
       std::vector<spdlog::sink_ptr> sinks {console_sink, file_sink};
       auto logger = std::make_shared<spdlog::logger>("app", sinks.begin(), sinks.end());
       logger->set_level(spdlog::level::trace);

       spdlog::set_default_logger(logger);
       spdlog::info("Logger initialized");
   }

   int main() {
       init_logger();

       // Your code here - just use spdlog::info(), etc.
       spdlog::info("Hello spdlog!");

       return 0;
   }

Key Takeaways
-----------------

* **Logger** = your main logging interface (the waiter)
* **Sinks** = where messages go (console, file, network, etc.), each
  with its own format and level
* One log call → multiple destinations = the magic of spdlog
* Console sink = see it now (but temporary)
* File sink = save forever (for later investigation)
* Best practice = use both! Real-time feedback *and* permanent records
* Rotating files = prevents logs from eating all your disk space
* Log levels = control how much detail you see (``trace`` < ``debug``
  < ``info`` < ``warn`` < ``err`` < ``critical``)

Remember
------------

Just like a sprinkler system:

1. You turn on one valve (call ``logger->info()``)
2. Water flows to multiple sprinkler heads (console + file + more)
3. Each sprinkler can water differently -- its own pattern, its own
   minimum level
4. You control the water pressure (log level) for each sprinkler
   independently
