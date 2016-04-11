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
# Copyright 2013-2016 Naturalis.
#
#
class monophylizer (
  $instances           = {'monophylizer.naturalis.nl' => { 
                           'serveraliases'   => '*.naturalis.nl',
                           'docroot'         => '/var/www/monophylizer',
                           'port'            => 80,
                           'scriptalias'     => '/usr/lib/cgi-bin',
                           'serveradmin'     => 'aut@naturalis.nl',
                           'priority'        => 10,
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

  # installs the command line tool to read perldoc-formatted manual pages
  # using whatever is the package manager (probably apt-get)
  package { 'perl-doc':
    ensure     => present,
    require    => Package['build-essential']
  }
  
  # installs the XML::Twig perl library for parsing XML documents, needed
  # for monophylizing NeXML and phyloXML documents.
  package { 'libxml-twig-perl':
    ensure     => present,
  }

  # install build-essential requirement of cpanminus for installing modules
  package { 'build-essential':
    ensure     => present,
  }

  # sets up perl tools, e.g. cpanminus
  class { 'perl':
    require    => Package['perl-doc'],
  }

  # installs the Bio::Phylo perl library using cpanminus
  perl::module { 'Bio::Phylo':
    require    => Package['perl-doc'],
  }

  class { 'monophylizer::instances': 
    instances  => $instances,
  }

  # install git, required for vcsrepo
  package { 'git':
    ensure     => present
  }

  # clones the monophylizer repository into /var
  vcsrepo { $appdir:
    ensure     => latest,
    provider   => git,
    source     => $reposource,
    revision   => 'master',
    notify     => Exec['static_files'],
    require    => [Package['git'],Class['monophylizer::instances']],
  }

  # sets monophylizer.pl script to executable
  file { "${appdir}/script/monophylizer.pl":
    ensure     => 'file',
    mode       => '0755',
    require    => Vcsrepo[$appdir],
  }

  exec { 'static_files':
    command    => "/bin/cp -fr * ${webdir}/",
    refreshonly => true,
    cwd        => "${appdir}/html/",
    require    => Vcsrepo[$appdir],
  }

  file { "${webdir}/sorttable.js":
    ensure     => 'link',
    mode       => '0644',
    target     => "${appdir}/script/sorttable.js",
    require    => Vcsrepo[$appdir],
  }
}
