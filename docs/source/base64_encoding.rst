Base64 Encoding (and Other Text Encodings)
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

Other Important Encodings
-------------------------------

ASCII Encoding
~~~~~~~~~~~~~~~~~~

* **What:** converts letters/numbers to computer numbers (0-127)
* **Analogy:** like giving each letter in the alphabet a jersey number
* **Example:** letter ``A`` = 65, ``B`` = 66
* **Used for:** basic English text in computers

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
  before being sent in a request header -- this is *not* secure on
  its own (Base64 is trivially reversible, not encryption), and
  relies entirely on TLS for actual protection

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
