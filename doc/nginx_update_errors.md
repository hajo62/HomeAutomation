```
apt-listchanges: Neuigkeiten
----------------------------

glibc (2.26-5) unstable; urgency=medium

  Starting with version 2.26-1, the glibc requires a 3.2 or later Linux
  kernel.  If you use an older kernel, please upgrade it *before*
  installing this glibc version. Failing to do so will end-up with the
  following failure:

    Preparing to unpack .../libc6_2.26-5_amd64.deb ...
    ERROR: This version of the GNU libc requires kernel version
    3.2 or later.  Please upgrade your kernel before installing
    glibc.

  The decision to not support older kernels is a GNU libc upstream
  decision.

  Note: This obviously does not apply to non-Linux kernels.

 -- Aurelien Jarno <aurel32@debian.org>  Tue, 23 Jan 2018 22:03:12 +0100

(press q to quit)
```


```
apt-listchanges: Neuigkeiten
----------------------------

openssl (1.1.1-2) unstable; urgency=medium

  Following various security recommendations, the default minimum TLS version
  has been changed from TLSv1 to TLSv1.2. Mozilla, Microsoft, Google and Apple
  plan to do same around March 2020.

  The default security level for TLS connections has also be increased from
  level 1 to level 2. This moves from the 80 bit security level to the 112 bit
  security level and will require 2048 bit or larger RSA and DHE keys, 224 bit
  or larger ECC keys, and SHA-2.

  The system wide settings can be changed in /etc/ssl/openssl.cnf. Applications
  might also have a way to override the defaults.

  In the default /etc/ssl/openssl.cnf there is a MinProtocol and CipherString
  line. The CipherString can also sets the security level. Information about the
  security levels can be found in the SSL_CTX_set_security_level(3ssl) manpage.
  The list of valid strings for the minimum protocol version can be found in
  SSL_CONF_cmd(3ssl). Other information can be found in ciphers(1ssl) and
  config(5ssl).

  Changing back the defaults in /etc/ssl/openssl.cnf to previous system wide
  defaults can be done using:
  MinProtocol = None
  CipherString = DEFAULT

  It's recommended that you contact the remote site in case the defaults cause
  problems.

 -- Kurt Roeckx <kurt@roeckx.be>  Sun, 28 Oct 2018 20:58:35 +0100

(press q to quit)

```
