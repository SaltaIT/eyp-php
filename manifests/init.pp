# == Class: php
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
