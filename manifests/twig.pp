define php::twig(
                  $installdir = '/usr/local/src/twig',
                  $enablefile = undef,
                ) {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  validate_absolute_path($installdir)

  if ! defined(Package[$php::params::pecl_dependencies])
  {
    package{ $php::params::pecl_dependencies:
      ensure => 'installed',
    }
  }

  exec { "mkdir_p_${installdir}":
    command     => "mkdir -p ${installdir}",
    refreshonly => true,
  }

  file { $installdir:
    ensure  => 'directory',
    group   => 'root',
    owner   => 'root',
    mode    => '0755',
    require => Exec["mkdir_p_${installdir}"],
  }

  exec { "git clone twig ${installdir}":
    command => 'git clone https://github.com/fabpot/Twig.git',
    cwd     => $installdir,
    creates => "${installdir}/Twig/ext/twig",
    require => File[$installdir],
    timeout => 0,
  }

  exec { "phpize twig ${installdir}":
    command     => '/usr/bin/phpize5',
    cwd         => "${installdir}/Twig/ext/twig",
    creates     => "${installdir}/Twig/ext/twig/configure",
    require     => [ Exec["git clone twig ${installdir}"], Package[$php::params::pecl_dependencies] ],
    timeout     => 0,
    environment => ['SHELL=/bin/bash'],
  }

  exec { "configure twig ${installdir}":
    command     => 'bash configure --enable-twig',
    cwd         => "${installdir}/Twig/ext/twig",
    creates     => "${installdir}/Twig/ext/twig/Makefile",
    require     => Exec["phpize twig ${installdir}"],
    timeout     => 0,
    environment => ['SHELL=/bin/bash'],
  }

  exec { "make make install twig ${installdir}":
    command     => "bash -c 'make -f ${installdir}/Twig/ext/twig/Makefile install'",
    cwd         => "${installdir}/Twig/ext/twig",
    creates     => "${installdir}/Twig/ext/twig/modules/twig.so",
    require     => Exec["configure twig ${installdir}"],
    timeout     => 0,
    environment => ['SHELL=/bin/bash'],
  }

  file { '/etc/php5/mods-available/twig.ini':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "extension=twig.so\n",
    require => Exec["make make install twig ${installdir}"],
  }

  if($enablefile)
  {
    file { $enablefile:
      ensure => 'link',
      target => '/etc/php5/mods-available/twig.ini',
    }
  }
}
