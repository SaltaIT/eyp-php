define php::pecl  (
        $modulename   = $name,
        $dependencies = undef,
        $logdir       = '/var/log/puppet',
        $enablefile   = undef,
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
      before => Exec["pecl install ${modulename}"],
    }
  }

  exec { "pecl install ${modulename}":
    command => "bash -c 'while :;do echo;done | pecl install ${modulename}' > ${logdir}/pecl.install.${modulename}.log",
    unless  => "pecl list | grep -E \'\\b${modulename}\\b\'",
  }

  file { "${php::params::confbase}/mods-available/${modulename}.ini":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "extension=${modulename}.so\n",
    require => Exec["pecl install ${modulename}"],
  }

  if($enablefile)
  {
    file { $enablefile:
      ensure => 'link',
      target => "${php::params::confbase}/mods-available/${modulename}.ini",
    }
  }

}
