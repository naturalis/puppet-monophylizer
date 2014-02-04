# == Class: monophylizer
#
# This class installs the monophylizer webtool, for more information https://github.com/ncbnaturalis/monophylizer
#
# === Parameters
# Hiera yaml
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
class monophylizer (
  $instances           = {'monophylizer.cloud.naturalis.nl' => { 
                           'serveraliases'   => '*.cloud.naturalis.nl',
                           'docroot'         => '/var/www/monophylizer',
                           'port'            => 80,
                           'scriptalias'     => '/usr/lib/cgi-bin',
                           'serveradmin'     => 'webmaster@monophylizer.naturalis.nl',
                           'priority'        => 20,
                           'options'         => '+FollowSymLinks +ExecCGI',
                          },
			},
  $reposource         = 'https://github.com/naturalis/monophylizer.git',
  $appdir             = '/var/monopylizer',
  $webdir             = '/var/www/monophylizer',
  $libdir             = '/usr/lib/cgi-bin',

){
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

  class { 'monophylizer::instances': 
    instances => $instances,
  }

  vcsrepo { $appdir:
    ensure   => latest,
    provider => git,
    source   => $reposource,
    revision => 'master',
    require  => Class['monophylizer::instances'],
  }

  file { "${appdir}/script/monophylizer.pl":
    ensure  => 'file',
    mode    => '0755',
    require => Vcsrepo[$appdir],
  }

  file { "${libdir}/monophylizer.pl":
    ensure  => 'link',
    mode    => '0777',
    target  => "${appdir}/script/monophylizer.pl",
    require => Vcsrepo[$appdir],
  }

  file { "${webdir}/index.html":
    ensure  => 'link',
    mode    => '0644',
    target  => "${appdir}/html/monophylizer.html",
    require => Vcsrepo[$appdir],
  }

  file { "${webdir}/sorttable.js":
    ensure  => 'link',
    mode    => '0644',
    target  => "${appdir}/script/sorttable.js",
    require => Vcsrepo[$appdir],
  }
}
