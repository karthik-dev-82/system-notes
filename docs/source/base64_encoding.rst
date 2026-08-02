Base64 Encoding (and Other Text Encodings)
================================================

What is Base64 Encoding?
------------------------------

Think of it like a secret alphabet game!

Imagine you want to send a picture through a system that only
understands letters and numbers (like old telegraph machines that
could only send text). Base64 is like a translator that converts
*any* kind of data into a special alphabet that uses only:

* Letters (A-Z, a-z)
* Numbers (0-9)
* Two special friends: ``+`` and ``/``

That's 26 + 26 + 10 + 2 = 64 symbols -- hence "Base64".

**Analogy:** it's like turning a colorful painting into a LEGO
instruction manual -- you're representing something complex using
only simple, standard pieces that everyone can understand.

How Base64 Works (Simple Version)
---------------------------------------

1. Takes your data (like an image)
2. Breaks it into tiny pieces (bits)
3. Regroups them into 6-bit chunks
4. Assigns each chunk a character from its 64-character alphabet

.. uml::

   !theme plain
   skinparam backgroundcolor white
   skinparam shadowing false

   rectangle "Original Data:\n\"Man\"\n(01001101 01100001 01101110)" as input #LightBlue
   rectangle "Split into\n6-bit chunks" as split #LightYellow
   rectangle "Convert to\nBase64 characters" as convert #LightGreen
   rectangle "Final Text:\nTWFu" as output #LightCoral

   input --> split : Step 1
   split --> convert : Step 2
   convert --> output : Step 3

   note right of split : Like cutting a\nlong ribbon into\nequal pieces

   note right of convert : Each piece gets\na letter/number\nfrom the alphabet

.. note::
   **Correction:** the original version of this diagram showed a
   12-bit input (``010010110101``) next to a 4-character output
   (``S2Vy``), but those don't match -- 12 bits only splits into two
   6-bit chunks (two output characters), and those particular 12 bits
   don't decode to ``S2Vy`` either. Base64 always consumes input in
   3-byte (24-bit) groups and emits 4 output characters per group, so
   the diagram now uses a real, checkable example: the ASCII bytes for
   ``"Man"`` (``01001101 01100001 01101110``, 24 bits) split into four
   6-bit chunks and mapped through the Base64 alphabet, producing
   ``TWFu``.

Other Important Encodings
-------------------------------

ASCII Encoding
~~~~~~~~~~~~~~~~~~

* **What:** converts letters/numbers to computer numbers (0-127)
* **Analogy:** like giving each letter in the alphabet a jersey number
* **Example:** letter ``A`` = 65, ``B`` = 66
* **Used for:** basic English text in computers

.. note::
   **Correction:** the original note gave ASCII's range as 0-255.
   That's the range of a full byte -- ASCII itself only defines 128
   values, 0-127 (7 bits). 128-255 is "extended ASCII" territory,
   where different vendors historically put different, incompatible
   characters -- which is part of why Unicode exists. See
   :doc:`unicode_utf8_encoding` for how that gap gets closed.

UTF-8 Encoding
~~~~~~~~~~~~~~~~~~

* **What:** can handle *any* language (English, Chinese, emojis!)
* **Analogy:** like a universal translator that speaks all languages
* **Example:** can store ``Hello``, ``你好``, ``🎮`` all in one text
* **Used for:** websites, modern text files

UTF-8 gets a full guide of its own -- see :doc:`unicode_utf8_encoding`
for code points, planes, and exactly how the variable-length byte
encoding works.

URL Encoding (Percent Encoding)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

* **What:** makes text safe for web addresses
* **Analogy:** like putting fragile items in bubble wrap for shipping
* **Example:** space becomes ``%20``, so ``hello world`` ->
  ``hello%20world``
* **Used for:** web links, form submissions

Hexadecimal (Hex)
~~~~~~~~~~~~~~~~~~~~~~

* **What:** uses 0-9 and A-F to represent numbers
* **Analogy:** like counting on 16 fingers instead of 10
* **Example:** color red = ``#FF0000``
* **Used for:** colors in web design, memory addresses

Real-World Examples
-------------------------

Base64 in action:

* **Email attachments:** your photo gets converted to text so email
  servers (which historically only handle text) can send it
* **Web images:** sometimes small icons are embedded as Base64 text
  right in the webpage (a "data URI")
* **HTTP Basic Auth:** ``username:password`` gets Base64-encoded
  before being sent in a request header

.. note::
   **Correction:** the original note listed "Passwords: Stored safely
   (though usually with additional security)" as a Base64 use case.
   That's a real and common misconception worth calling out directly:
   Base64 is *encoding*, not encryption or hashing -- it's fully and
   trivially reversible with no key required, so it adds zero
   confidentiality. Passwords should be stored as the output of a
   slow, salted cryptographic hash (bcrypt, scrypt, Argon2), never as
   Base64. The legitimate password-adjacent use of Base64 is HTTP
   Basic Auth, where credentials are Base64-encoded purely so they fit
   in a text header -- that's explicitly *not* secure on its own and
   relies entirely on TLS for actual protection.

Quick Memory Trick
------------------------

* **ASCII** = American Standard (old, simple)
* **UTF-8** = Universal (handles everything)
* **Base64** = Binary-to-text (makes anything into safe text)
* **URL** = Web addresses (makes text web-safe)
* **Hex** = 16 choices (0-F)

Why Do We Need Encoding?
------------------------------

Different computer systems speak different "languages." Encoding is
like having translators that make sure:

1. **Safety:** some characters might break systems (like spaces in
   URLs)
2. **Compatibility:** old systems can handle new data
3. **Universality:** Japanese computers can talk to American computers
4. **Storage:** binary data (like images) can travel through
   text-only systems

**Final analogy:** think of encoding like different ways to pack for
a trip -- you might fold clothes differently for a backpack vs. a
suitcase, but it's still the same clothes!
