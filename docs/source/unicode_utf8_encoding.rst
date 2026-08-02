Unicode and UTF-8 Encoding
================================

Think of text encoding like a secret codebook where every letter,
symbol, or emoji gets a unique number.

* **ASCII** -- a small codebook with only 128 slots (0-127). Can only
  fit English letters (A-Z, a-z), numbers, and basic symbols
  (``!@#$%``). Like a tiny classroom with only 128 seats.
* **Unicode** -- a huge codebook with over 1 million slots
  (0-1,114,111). Can fit all the world's languages, emojis, ancient
  scripts, math symbols, everything. Like a massive stadium with
  1 million+ seats.

How Unicode Works
-----------------------

Code Points (The Number Tags)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Every character gets a unique number called a **code point**, written
as ``U+xxxx``.

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 30 50

   * - Code Point
     - Character
     - Meaning
   * - ``U+0041``
     - A
     - Latin letter A
   * - ``U+4E2D``
     - 中
     - Chinese for "middle"
   * - ``U+0D2E``
     - മ
     - Malayalam letter MA
   * - ``U+1F600``
     - 😀
     - Grinning-face emoji

Think of each character having its own house address in Unicode City.

Code Spaces (The Neighborhoods)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Unicode divides its million+ slots into 17 planes (neighborhoods):

* **Plane 0 -- Basic Multilingual Plane (BMP)**, ``U+0000`` to
  ``U+FFFF``: the "main street" where most common characters live.
  Includes English, Chinese, Arabic, Hindi, Malayalam, Korean,
  Japanese, and more -- roughly 65,000 code points.
* **Plane 1 -- Supplementary Multilingual Plane**, ``U+10000`` to
  ``U+1FFFF``: historic scripts, emojis, rare symbols, musical
  notation, game symbols.
* **Planes 2-16** -- rarely used scripts and special purposes.

Encoding Different Languages
----------------------------------

Chinese
~~~~~~~~~~~~

Each character gets its own code point:

* 中 (middle) -> ``U+4E2D``
* 国 (country) -> ``U+56FD``

Thousands of unique characters, each with their own number.

Malayalam (മലയാളം)
~~~~~~~~~~~~~~~~~~~~~~~~

Each letter has its own code point:

* മ -> ``U+0D2E``
* ല -> ``U+0D32``
* യ -> ``U+0D2F``

Vowel marks and diacritics also have separate codes.

Emojis
~~~~~~~~~~

Each emoji is just another character:

* 😀 -> ``U+1F600``
* 🎉 -> ``U+1F389``

ASCII vs Unicode Comparison
---------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 25 50

   * - Feature
     - ASCII
     - Unicode
   * - Total slots
     - 128
     - 1,114,112
   * - Languages supported
     - English only
     - All languages
   * - Emojis?
     - No
     - Yes
   * - File size
     - Smaller
     - Slightly larger (UTF-8 is smart about it)
   * - Year created
     - 1963
     - 1991

UTF-8: The Smart Storage System
-------------------------------------

Unicode defines the code point. UTF-8 defines how to store those
numbers efficiently.

* English letters -> 1 byte
* Malayalam/Chinese -> 2-3 bytes
* Emojis -> 4 bytes

Think of it like envelope sizes -- small letters need small envelopes,
complex characters need bigger ones.

How UTF-8 Self-Describes Its Byte Length
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

UTF-8 uses bit patterns to show how many bytes a character uses.

**1-byte character (ASCII):**

.. code-block:: text

   0xxxxxxx

Starts with ``0`` -> "I'm alone, 1 byte!"

**2-byte character:**

.. code-block:: text

   110xxxxx 10xxxxxx

Starts with ``110`` -> 2-byte start. Continuation byte starts with
``10``.

**3-byte character (Malayalam, Chinese, etc.):**

.. code-block:: text

   1110xxxx 10xxxxxx 10xxxxxx

Starts with ``1110`` -> 3-byte start. Continuations start with ``10``.

**4-byte character (emojis):**

.. code-block:: text

   11110xxx 10xxxxxx 10xxxxxx 10xxxxxx

Starts with ``11110`` -> 4-byte start. Continuations start with
``10``.

The Reading Algorithm
~~~~~~~~~~~~~~~~~~~~~~~~~~

How UTF-8 decodes:

1. Look at the first few bits.
2. Count the leading ``1``\ s before the first ``0``.
3. That tells you how many total bytes to read.

Train analogy:

* Single car -> 1-byte
* Engine + 1 car -> 2-byte
* Engine + 2 cars -> 3-byte
* Engine + 3 cars -> 4-byte

Continuation cars always start with the ``10`` prefix -- they can
never be mistaken for the start of a new character. That's what lets
a decoder jump into the middle of a UTF-8 stream and resync instantly.

Worked Example: "Hello നമസ്കാരം"
--------------------------------------

Step-by-Step Encoding
~~~~~~~~~~~~~~~~~~~~~~~~~~

English part ("Hello "):

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 25 55

   * - Character
     - Code Point
     - UTF-8 Bytes
   * - H
     - ``U+0048``
     - ``48``
   * - e
     - ``U+0065``
     - ``65``
   * - l
     - ``U+006C``
     - ``6C``
   * - l
     - ``U+006C``
     - ``6C``
   * - o
     - ``U+006F``
     - ``6F``
   * - (space)
     - ``U+0020``
     - ``20``

Malayalam part ("നമസ്കാരം"):

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 25 55

   * - Character
     - Code Point
     - UTF-8 Bytes
   * - ന
     - ``U+0D28``
     - ``E0 B4 A8``
   * - മ
     - ``U+0D2E``
     - ``E0 B4 AE``
   * - സ
     - ``U+0D38``
     - ``E0 B4 B8``
   * - ്  (virama)
     - ``U+0D4D``
     - ``E0 B5 8D``
   * - ക
     - ``U+0D15``
     - ``E0 B4 95``
   * - ാ
     - ``U+0D3E``
     - ``E0 B4 BE``
   * - ര
     - ``U+0D30``
     - ``E0 B4 B0``
   * - ം
     - ``U+0D02``
     - ``E0 B4 82``

Total size:

* English "Hello " = 6 bytes
* Malayalam "നമസ്കാരം" = 24 bytes
* Total = 30 bytes

Byte-by-Byte Example: "Hello ന"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   Byte 1: 01001000  (H)
   Byte 2: 01100101  (e)
   Byte 3: 01101100  (l)
   Byte 4: 01101100  (l)
   Byte 5: 01101111  (o)
   Byte 6: 00100000  (space)
   Byte 7: 11100000  (ന start)
   Byte 8: 10110100  (continuation)
   Byte 9: 10101000  (continuation)

Observation:

* English = 1 byte per letter
* Malayalam = 3 bytes per character

Analogy: like shipping boxes -- small items use small boxes, detailed
ones need larger boxes so all the parts fit safely.

Key Takeaway
-----------------

* **ASCII** -- tiny English-only codebook (128 chars)
* **Unicode** -- universal codebook for all languages and emojis
* **UTF-8** -- smart, variable-length storage that's backward-compatible
  and globally usable
