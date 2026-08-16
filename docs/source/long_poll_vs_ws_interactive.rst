Long Polling vs. WebSockets: Play With It
================================================

Both of these exist to solve the same problem: plain HTTP is
request-response -- the client always speaks first. Neither "the
server just tells me when something happens" nor "I get updates
without asking every second" is possible with a bare request. Long
polling and WebSockets are two different fixes for that, built at
different layers, with genuinely different cost and latency
characteristics -- not just two names for the same idea.

Long Polling: A Regular HTTP Request That Waits
-------------------------------------------------------------

Long polling is a trick played entirely with ordinary HTTP requests,
no new protocol involved:

1. The client sends a normal ``GET`` request.
2. The server does **not** respond immediately. It holds the
   connection open and waits.
3. The instant something worth reporting happens, the server responds
   with it -- or, if nothing happens before a timeout, it responds
   with an empty result anyway, just to close out the request cleanly.
4. The client, having received *either* kind of response, immediately
   opens a new request and the cycle repeats.

From the outside this looks like real-time push, but underneath it's
still request-response, just with a deliberately delayed response.
Every delivery -- and every timeout -- costs one full HTTP request:
new TCP/TLS overhead (unless connections are being reused), new
headers, a new response.

WebSockets: One Connection, Kept Open
--------------------------------------------------

A WebSocket starts as a single HTTP request (the "upgrade" handshake)
and then the connection itself changes character: it stops being
HTTP and becomes a raw, persistent, full-duplex pipe between client
and server. After that one handshake, either side can send a message
to the other at any moment, with no new request needed and no polling
cycle to restart. The server *pushes* the instant it has something --
there's no "ask again" step at all.

Play With It
------------------

.. raw:: html
   :file: _static/long_poll_vs_ws_widget.html

Both tracks react to the exact same event schedule, so the comparison
is apples-to-apples. A few things worth actually doing with the
widget, not just reading about:

* Click **Randomize Events** a few times and watch the **request
  count** -- long polling's count scales with how long the run is and
  how the timeout is configured; WebSocket's count is always exactly
  1, regardless of how many events arrive or how long the widget runs.
* Click **Load Reconnect-Gap Example**. This deliberately places one
  event in the idle window between one poll closing and the next one
  opening -- the one real latency gap long polling has that a
  WebSocket structurally cannot, because a WebSocket is never "between
  requests." Watch the delivery marker (green ✓) land several
  ticks after the event marker (amber ◆) on the Long Polling
  track, while the WebSocket track always delivers on the exact same
  tick the event occurs.
* Drag the **poll timeout** and **reconnect delay** sliders and
  re-run the gap example -- a shorter timeout means more requests but
  a smaller worst-case gap; a longer reconnect delay makes that gap
  worse. This is the real tuning knob long-polling systems actually
  have to turn, and it's a direct trade: fewer requests always costs
  more worst-case latency, in both directions.
* Every event that occurs is delivered exactly once under both
  approaches, no matter how the sliders are set or how the random
  schedule lands -- that invariant (no drop, no duplicate) was
  fuzz-tested across 2000 random schedules before this widget was
  built, not just eyeballed on a couple of examples.

Which One Actually Gets Used
------------------------------------

WebSockets look strictly better in the comparison above, and for pure
delivery latency and request overhead, they are. So why does long
polling still show up in real systems?

* **It's just HTTP.** Every proxy, load balancer, corporate firewall,
  and CDN already knows how to route and cache ordinary HTTP requests.
  A WebSocket is a different kind of connection that has to be
  explicitly supported end to end -- some infrastructure still doesn't
  handle it cleanly.
* **Simplicity for infrequent updates.** If real-time events are rare
  (a few per hour, not per second), the gap latency long polling
  introduces barely matters, and there's no persistent connection to
  manage, scale, or reconnect on the server side.
* **Server connection cost is a real trade, not a free win.** A
  WebSocket server has to hold one open connection per client for as
  long as that client is around, even when nothing is happening. Long
  polling's connections are much shorter-lived by comparison -- this
  matters at very large numbers of concurrent, mostly-idle clients.

In practice: WebSockets for anything genuinely real-time and frequent
(chat, live cursors, multiplayer state), long polling as the simpler
fallback (or the only option some environments allow) when updates are
infrequent enough that the latency gap doesn't matter.

See Also
--------------

See :doc:`rest_vs_rpc_interactive` for another case where the choice
of transport mechanics -- not just the data format -- decides what a
client is safe to assume. See :doc:`kafka_topic_interactive` for a
different, broker-mediated way to get events from a producer to many
consumers, instead of the direct client-server push modeled here.
