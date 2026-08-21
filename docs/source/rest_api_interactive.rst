REST APIs: Play With It
==============================

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
