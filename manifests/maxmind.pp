define php::maxmind(
                    $installdir = '/usr/local/src/maxmind',
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

  $maxmind_dependencies= [ 'libmaxminddb0', 'libmaxminddb-dev' ]

  case $::osfamily
  {
    'Debian':
    {
      apt::ppa { 'ppa:maxmind/ppa':
        ensure => 'present',
        before => Package[$maxmind_dependencies],
      }
    }
    default: { fail("Unsupported OS family: ${::osfamily}")}
  }

  package{ $maxmind_dependencies:
      ensure  => 'installed',
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

  exec { "git clone maxmind ${installdir}":
    command => 'git clone https://github.com/maxmind/MaxMind-DB-Reader-php.git',
    cwd     => $installdir,
    creates => "${installdir}/MaxMind-DB-Reader-php/ext/config.m4",
    require => File[$installdir],
    timeout => 0,
  }

  exec { "phpize maxmind ${installdir}":
    command     => '/usr/bin/phpize5',
    cwd         => "${installdir}/MaxMind-DB-Reader-php/ext",
    creates     => "${installdir}/MaxMind-DB-Reader-php/ext/configure",
    require     => [ Exec["git clone maxmind ${installdir}"], Package[ [ $maxmind_dependencies, $php::params::pecl_dependencies ] ] ],
    timeout     => 0,
    environment => ['SHELL=/bin/bash'],
  }

  exec { "configure maxmind ${installdir}":
    command     => 'bash configure --with-maxminddb',
    cwd         => "${installdir}/MaxMind-DB-Reader-php/ext",
    creates     => "${installdir}/MaxMind-DB-Reader-php/ext/Makefile",
    require     => Exec["phpize maxmind ${installdir}"],
    timeout     => 0,
    environment => ['SHELL=/bin/bash'],
  }

  exec { "make make install maxmind ${installdir}":
    command     => "bash -c 'make -f ${installdir}/MaxMind-DB-Reader-php/ext/Makefile install'",
    cwd         => "${installdir}/MaxMind-DB-Reader-php/ext",
    creates     => "${installdir}/MaxMind-DB-Reader-php/ext/modules/maxminddb.so",
    require     => Exec["configure maxmind ${installdir}"],
    timeout     => 0,
    environment => ['SHELL=/bin/bash'],
  }

  file { '/etc/php5/mods-available/maxminddb.ini':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "extension=maxminddb.so\n",
    require => Exec["make make install maxmind ${installdir}"],
  }

  if($enablefile)
  {
    file { $enablefile:
      ensure => link,
      target => '/etc/php5/mods-available/maxminddb.ini',
    }
  }

}
