TLS Certificate Chain: Play With It
=======================================

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

A padlock icon means "this connection is encrypted," but that's the
easy half of TLS. The hard half is a much narrower question: *is the
thing on the other end of that encrypted tunnel actually who it
claims to be?* That's what certificate chain verification answers,
and it isn't one check -- it's four independent ones, all of which
have to pass. Get any single one wrong and the whole connection is
rejected, but *which* one failed tells you a very different story
about what went wrong.

Play With It
------------------

A real leaf &rarr; intermediate &rarr; root chain, signed with genuine
ECDSA keys generated in your browser. Break it four different ways --
tamper with a certificate after signing, present a self-signed
impostor, let one expire, or request the wrong hostname -- and watch
exactly one check fail each time, never all four at once.

.. raw:: html
   :file: _static/tls_cert_chain_widget.html

The Four Checks, and Why They're Independent
--------------------------------------------------

.. list-table::
   :class: longtable
   :header-rows: 1
   :widths: 25 45 30

   * - Check
     - What it catches
     - What it does *not* catch
   * - **Signature chain valid**
     - A certificate's bytes were altered after the issuer signed it
       -- the signature no longer matches
     - Whether the issuer itself is trustworthy, or whether the dates
       are still current
   * - **Root trusted**
     - The chain is internally consistent (every signature checks
       out) but terminates at a root your trust store never
       installed -- a self-signed impostor, most commonly
     - Whether an *individual* certificate was tampered with
   * - **Not expired**
     - A certificate's validity window (``notBefore``/``notAfter``)
       doesn't cover right now
     - Anything about who issued it or whether the signature is
       genuine
   * - **Hostname matches**
     - A perfectly legitimate, trusted, current certificate -- just
       not issued for the site you're actually visiting
     - Anything cryptographic at all -- this is a pure string
       comparison against the certificate's Subject Alternative Names

The widget's "Tampered leaf" scenario demonstrates one more thing
worth noticing: mutating the leaf certificate breaks *only* the
leaf's own signature check. The intermediate-to-root link, computed
completely independently, keeps reporting valid -- because it never
looks at the leaf at all. A broken link doesn't cascade upward; it
stops exactly where the tampering happened.

What's Real Here, and What Isn't
---------------------------------------

The signing and verification in this widget are genuine ECDSA
(P-256) via the browser's actual ``crypto.subtle`` -- the same
``SubtleCrypto`` interface a browser's own TLS stack is built on,
generating real keypairs and producing signatures that fail to verify
the instant a single byte changes. What *isn't* real is the
certificate encoding: production TLS certificates are ASN.1 DER
following the X.509 standard, which this widget replaces with a
simplified, human-readable field list. The cryptographic guarantee is
identical; the wire format is not.

These four checks are also not the *entire* story, even in a real TLS
stack: a real client additionally checks whether the certificate has
been **revoked** since it was issued (via a CRL or OCSP), something
this widget doesn't model at all. A cert can pass all four checks here
and still be one a real browser would reject, if its issuing CA had
since revoked it -- revocation checking is a fifth, independent gate,
not a variant of any of the four above.

See Also
-------------

:doc:`ssh_secure_shell_interactive` runs the same "verify who you're
talking to before trusting the channel" idea through SSH's host-key
model instead of a CA hierarchy -- worth comparing the two trust
models directly. :doc:`openssl_guide` covers the certificate and
key-management commands you'd actually run to generate and inspect
certificates like these on the command line.
