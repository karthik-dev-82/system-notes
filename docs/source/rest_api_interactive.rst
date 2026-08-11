REST APIs: Play With It
==============================

New to REST? Start here -- this page builds up the ideas one at a
time, then hands you a real, running (if tiny) REST API in your
browser to send actual requests against, so the definitions below
aren't just words on a page by the time you reach them.

What "REST" Actually Means
--------------------------------

REST (**Re**\ presentational **S**\ tate **T**\ ransfer) isn't a
protocol or a file format -- it's a set of constraints for designing
APIs over HTTP, described by Roy Fielding in 2000. Strip away the
formality and it comes down to a small number of ideas that all show
up directly in the widget below:

* **Everything is a resource**, addressed by a URI. Not "the endpoint
  that fetches a book" -- *the book itself*, living at
  ``/books/42``.
* **A small, fixed set of HTTP methods act on that resource** --
  ``GET``, ``POST``, ``PUT``, ``PATCH``, ``DELETE`` -- instead of an
  endpoint per verb (no ``/getBook``, ``/createBook``,
  ``/deleteBook``).
* **The server holds no memory of you between requests.** Every
  request carries everything needed to understand it on its own; the
  server doesn't remember "who asked last time."

That third point -- **statelessness** -- is easy to skip past, but
it's why REST APIs scale the way they do: any server behind a load
balancer can handle any request, because no server is holding
session state that only *it* knows about.

Resources and URIs
-------------------------

A resource is a *thing* -- a book, a user, an order -- and its URI is
its address, not a function call. The widget below manages one
resource type, books, at two kinds of URI:

* ``/books`` -- the **collection**: every book.
* ``/books/42`` -- a single **item**: one specific book, forever
  identified by that URI as long as it exists.

Which URI you address, combined with which method you use, is the
entire vocabulary of a REST request. There's no ``/books/delete/42``
-- there's ``DELETE /books/42``.

HTTP Methods, and the Two Properties That Actually Matter
-------------------------------------------------------------------------

Every method has two independent properties worth knowing precisely,
because they're what a client is allowed to assume when something
goes wrong and a request needs retrying:

* **Safe** means the method is read-only by definition -- it must never
  change server state, no matter how many times it's called.
* **Idempotent** means calling it once has the same *effect on server
  state* as calling it many times -- not that the response looks the
  same every time (more on that below).

.. list-table::
   :header-rows: 1

   * - Method
     - Safe?
     - Idempotent?
     - What it does here
   * - ``GET``
     - Yes
     - Yes
     - Read a resource or the whole collection. Never mutates anything.
   * - ``POST``
     - No
     - No
     - Create a *new* resource under a collection, server-assigned id. Calling it twice creates two resources.
   * - ``PUT``
     - No
     - Yes
     - Create-or-replace at a *client-specified* URI. Calling it N times with the same body leaves the same final state as calling it once.
   * - ``PATCH``
     - No
     - Not guaranteed
     - Partially modify an existing resource. May or may not be idempotent depending on what the patch actually says to do.
   * - ``DELETE``
     - No
     - Yes
     - Remove a resource. The *state* (resource gone) converges after one call or many, even though the response code can differ on retry.

Two of these rows contradict what a lot of REST explainers say, and
both are exactly why this widget runs the real logic instead of just
describing it:

**PUT can create, not just replace.** ``PUT /books/50`` on an id that
doesn't exist yet creates it and returns ``201``, exactly like
``POST`` would. The real distinction between ``POST`` and ``PUT``
isn't "create vs. update" -- it's *who picks the URI*. ``PUT`` says
"put this exact representation at this exact address, whether or not
anything is there yet." ``POST`` says "here's data, you (the server)
decide where it lives."

**``PATCH`` is not guaranteed idempotent, and that's not a technicality.**
A patch that says "set the title to X" is idempotent in practice.
A patch that says "increment the view counter by 1" is not -- sending
it twice adds 2, not 1. Nothing about the method itself prevents that
second kind of patch; ``PATCH`` just doesn't promise idempotency the
way ``PUT`` does. Try the "Increment views" preset below twice in a
row and watch the number actually diverge.

Status Codes: the Response Half of the Contract
---------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Code
     - Meaning
     - Shows up here when
   * - ``200 OK``
     - Success, response has a body
     - A successful ``GET``, or a ``PUT``/``PATCH`` on something that already existed
   * - ``201 Created``
     - Success, a new resource now exists
     - A successful ``POST``, or a ``PUT`` at a URI that didn't exist yet
   * - ``204 No Content``
     - Success, nothing to return
     - A successful ``DELETE``
   * - ``400 Bad Request``
     - The request itself is malformed
     - Invalid JSON in the request body
   * - ``404 Not Found``
     - No resource at that URI
     - ``GET``/``PATCH``/``DELETE`` on an id that doesn't exist
   * - ``405 Method Not Allowed``
     - That method isn't supported on this URI
     - ``DELETE /books`` (deleting the whole collection isn't a route here)

Play With It
------------------

.. raw:: html
   :file: _static/rest_api_widget.html

Every response above came from the request actually being routed and
handled against real, mutable, in-memory state -- there's no lookup
table of canned answers behind it. Send the same ``POST`` twice and
watch two different ids appear in the server-state panel. ``PUT`` an
id that doesn't exist and watch it come back ``201`` instead of
``404``. Delete a book, then delete it again, and compare the two
status codes against the identical resulting state.

What's Beyond This Widget
--------------------------------

Real production REST APIs layer more on top of everything above:
authentication (who's allowed to do this), pagination (``/books`` with
a million rows doesn't return all of them at once), rate limiting,
content negotiation (``Accept: application/json`` vs. ``text/csv``),
and often a version in the URI or a header (``/v2/books``) so the API
can change without breaking every existing client at once. None of
that changes the mechanics above -- it sits on top of the same
resource/method/status-code vocabulary this widget models for real.
