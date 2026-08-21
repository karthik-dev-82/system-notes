SSH Handshake: Play With It
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

The plain-language version of SSH is "an encrypted tunnel plus a way
to prove who you are." This widget makes both halves concrete: a real
(deliberately tiny) Diffie&ndash;Hellman key exchange runs first, and
only after that tunnel is up does either password or public-key
authentication happen -- which is exactly why sniffing SSH traffic on
the wire today doesn't hand over a password even when password auth
is in use.

Play With It
------------------

Pick a host-key scenario -- first connection, a host you've already
trusted, or a host whose key has changed since last time -- and an
authentication method, then start the connection. Watch two things at
once: the private boxes above the wire (what each side computes and
never sends), and the eavesdropper's log below it (what's actually
visible to anyone watching the wire, the moment it turns to
ciphertext, and a few local-only client decisions -- like the
first-connection trust prompt -- clearly marked as such, since those
never touch the wire at all).

.. raw:: html
   :file: _static/ssh_handshake_widget.html

Why Key Exchange Happens Before Login
---------------------------------------------

Every SSH connection runs the same two phases in the same order,
regardless of which authentication method you end up using:

.. list-table::
   :header-rows: 1
   :widths: 20 40 40

   * - Phase
     - What happens
     - Visible to an eavesdropper?
   * - 1. Key exchange
     - Client and server each compute the *same* shared secret
       independently (Diffie&ndash;Hellman), without ever transmitting
       it. A symmetric session key is derived from it.
     - Only the public values (``A``, ``B``, the host key) -- never
       the secret itself.
   * - 2. Authentication
     - Password or public-key proof travels *inside* the tunnel phase
       1 just built.
     - Ciphertext only. Even a plaintext password, at this point, is
       already encrypted before it leaves the client.

That ordering is also why the host-key check in the widget's
"Key CHANGED" scenario matters as much as it does: it happens *during*
phase 1, before anything worth protecting has been sent. If a
machine-in-the-middle could get past it, phase 2 wouldn't help you --
your password or signature would go straight to the attacker's
encrypted tunnel instead of the real server's.

See Also
-------------

For the plain-language overview and the full three-step handshake
diagram, see :doc:`ssh_secure_shell`.
