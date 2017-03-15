class php::ioncube(
                    $srcdir = '/usr/local/src',
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
    unless => 'which wget',
  }

  exec { "mkdir srcdir ${srcdir}":
    command => "mkdir -p ${srcdir}",
    creates => $srcdir,
  }

  # https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz

  exec { 'wget ioncubeloader':
    command => "wget https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz -O ${srcdir}/ioncube_loaders.tar.gz",
    creates => "${srcdir}/ioncube_loaders.tar.gz",
    require => Exec[ [ 'ioncube which wget', "mkdir srcdir ${srcdir}" ] ],
  }

  exec { 'tar xzf ioncube_loaders':
    command => "tar xzf ${srcdir}/ioncube_loaders.tar.gz -C ${srcdir}",
    creates => "${srcdir}/ioncube/README.txt",
    require => Exec['wget ioncubeloader'],
  }
}
