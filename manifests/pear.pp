define php::pear(
                  $modulename   = $name,
                  $dependencies = undef,
                  $logdir       = '/var/log/puppet',
                  $enablefile   = undef,
                  $manage_ini   = true,
                ) {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  include ::php

  if($dependencies!=undef)
  {
    validate_array($dependencies)

    package { $dependencies:
      ensure => 'installed',
      before => Exec["pear install ${modulename}"],
    }
  }

  # if($php::params::pecl_dependencies!=undef)
  # {
  #   if(!defined(Package[$php::params::pecl_dependencies]))
  #   {
  #     package { $php::params::pecl_dependencies:
  #       ensure => 'installed',
  #       before => Exec["pear install ${modulename}"],
  #     }
  #   }
  # }

  exec { "pear ${modulename} pkg-config":
    command => 'which pkg-config',
    unless  => 'which pkg-config',
  }

  exec { "pear install ${modulename}":
    command => "bash -c 'yes \$'\\n' | pear install ${modulename}'",
    unless  => "pear list | grep -E \'\\b${modulename}\\b\'",
    require => Exec["pear ${modulename} pkg-config"],
  }

  if($manage_ini)
  {
    file { "${php::params::confbase}/mods-available/${modulename}.ini":
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "extension=${modulename}.so\n",
      require => Exec["pear install ${modulename}"],
    }
  }

  if($enablefile)
  {
    file { $enablefile:
      ensure => 'link',
      target => "${php::params::confbase}/mods-available/${modulename}.ini",
    }
  }
}
