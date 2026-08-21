Complete Guide to OpenSSL
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

The Big Picture
---------------------

OpenSSL is like a Swiss Army knife for security. It's a toolkit that
helps you:

* Lock your messages so only the right person can read them
  (encryption)
* Prove you are who you say you are (certificates)
* Make sure messages haven't been tampered with (hashing)

**Analogy:** think of OpenSSL as a magical locksmith shop that can
create special locks, keys, and seals for your digital world.

What is OpenSSL?
------------------------

OpenSSL is a software library and command-line tool that implements:

* **SSL/TLS protocols** -- secure communication over networks
* **Cryptography functions** -- encryption, decryption, hashing
* **Certificate management** -- creating and managing digital IDs

**Key point:** it's free and open-source. Used by millions of
websites, apps, and systems worldwide!

Core Concepts -- The Building Blocks
------------------------------------------

Encryption (Locking Your Messages)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**What it does:** scrambles data so only authorized people can read
it.

**Analogy:**

* Regular message = postcard (anyone can read it)
* Encrypted message = locked box with a special key

There are two types.

**Symmetric encryption (one key):**

* Same key locks *and* unlocks
* Fast -- great for large files
* Problem: how do you safely share the key?

.. code-block:: text

   ┌─────────────────────────────────────────┐
   │  Alice                         Bob      │
   │    │                            │       │
   │    │  "Secret Key: ABC123"      │       │
   │    │ ──────────────────────────>│       │
   │    │                            │       │
   │    │  Encrypted: &*#@!%         │       │
   │    │ ──────────────────────────>│       │
   │    │                            │       │
   │    │     Uses ABC123 to decrypt │       │
   │    │     "Hello Bob!"           │       │
   └─────────────────────────────────────────┘

   (This is the problem in a picture: if Alice can send the key to
   Bob this easily, so can anyone eavesdropping on the channel.)

Examples: AES (current standard), DES and 3DES (older -- DES is
considered broken today, and 3DES has been deprecated since 2017).

**Asymmetric encryption (two keys):**

* Public key = locks (everyone can have it)
* Private key = unlocks (only you have it)
* Slower -- but solves the key-sharing problem!

.. code-block:: text

   ┌──────────────────────────────────────────┐
   │  Bob shares his PUBLIC key with world   │
   │                                          │
   │  Alice uses Bob's PUBLIC key to lock:   │
   │  "Hello" → &*#@!%                        │
   │                                          │
   │  Only Bob's PRIVATE key can unlock it!  │
   │  &*#@!% → "Hello"                        │
   └──────────────────────────────────────────┘

**Analogy:**

* Public key = mailbox slot (anyone can drop mail in)
* Private key = mailbox key (only you can open it)

Examples: RSA, ECC (Elliptic Curve).

Hashing (Digital Fingerprints)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**What it does:** creates a unique "fingerprint" of data. Change one
letter, completely different fingerprint!

**Key properties:**

* One-way -- can't reverse it back into the original data
* Same input always gives same output
* Tiny change = completely different hash

.. code-block:: text

   Input: "Hello World"
   Hash:  a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e

   Input: "Hello World!"  (added one !)
   Hash:  7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069

**Analogy:** like a fingerprint for files -- a unique identifier that
proves it hasn't been changed.

Uses:

* Verify file downloads (make sure it wasn't corrupted)
* Store passwords safely (don't store the actual password!)
* Check if data was tampered with

Examples: SHA-256, SHA-512, MD5 (old, not secure anymore).

Digital Certificates (Digital ID Cards)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**What it does:** proves a website or person is who they claim to be.

**Analogy:** like a passport or driver's license for websites!

Contains:

* Public key
* Owner's name (domain name for websites)
* Who verified it (Certificate Authority)
* Expiration date

.. code-block:: text

   ┌─────────────────────────────────────┐
   │      DIGITAL CERTIFICATE            │
   ├─────────────────────────────────────┤
   │ Owner: www.google.com               │
   │ Public Key: [long string]           │
   │ Verified by: Google Trust Services  │
   │ Valid: 2024-01-01 to 2025-01-01    │
   │ Signature: [CA's signature]         │
   └─────────────────────────────────────┘

How it works:

1. Website shows you its certificate
2. Your browser checks: "Is this signed by someone I trust?"
3. If yes -> shows padlock, connection is secure
4. If no -> shows a warning

What Security Does OpenSSL Provide?
-----------------------------------------

**1. Confidentiality (privacy)**

Protection: nobody can read your data except the intended recipient.

How: encryption scrambles the data.

Real-world: when you send credit card info to Amazon, it's encrypted
so hackers can't steal it.

**2. Integrity (no tampering)**

Protection: ensures data hasn't been changed during transmission.

How: hashing creates a fingerprint. If data changes, the fingerprint
changes too.

Real-world: download an Ubuntu ISO -- they give you a hash to verify
the file wasn't corrupted or infected.

**3. Authentication (proof of identity)**

Protection: proves you're talking to the real website, not a fake
one.

How: digital certificates verified by trusted authorities.

Real-world: when you visit your bank's website, the certificate
proves it's really your bank, not a phishing site.

**4. Non-repudiation (can't deny it)**

Protection: sender can't deny they sent the message.

How: digital signatures (like signing a document).

Real-world: digitally signing contracts or software updates.

Common OpenSSL Use Cases
------------------------------

Secure Web Browsing (HTTPS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

What happens when you visit ``https://google.com``:

.. uml::

   !theme plain
   participant Browser
   participant Google
   participant "Certificate\nAuthority" as CA

   Browser -> Google: "Hi! Let's talk securely"
   Google -> Browser: "Here's my certificate"
   Browser -> CA: "Is this certificate legit?"
   CA -> Browser: "Yes, I verified Google"
   Browser -> Google: "Let's create a secret key"
   note over Browser,Google: Now all data is encrypted!
   Browser -> Google: Encrypted search query
   Google -> Browser: Encrypted search results

Security provided:

* Confidentiality -- your ISP can't see what you search
* Authentication -- you're talking to the real Google
* Integrity -- data can't be modified in transit

Secure Email (S/MIME)
~~~~~~~~~~~~~~~~~~~~~~~~~~

Problem: regular email is like sending postcards!

Solution: use OpenSSL to encrypt emails.

.. code-block:: text

   Alice's email: "Meet at 3pm"
            ↓
   Encrypt with Bob's public key
            ↓
   Gibberish: &*#@!%$^
            ↓
   Send to Bob
            ↓
   Bob decrypts with his private key
            ↓
   "Meet at 3pm"

Security provided:

* Confidentiality -- only Bob can read it
* Authentication -- Bob knows it's really from Alice

SSH (Secure Remote Login)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Problem: Telnet sends passwords in plain text!

Solution: SSH uses the same kind of asymmetric + symmetric encryption
that OpenSSL implements. (See :doc:`ssh_secure_shell` for the full
handshake.)

.. code-block:: text

   Your computer  ←──[Encrypted tunnel]──→  Remote server
                    Everything encrypted:
                    - Your password
                    - All commands
                    - All output

Security provided:

* Confidentiality -- nobody can spy on your session
* Authentication -- the server proves it's the right one

Code Signing (Software Trust)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Problem: how do you know downloaded software is safe?

Solution: developers sign their code with OpenSSL.

.. code-block:: text

   Developer writes app
         ↓
   Signs it with private key
         ↓
   You download app
         ↓
   Your OS checks signature with dev's public key
         ↓
   Signature valid   = Safe to install
   Signature invalid = WARNING! Don't install!

Security provided:

* Authentication -- really from the developer
* Integrity -- hasn't been modified
* Non-repudiation -- developer can't deny releasing it

VPN Connections
~~~~~~~~~~~~~~~~~~~~

What it does: creates an encrypted tunnel through the internet.

.. code-block:: text

   Your device ──[Plain Internet]──> VPN Server ──> Destination
       ↓                                 ↑
       └────[Encrypted Tunnel]───────────┘

   ISP sees: "He's connected to VPN server"
   ISP can't see: What websites you visit, what you do

Security provided:

* Confidentiality -- ISP/hackers can't see your traffic
* Privacy -- hides your real location

IoT Device Security
~~~~~~~~~~~~~~~~~~~~~~~~

Example: your smart doorbell talking to the cloud.

.. code-block:: text

   Doorbell ←──[Encrypted]──→ Cloud Server

   - Motion detected (encrypted)
   - Video stream (encrypted)
   - Commands from app (encrypted)

Why it matters: without encryption, hackers could watch your camera
feed!

Security provided:

* Confidentiality -- private video stays private
* Authentication -- only your app can control the doorbell

Practical OpenSSL Commands
--------------------------------

Generate Keys
~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Generate private key (keep this SECRET!)
   openssl genrsa -out private.key 2048

   # Generate public key from private key
   openssl rsa -in private.key -pubout -out public.key

Encrypt and Decrypt Files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Encrypt a file
   openssl enc -aes-256-cbc -salt -pbkdf2 -in secret.txt -out secret.txt.enc

   # Decrypt a file
   openssl enc -aes-256-cbc -d -pbkdf2 -in secret.txt.enc -out secret.txt

``-pbkdf2`` tells OpenSSL to derive the encryption key from your
password using PBKDF2 rather than its older, weaker default -- modern
OpenSSL prints a deprecation warning if you leave it out. Both the
encrypt and decrypt commands need it, since they have to agree on how
the key was derived.

**Analogy:** like putting your file in a locked box (``-in``), then
unlocking it later (``-d`` for decrypt).

Create Certificates (Self-Signed)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Create a certificate (like making your own ID card)
   openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 365 -nodes

   # This creates:
   # - key.pem  = Your private key (keep secret!)
   # - cert.pem = Your certificate (share this)

``-nodes`` ("no DES") skips encrypting the private key with a
passphrase. For a dev server that needs to start up unattended,
that's what you want -- without it, ``openssl`` prompts you for a
passphrase and bakes it into ``key.pem``, so your server would need
that passphrase typed in by hand every time it starts. OpenSSL 3.0
deprecated the name (though it still works with no warning as of
3.0.13) in favor of the clearer ``-noenc``, which does exactly the
same thing -- newer scripts should prefer ``-noenc``.

Use case: testing HTTPS on your development server.

Check Certificate Details
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # View certificate information
   openssl x509 -in cert.pem -text -noout

   # Check website certificate
   openssl s_client -connect google.com:443

Create File Hash (Fingerprint)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Create SHA-256 hash of a file
   openssl dgst -sha256 file.txt

   # Output: SHA256(file.txt)= a591a6d40bf420404a011733cfb7b190...

Use case: verify your Ubuntu download wasn't corrupted.

Test SSL/TLS Connection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   # Test if website supports secure connection
   openssl s_client -connect example.com:443

   # Check which SSL/TLS versions are supported
   openssl s_client -connect example.com:443 -tls1_2

When Should You Use OpenSSL?
----------------------------------

**Always use OpenSSL when:**

1. Transmitting sensitive data (passwords, credit cards, personal
   info)
2. Building web services (always use HTTPS!)
3. Storing passwords (hash them with salt)
4. Doing remote access (SSH, VPN)
5. Downloading important files (verify hashes)
6. Creating IoT devices (encrypt device communication)
7. Signing software (prove it's from you)

**Don't need OpenSSL for:**

1. Public information (like blog posts everyone can read)
2. Local-only files (if never leaving your computer)
3. Non-sensitive data (public datasets, open-source code)

**General rule:** if you'd be upset if someone saw or changed it,
use OpenSSL!

Real-World Security Scenarios
-----------------------------------

Scenario 1: Online Shopping
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   You → [HTTPS/OpenSSL] → Amazon

   What's protected:
   - Your credit card number (encrypted)
   - Your password (encrypted)
   - Your address (encrypted)
   - Amazon's identity (certificate)

   What happens without it:
   - Hacker at coffee shop steals your card info
   - Fake "Amazon" site tricks you

Scenario 2: Company VPN
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   Home Computer → [OpenSSL VPN] → Company Network

   What's protected:
   - All your work files (encrypted tunnel)
   - Emails and documents (confidential)
   - Can't be spied on by ISP

   What happens without it:
   - ISP sees everything you access
   - Public WiFi could intercept data

Scenario 3: Software Update
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: text

   Developer signs update with private key
            ↓
   You download update
            ↓
   Your system verifies with public key
            ↓
   Signature matches = Install safely
   Signature fails    = MALWARE ALERT!

   What's protected:
   - You know it's really from the developer
   - File hasn't been infected with a virus
   - No man-in-the-middle attack

OpenSSL Limitations -- What It Doesn't Do
------------------------------------------------

Doesn't protect against:

1. **Weak passwords** -- still need good passwords!
2. **Phishing** -- can't stop you from entering your password on a
   fake site
3. **Malware on your computer** -- if your PC is infected, encryption
   won't help
4. **Physical access** -- someone with your device can still cause
   harm
5. **Human error** -- sharing private keys or falling for scams

**Remember:** OpenSSL is a tool. Like a lock on your door, it only
works if you use it correctly!

Key Takeaways
------------------

**OpenSSL = security Swiss Army knife**

* Encryption, certificates, hashing all in one tool

**Three types of protection:**

* Confidentiality (privacy) -- encryption
* Integrity (no tampering) -- hashing
* Authentication (proof of identity) -- certificates

**Symmetric vs. asymmetric:**

* Symmetric = one key (fast, but key-sharing problem)
* Asymmetric = two keys (slower, but solves key-sharing)

**Everyday uses:**

* HTTPS websites (secure browsing)
* SSH (remote login)
* VPNs (private tunnels)
* Email encryption
* Code signing
* IoT security

**Golden rule:**

* If data is sensitive -> encrypt it!
* If identity matters -> use certificates!
* If integrity matters -> hash it!

**OpenSSL is free and open-source:**

* Powers most of the secure internet
* Available on Linux, Windows, Mac
* Command-line tool + programming library

Quick Decision Tree
-------------------------

.. code-block:: text

   Is the data sensitive?
   ├─ YES → Use encryption
   │   ├─ Sending over network? → Use TLS/SSL (asymmetric + symmetric)
   │   ├─ Storing locally? → Use symmetric encryption (AES)
   │   └─ Sharing keys? → Use asymmetric (RSA/ECC)
   │
   ├─ Need to prove identity? → Use certificates
   │   ├─ Website? → Get SSL/TLS certificate from CA
   │   ├─ Email? → Use S/MIME certificate
   │   └─ Testing only? → Create self-signed certificate
   │
   └─ Need to verify integrity? → Use hashing
       ├─ Passwords? → Hash with salt (bcrypt/scrypt)
       ├─ File downloads? → Provide SHA-256 hash
       └─ Data not tampered? → Compare hashes

Remember the Analogy
--------------------------

Think of OpenSSL as a complete security toolbox:

* Encryption = locked boxes for your secrets
* Keys = special keys (public/private pairs)
* Certificates = digital passports proving identity
* Hashing = fingerprints for data
* TLS/SSL = secure tunnels through the internet

Just like you wouldn't send valuable items in a transparent bag,
don't send sensitive data without OpenSSL protection!
