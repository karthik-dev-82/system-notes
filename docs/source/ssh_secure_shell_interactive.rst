SSH Handshake: Play With It
==============================

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
never sends), and the eavesdropper's log below it (exactly what's
visible to anyone watching the wire, and the moment it turns to
ciphertext).

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
