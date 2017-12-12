class php::ioncube(
                    $srcdir  = '/usr/local/src',
                    $basedir = '/opt',
                  ) inherits php::params {
  #
  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if($php::params::phpversion==undef)
  {
    fail('ioncube installation unsupported')
  }

  exec { 'ioncube which wget':
    command => 'which wget',
    unless  => 'which wget',
  }

  exec { "mkdir srcdir ${srcdir}":
    command => "mkdir -p ${srcdir}",
    creates => $srcdir,
  }

  exec { "mkdir basedir ${basedir}":
    command => "mkdir -p ${basedir}",
    creates => $basedir,
  }

  # https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz

  exec { 'wget ioncubeloader':
    command => "wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -O ${srcdir}/ioncube_loaders.tar.gz",
    creates => "${srcdir}/ioncube_loaders.tar.gz",
    require => Exec[ [ 'ioncube which wget', "mkdir srcdir ${srcdir}", "mkdir basedir ${basedir}" ] ],
  }

  exec { 'tar xzf ioncube_loaders':
    command => "tar xzf ${srcdir}/ioncube_loaders.tar.gz -C ${basedir}",
    creates => "${basedir}/ioncube/README.txt",
    require => Exec['wget ioncubeloader'],
  }

  file { "${php::params::confbase}/mods-available/ioncube.ini":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "zend_extension=${basedir}/ioncube/ioncube_loader_lin_${php::params::phpversion}.so\n",
    require => Exec['tar xzf ioncube_loaders'],
  }
}
