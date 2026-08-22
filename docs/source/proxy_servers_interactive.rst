Proxy Servers: Forward, Reverse, and What Actually Changes
===================================================================

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

     div.document p.plantuml { text-align: center; margin: 30px 0; }
     div.document p.plantuml img {
       max-width: 100%;
       height: auto;
       background: #ffffff;
       border: 1px solid #cdd6cc;
       padding: 20px;
     }
   </style>

A proxy sits between a client and a server and forwards traffic on
someone's behalf -- the entire distinction between "forward" and
"reverse" comes down to **whose behalf**.

Forward Proxy: Hides the Client
--------------------------------------

A forward proxy sits in front of a group of *clients*. The client is
configured to send its traffic through the proxy; the destination
server sees the proxy's IP, not the client's. Corporate egress proxies
and most VPN-style setups are forward proxies -- their job is
controlling and hiding *outbound* traffic.

Reverse Proxy: Hides the Server
----------------------------------------

A reverse proxy sits in front of a group of *servers*. The client
doesn't know (or need to know) it's talking to a proxy at all -- it
just sees one address, and the proxy decides which backend actually
handles the request. Nginx, Envoy, and most load balancers you already
know from :doc:`hash_load_balancer_interactive` and
:doc:`consistent_hashing_interactive` are reverse proxies. Their job is
controlling and hiding *inbound* traffic -- everything below this
point is reverse-proxy territory.

.. uml::

   !theme plain
   skinparam backgroundColor white
   actor "Client" as fc
   rectangle "Forward Proxy" as fp #LightBlue
   cloud "The Internet" as internet1
   fc -> fp : "I want google.com"
   fp -> internet1 : proxy's IP, not the client's

   actor "Client" as rc
   rectangle "Reverse Proxy" as rp #LightSalmon
   rectangle "Backend Pool" as backend #LightGreen
   rc -> rp : one public address
   rp -> backend : proxy decides which server

The client-facing side never sees the fan-out; the reverse proxy is
the single thing the internet actually talks to.

Play With It
------------------

The rest of this page is reverse-proxy mechanics specifically, since
that's what the vast majority of "proxy" questions in system design
actually mean. Both tabs run the real logic live.

.. raw:: html
   :file: _static/proxy_servers_widget.html

X-Forwarded-For: A Real, Documented Spoofing Bug
------------------------------------------------------------

Once a reverse proxy sits in front of your backend, the backend no
longer sees the client's real IP at the TCP layer -- it sees the
proxy's. The fix is the ``X-Forwarded-For`` header: each proxy in the
chain *appends* the IP it actually observed as its own TCP peer.

.. code-block:: text

   Client (203.0.113.7) -> Edge Proxy (10.0.0.1) -> Internal Proxy (10.0.0.2) -> Backend
   X-Forwarded-For: 203.0.113.7, 10.0.0.1

That per-hop observation is genuinely unspoofable -- it's the real
socket peer, not something the client controls. But the *header
value the client sends before any proxy touches it* is just an HTTP
header, and any client can set it to anything:

.. code-block:: text

   # attacker sets this themselves, before it ever reaches your infrastructure
   X-Forwarded-For: 6.6.6.6

   # after your two real proxies append what they actually saw:
   X-Forwarded-For: 6.6.6.6, 203.0.113.7, 10.0.0.1

A parser that naively takes the *first* entry as "the real client IP"
returns ``6.6.6.6`` -- the attacker's fake value, not the real one. The
fix, verified above with a 3,000-trial fuzz test, is to trust only the
last **N** entries, where N is the number of proxies *you* control --
everything to the left of that block is untrusted input, no matter how
many fake hops someone stuffs in front of it. This is the actual
mechanism behind ``real_ip`` modules and trusted-proxy configuration in
real infrastructure, not a simplified toy version of it.

TLS Termination Is About the Certificate, Not a License for Plaintext
------------------------------------------------------------------------------------------

"TLS terminates at the proxy" means the proxy holds the certificate
and does the decryption -- the backend never has to manage certs at
all. What happens on the *next* hop is a separate decision entirely:

* **Private network the proxy also controls:** plaintext HTTP to the
  backend is normal, common practice -- the traffic never leaves
  infrastructure you already trust.
* **Backend reached over a public or untrusted network:** the proxy
  needs to re-encrypt for that hop. Terminating TLS at the edge was
  never a reason to send plaintext across a network you don't control.

Remember
------------

#. Forward proxy hides the client; reverse proxy hides the server --
   the direction of "who's being protected" is the whole distinction.
#. ``X-Forwarded-For`` is safe to trust only from the right, counting
   exactly as many entries as you have known proxies -- never trust
   the leftmost entry, since it can be attacker-supplied.
#. TLS termination at the edge is about certificate placement, not
   about whether the rest of the path can be plaintext -- that depends
   on whether the next hop is actually trusted infrastructure.

See Also
--------------

:doc:`hash_load_balancer_interactive` and
:doc:`consistent_hashing_interactive` for how a reverse proxy actually
picks *which* backend to route to, once it's decided to forward the
request. :doc:`rate_limiting_interactive` for another job reverse
proxies commonly do at the edge.
