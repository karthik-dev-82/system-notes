SSH: Your Secret Internet Tunnel
=====================================

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
