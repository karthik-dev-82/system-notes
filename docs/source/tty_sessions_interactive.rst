Terminal Sessions (TTY/PTY/Serial): Play With It
=================================================

"Why do I see ``/dev/pts/2``?" and "what does ``who`` actually mean?"
both come down to the same small set of rules: pseudo-terminals
(``/dev/pts/N``) come from one shared, lowest-free-index pool no
matter whether they were opened by a local GUI terminal or an
incoming SSH connection; virtual consoles (``tty1``-``tty6``) are a
fixed set where exactly one is ever the *active* (displayed) one,
completely independent of which ones happen to have a login session
running; and ``/dev/ttyS0`` is a single physical wire that can only
ever hold one occupant at a time.

Play With It
------------------

Open a few GUI terminals and SSH sessions and watch them land in one
shared ``/dev/pts/N`` pool. Close one in the middle and open a new one
to see the freed index get reused -- but only for the *next* session,
never by renumbering one that's already open. Switch virtual consoles
and confirm a login survives being switched away from and back.
Connect a serial cable and try connecting a second one while the first
is still attached.

.. raw:: html
   :file: _static/tty_sessions_widget.html

See :doc:`linux_devices` for the full terminal-device write-up this
widget is built from, and :doc:`usb_binding_interactive` for the same
"shared pool, lowest free index, no retroactive renumbering" pattern
applied to USB serial adapters instead of terminal sessions.
