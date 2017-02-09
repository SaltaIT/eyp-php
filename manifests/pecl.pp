define php::pecl  (
        $modulename=$name,
        $dependencies=undef,
        $logdir='/var/log/puppet',
        $enablefile=undef,
      ) {
  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($dependencies)
  {
    validate_array($dependencies)

    package { $dependencies:
      ensure => 'installed',
    }
  }

  if($php::params::pecl_dependencies!=undef)
  {
    if ! defined(Package[$php::params::pecl_dependencies])
    {
      package{ $php::params::pecl_dependencies:
          ensure => 'installed',
      }
    }
    $pecl_exec_install_dependencies=[$dependencies, $php::params::pecl_dependencies]
  }
  else
  {
    $pecl_exec_install_dependencies=$dependencies
  }


  exec { "pecl install ${modulename}":
    command => "bash -c 'while :;do echo;done | pecl install ${modulename}' > ${logdir}/.pecl.install.${modulename}.log",
    require => Package[$pecl_exec_install_dependencies],
    unless  => "pecl list | grep -E \'\\b${modulename}\\b\'",
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
      ensure => link,
      target => "/etc/php5/mods-available/${modulename}.ini",
    }
  }

}
