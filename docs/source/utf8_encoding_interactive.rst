UTF-8 & Unicode: Play With It
==============================

Unicode assigns every character on the planet -- and a fair number of
emoji -- a unique number called a **code point**. UTF-8 is the rule
for turning that number into actual bytes on disk or on the wire, and
the rule is deliberately not "always use the same number of bytes":
an English letter costs 1 byte, an emoji can cost 4, and the byte
count is derivable from the bits alone, with no external length field
needed.

Play With It
------------------

Pick some text (or type your own), then step through it one character
at a time: watch its code point get looked up, matched against a
byte-length range, and sliced bit-by-bit into the real UTF-8 bytes.
Once the whole string is encoded, run it in reverse and watch the
exact same byte stream decode itself back into text -- including a
demo of why a decoder that starts reading in the middle of a
multi-byte character can always tell, and always recover.

.. raw:: html
   :file: _static/utf8_encoding_widget.html

Why the Byte Count Is Self-Describing
---------------------------------------------

UTF-8 never needs to be told how many bytes a character uses --
the first byte announces it:

.. list-table::
   :header-rows: 1
   :widths: 30 30 40

   * - First byte pattern
     - Meaning
     - Total bytes
   * - ``0xxxxxxx``
     - plain ASCII, unchanged since 1963
     - 1
   * - ``110xxxxx``
     - two leading 1s before the 0
     - 2
   * - ``1110xxxx``
     - three leading 1s before the 0
     - 3
   * - ``11110xxx``
     - four leading 1s before the 0
     - 4
   * - ``10xxxxxx``
     - a *continuation* byte -- can never start a character
     - (mid-sequence only)

That last row is the important one, and it's what the widget's
"simulate starting mid-stream" button demonstrates: because
continuation bytes are the only bytes that begin with ``10``, and no
lead byte ever does, a decoder can jump into a byte stream at any
point and immediately tell whether it landed on a character boundary
or in the middle of one. If it's mid-character, it just skips forward
until the pattern says otherwise -- no ambiguity, no external framing
needed.

See Also
-------------

For the fuller writeup -- Unicode planes, hand-worked multi-language
examples, and the ASCII-vs-Unicode comparison -- see
:doc:`unicode_utf8_encoding`. For a related but different byte-to-text
problem (making arbitrary *binary* data safe for text-only channels,
rather than encoding text itself), see :doc:`base64_encoding`.
