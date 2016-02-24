# == Class: php
#
# Full description of class php here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'php':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class php   (
      $phpcli=true,
      $customini=undef,
      $confbase=$php::params::confbase_cli,
    ) inherits params{

  if defined(Class['ntteam'])
  {
    ntteam::tag{ 'php': }
  }

  package { $php::params::phpdependencies:
    ensure => 'installed',
  }

  if($phpcli)
  {
    package { $php::params::phpcli:
      ensure  => 'installed',
      require => Package[$php::params::phpdependencies],
    }

    if($customini)
    {
      file { "${confbase}/php.ini":
      ensure => $customini,
      force  => true,
      }
    }
  }
}
