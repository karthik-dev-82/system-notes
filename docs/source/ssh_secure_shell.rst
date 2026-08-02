SSH: Your Secret Internet Tunnel
=====================================

SSH (Secure Shell) is like having a secret tunnel between your computer
and another computer far away. Everything you say through this tunnel
is encrypted (scrambled) so nobody can spy on you.

The Big Idea
-----------------

Imagine you want to control your friend's computer from your house. SSH
lets you do this safely, like having an invisible tube between your
houses where you can pass notes that only you two can read.

How It Works (The Handshake)
----------------------------------

Think of it like a secret handshake with 3 steps:

1. **"Hello, it's me!"** -- you knock on the door (connect to the
   server)
2. **"Prove it!"** -- the server shows you its ID badge, you check if
   it's really your friend
3. **"Here's my password"** -- you prove who *you* are (with password
   or special key)

Two Ways to Prove It's You
--------------------------------

**Password Method:** like a secret word

* Simple but someone might guess it

**Key Method (better!):** like having a special puzzle piece

* You have a private key (keep it secret!)
* Server has your public key (it's okay if others see this)
* They fit together like a lock and key -- only *your* private key
  works with *your* public key

The Visual Flow
--------------------

.. uml::

   !theme plain
   skinparam backgroundColor white
   skinparam defaultFontSize 14
   box Client #LightSalmon
   participant "Your Computer\n(Client)" as Client
   end box
   box Server #LightGreen
   participant "Remote Computer\n(Server)" as Server
   end box

   == Step 1: Hello! ==
   Client -> Server: "I want to connect!"
   Server -> Client: "Here's my ID card\n(public key)"
   Client -> Client: Check: "Is this really\nmy friend's server?"

   == Step 2: Create Secret Code ==
   note over Client, Server
       Both agree on a secret code
       for this conversation ONLY
       (like agreeing on a secret language)
       ..
       Everything from here on is
       already encrypted -- including
       the login step that comes next!
   end note

   == Step 3: Prove Who You Are ==
   alt Password Method
       Client -> Server: "My password is: ****"
       Server -> Client: "Welcome in!"
   else Key Method (Better!)
       Server -> Client: "Solve this puzzle\n(only YOUR key can solve it)"
       Client -> Client: Use private key\nto solve puzzle
       Client -> Server: "Here's the answer!"
       Server -> Client: "That's correct! Welcome!"
   end

   == Step 4: Safe Communication ==
   note over Client, Server
       The session continues using the
       SAME encrypted channel from Step 2
       Like talking in pig latin that
       only you two understand!
   end note

   Client <-> Server: Commands & responses\n(all scrambled)

Fun Analogies to Remember
------------------------------

* **Encryption:** like invisible ink that only the right light can
  reveal
* **Public/Private Keys:** like a mailbox -- anyone can *put* mail in
  (public), but only you have the key to *get* mail out (private)
* **SSH Tunnel:** like a bulletproof tube that connects two treehouses

Real Example
-----------------

When you type:

.. code-block:: bash

   ssh username@example.com

You're saying: "Hey, let me into the computer at ``example.com``. My
username is ``username``."

Why SSH is Awesome
-----------------------

* **Encrypted:** nobody can read your messages
* **Authenticated:** you *know* it's really the server you want
* **Versatile:** control computers, transfer files (``scp``/``sftp``
  both run over SSH), tunnel other connections

Remember This!
-------------------

**SSH = Secure Shell = safe tunnel to control another computer**, like
remote-controlling a robot from far away!

**Pro tip:** the SSH key method is like having a super-complicated
password that's impossible to guess -- and unlike a password, you never
type it anywhere the server (or anyone watching) could see it.
