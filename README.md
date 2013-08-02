puppet-monophylizer
===================

Puppet module to install the monophylizer webtool.
For more information using this tool: https://github.com/ncbnaturalis/monophylizer

Parameters
-------------
All parameters are read from hiera

Classes
-------------
monophylizer
monophylizer::instances

Dependencies
-------------
Apache, concat, perl, vcsrepo

Examples
-------------
Hiera yaml
```
monophylizer:
  monophylizer.cloud.naturalis.nl:
    serveraliases: '*.cloud.naturalis.nl'
    docroot: /var/www/monophylizer
    port: 80
    ssl: no
    serveradmin: bestaatniet@naturalis.nl
    options: +FollowSymLinks +ExecCGI
```
Puppet code
```
class { monophylizer: }
```
Result
The resulting website can be found under the last part of the 'docroot' parameter, in this example http://yourserver/monophylizer
Limitations
-------------
This module has been built on and tested against Puppet 2.7 and higher.

The module has been tested on:
Ubuntu 12.04

Authors
-------------
Author Name <p.gomersbach@gmail.com>

