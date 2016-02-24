class php::apache (
  $instancename=$name,
  $confbase=$php::params::confbase_apache,
  $errorlog='/var/log/php5-apache.log',
  $php_loglevel='notice',
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
  ) inherits params{

  if defined(Class['ntteam'])
  {
    ntteam::tag{ 'php::apache': }
  }

  validate_absolute_path($confbase)
  validate_absolute_path($errorlog)

  validate_re($exposephp, '^O(n|ff)$', 'Not a valid option')
  validate_re($allowurlfopen, '^O(n|ff)$', 'Not a valid option')
  validate_re($allowurlinclude, '^O(n|ff)$', 'Not a valid option')

  validate_re($php_loglevel, [ '^alert$', '^error$', '^warning$', '^notice$', '^debug$' ], "Not a valid loglevel: ${php_loglevel}")

  if defined(Class['ntteam'])
  {
    ntteam::tag{ 'phpapache': }
  }

  package { $php::params::phpapachepackage:
    ensure => 'installed',
  }

  if($customini)
  {
    file { "${confbase}/php.ini":
      ensure => $customini,
      force  => true,
      notify => Service['apache2'],
    }
  }
  else
  {
    file { "${confbase}/php.ini":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('php/phpini.erb'),
      notify  => Service['apache2'],
      require => Package[$php::params::phpapachepackage],
      }
  }
}
