puppet-monophylizer
===================

Puppet module to install the monophylizer webtool.
For more information using this tool: https://github.com/naturalis/monophylizer

Parameters
-------------
All parameters are read from hiera

Classes
-------------
- monophylizer
- monophylizer::instances

Dependencies
-------------
- apache
- concat
- perl
- vcsrepo

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
-------------
The resulting website can be found under the last part of the 'docroot' parameter, in this example http://yourserver/monophylizer

Demo data is available at: https://github.com/naturalis/monophylizer/tree/master/data

Example deployment using puppet apply and openstack
-------------
https://github.com/naturalis/puppet/blob/master/private/scripts/cloud-puppet.sh

Example deployment using puppet apply locally, e.g. in a fresh VM
-----------------------------------------------------------------

Below are the steps that would have to be taken. The basic idea is to first bootstrap the VM
to the point where it can clone repositories and apply puppet manifests. Then we install the
additional puppet modules that the ICT dept. have developed, and subsequently the modules
specifically for the monophylizer. If you are simply setting up a VM in order to develop
these modules further you will probably want to take a snapshot right before the last step
so that you can (re-)run the install from a clean snapshot. This works on a clean Ubuntu 12.04.

- `sudo rm -rf /var/lib/apt/lists/*` # [reason](http://askubuntu.com/questions/41605/trouble-downloading-packages-list-due-to-a-hash-sum-mismatch-error)
- `sudo apt-get update`
- `sudo apt-get install git`
- `sudo apt-get install puppet`
- `sudo mv /etc/puppet /etc/puppet.orig`
- `sudo git clone https://github.com/naturalis/puppet.git /etc/puppet`
- `sudo git clone https://github.com/naturalis/puppet-monophylizer.git /etc/puppet/modules/monophylizer`
- `sudo puppet apply /etc/puppet/manifests/monophylizer.pp`

Limitations
-------------
This module has been built on and tested against Puppet 2.7 and higher.

The module has been tested on:
Ubuntu 12.04

Authors
-------------
- [pgomersbach](https://github.com/pgomersbach)
- [hduijn](https://github.com/hduijn)
- [rvosa](https://github.com/rvosa)
