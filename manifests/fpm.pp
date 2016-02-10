define php::fpm (
      $instancename=$name,
      $confbase=$php::params::confbase_fpm,
      $errorlog='/var/log/php5-fpm.log',
      $loglevel='notice',
      $processmax=0,
      $processpriority=-19,
      $user=$php::params::user,
      $group=$php::params::group,
      $exposephp='Off',
      $maxexecutiontime='5',
      $memorylimit='10M',
      $maxupload='100M',
      $maxpostsize='100M',
      $timezone='Europe/Andorra',
      $allowurlfopen='Off',
      $allowurlinclude='Off',
      $customini=undef,
    ) {

  if defined(Class['ntteam'])
  {
    ntteam::tag{ 'php::fpm': }
  }

  validate_absolute_path($confbase)
  validate_absolute_path($errorlog)

  validate_re($exposephp, '^O(n|ff)$', 'Not a valid option')
  validate_re($allowurlfopen, '^O(n|ff)$', 'Not a valid option')
  validate_re($allowurlinclude, '^O(n|ff)$', 'Not a valid option')

  validate_re($loglevel, [ '^alert$', '^error$', '^warning$', '^notice$', '^debug$' ], "Not a valid loglevel: ${loglevel}")

  validate_integer($processmax, 0)
  validate_integer($processpriority, 20, -19)

  if defined(Class['ntteam'])
  {
    ntteam::tag{ 'phpfpm': }
  }

  package { $php::params::phpfpmpackage:
    ensure => 'installed',
  }

  file { "${confbase}/php-fpm.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/phpfpmconf.erb"),
    notify  => Service['php5-fpm'],
    require => Package[$php::params::phpfpmpackage],
  }

  if($customini)
  {
    file { "${confbase}/php.ini":
      ensure => $customini,
      force  => true,
      notify => Service['php5-fpm'],
    }
  }
  else
  {
    file { "${confbase}/php.ini":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/phpini.erb"),
      notify  => Service['php5-fpm'],
      require => Package[$php::params::phpfpmpackage],
    }
  }

  #TODO:rewrite for multiple daemon
  service {'php5-fpm':
    ensure  => 'running',
    enable  => true,
    require => File[ [ "${confbase}/php-fpm.conf", "${confbase}/php.ini" ] ],
  }
}
