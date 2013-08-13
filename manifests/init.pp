# == Class: monophylizer
#
# This class installs the monophylizer webtool, for more information https://github.com/ncbnaturalis/monophylizer
#
# === Parameters
#Hiera yaml
# monophylizer:
#  monophylizer.cloud.naturalis.nl:
#    serveraliases: '*.cloud.naturalis.nl'
#    docroot: /var/www/monophylizer
#    port: 80
#    ssl: no
#    serveradmin: bestaatniet@naturalis.nl
#    options: +FollowSymLinks +ExecCGI
#
# === Variables
#
# === Examples
#
# class { monophylizer: }
# The resulting website can be found under the last part of the 'docroot' parameter, in this example http://yourserver/monophylizer
# Demo data is available at: https://github.com/naturalis/monophylizer/tree/master/data
#
# === Authors
#
# Author Name <p.gomersbach@gmail.com>
#
# === Copyright
#
# Copyright 2013 Naturalis.
#
#
class monophylizer {
  include concat::setup
  include apache

  package { 'perl-doc':
    ensure => present,
  }

  class { 'perl':
    require  => Package['perl-doc'],
  }

  perl::module { 'Bio::Phylo':
    require  => Package['perl-doc'],
  }

  class { 'monophylizer::instances': }

  vcsrepo { '/var/monophylizer':
    ensure   => latest,
    provider => git,
    source   => 'https://github.com/ncbnaturalis/monophylizer.git',
    require  => Class['monophylizer::instances'],
  }

  file { '/var/monophylizer/script/monophylizer.pl':
    ensure  => 'file',
    mode    => '0755',
    require => Vcsrepo['/var/monophylizer'],
  }

  file { '/usr/lib/cgi-bin/monophylizer.pl':
    ensure  => 'link',
    mode    => '0777',
    target  => '/var/monophylizer/script/monophylizer.pl',
    require => Vcsrepo['/var/monophylizer'],
  }

  file { '/var/www/monophylizer/index.html':
    ensure  => 'link',
    mode    => '0644',
    target  => '/var/monophylizer/html/monophylizer.html',
    require => Vcsrepo['/var/monophylizer'],
  }

  file { '/var/www/monophylizer/sorttable.js':
    ensure  => 'link',
    mode    => '0644',
    target  => '/var/monophylizer/script/sorttable.js',
    require => Vcsrepo['/var/monophylizer'],
  }
}
