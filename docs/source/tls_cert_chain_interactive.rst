TLS Certificate Chain: Play With It
=======================================

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
