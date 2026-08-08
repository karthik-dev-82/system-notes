GStreamer Pipelines: Play With It
=====================================

What Is GStreamer?
------------------------

GStreamer is a factory assembly line for audio and video. A toy
factory has stations that each do one job -- cutting, painting,
assembling. GStreamer has **elements** that each do one job to a
stream of audio or video: read it, decode it, resize it, encode it,
or send it somewhere.

Think of a water pipeline in a house:

* Water comes from a **source** (the tank)
* It flows through **pipes** (the connections)
* It passes through **filters** (removing dirt)
* It might get **transformed** (heated)
* It finally reaches a **sink** (the faucet)

A GStreamer pipeline works exactly the same way, just with video and
audio instead of water -- and the same word, "sink", is the real
GStreamer term for wherever a stream ends up (a screen, speakers, or
a file).

.. code-block:: text

   [SOURCE] -> [FILTER] -> [TRANSFORM] -> [SINK]
    camera     clean up      change       display
               the video     colors      on screen

Play With It
------------------

Click elements to chain them together, exactly like writing a
``gst-launch-1.0`` pipeline one element at a time. Every link is
checked the way real caps negotiation works: an element only accepts
the kind of data the element before it actually produces. Try linking
``filesrc`` straight to ``autovideosink`` and watch it fail with the
exact "not negotiated" error real GStreamer reports -- then fix it
with ``decodebin`` and a converter. Try linking something to
``decodebin`` before probing it, too: a real ``decodebin`` has no
output pad at all until it has actually looked inside the file.

.. raw:: html
   :file: _static/gstreamer_pipeline_widget.html

The Three Element Roles
------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 20 40 40

   * - Role
     - Job
     - Examples from this page
   * - Source
     - Where the data comes from -- no input pad, only output
     - ``filesrc``, ``v4l2src`` (camera), ``videotestsrc``,
       ``audiotestsrc``
   * - Filter / Transform
     - Changes the data in some way, or just decodes/encodes it
     - ``decodebin``, ``videoconvert``, ``audioconvert``, ``x264enc``,
       ``queue``
   * - Sink
     - Where the data ends up -- only input pad, no output
     - ``autovideosink``, ``autoaudiosink``, ``filesink``,
       ``fakesink``

A Python Example: Handling decodebin's Dynamic Pad
----------------------------------------------------------

This is the exact mechanism the widget's "pending" state models.
``decodebin`` doesn't know what's inside a file until it has actually
read some of it, so it can't have an output pad ready in advance --
instead, it fires a ``pad-added`` signal once it knows, and the
application links to that pad only at that moment:

.. code-block:: python

   import gi
   gi.require_version('Gst', '1.0')
   from gi.repository import Gst, GLib

   Gst.init(None)

   pipeline = Gst.Pipeline.new("video-player")
   source = Gst.ElementFactory.make("filesrc", "file-source")
   decoder = Gst.ElementFactory.make("decodebin", "decoder")
   converter = Gst.ElementFactory.make("videoconvert", "converter")
   sink = Gst.ElementFactory.make("autovideosink", "video-output")

   source.set_property("location", "movie.mp4")

   for element in (source, decoder, converter, sink):
       pipeline.add(element)

   source.link(decoder)
   # decoder has no output pad yet -- link the REST of the chain now,
   # then connect decoder's eventual pad to it once it exists
   converter.link(sink)

   def on_pad_added(element, pad):
       """Fires once decodebin has figured out what's in the file"""
       sinkpad = converter.get_static_pad("sink")
       pad.link(sinkpad)

   decoder.connect("pad-added", on_pad_added)

   pipeline.set_state(Gst.State.PLAYING)

Notice ``converter.link(sink)`` happens immediately -- that part of
the chain is static and known in advance. Only the link *into*
``converter`` waits for the signal, because that's the only pad that
doesn't exist yet when the script starts.

Common Issues and Solutions
----------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 30 70

   * - Problem
     - Solution
   * - "Not negotiated"
     - Add ``videoconvert`` or ``audioconvert`` between the two
       elements that disagree on format
   * - Pipeline hangs
     - Add ``queue`` elements for buffering -- this doesn't fix a
       format mismatch, it fixes two elements running at different
       speeds
   * - No video output
     - Check that ``autovideosink`` (or a specific sink like
       ``ximagesink``) is actually installed
   * - Choppy playback
     - Increase queue sizes: ``queue max-size-buffers=0
       max-size-time=0``

Key Concepts
------------------

* **Buffers** -- small chunks of data flowing through the pipeline
  (like drops of water), each carrying a timestamp and duration
  alongside the actual audio/video data.
* **Pads** -- connection points on an element. A **source pad** is
  output (``element.get_static_pad("src")``); a **sink pad** is input
  (``element.get_static_pad("sink")``). Most pads are static and exist
  the moment the element is created; ``decodebin``'s output pad is
  **dynamic** -- created later, once the element knows what it's
  looking at.
* **Bins** -- a group of elements packaged as one reusable unit. A
  ``playbin`` is a bin that already contains a source, a decoder, and
  a sink internally -- ``player.set_property("uri", "file:///video.mp4")``
  is often all that's needed for simple playback.
* **Bus** -- the messaging channel elements use to report errors,
  end-of-stream, and state changes back to the application.
* **States** -- ``NULL`` (off), ``READY`` (on, not running),
  ``PAUSED`` (ready, frozen), ``PLAYING`` (running). A pipeline moving
  from ``NULL`` to ``PLAYING`` passes through every state in between,
  in order.
