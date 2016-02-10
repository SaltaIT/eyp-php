define php::pecl  (
        $modulename=$name,
        $dependencies=undef,
        $logdir='/var/log/puppet',
        $enablefile=undef,
      ) {
  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if defined(Class['ntteam'])
  {
    ntteam::tag{ "php::pecl::${modulename}": }
  }

  if($dependencies)
  {
    validate_array($dependencies)

    package { $dependencies:
      ensure => 'installed',
    }
  }

  if ! defined(Package[$php::params::pecl_dependencies])
  {
    package{ $php::params::pecl_dependencies:
        ensure => 'installed',
    }
  }

  exec { "pecl install ${modulename}":
    command  => "bash -c 'while             :;do echo;done | pecl install ${modulename}' > ${logdir}/.pecl.install.${modulename}.log",
    require  => Package[[$dependencies, $php::params::pecl_dependencies]],
    #creates => "${logdir}/.pecl.install.${modulename}.log",
    unless   => "pecl list | grep -E \'\b${modulename}\b\'",
  }

  file { "/etc/php5/mods-available/${modulename}.ini":
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
      ensure => "/etc/php5/mods-available/${modulename}.ini",
    }
  }

}
