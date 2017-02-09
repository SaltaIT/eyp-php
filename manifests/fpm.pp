define php::fpm (
                  $instancename           = $name,
                  $confbase               = $php::params::confbase_fpm,
                  #PHP
                  $php_loglevel           = $php::params::php_loglevel_default,
                  $user                   = $php::params::user_default,
                  $group                  = $php::params::group_default,
                  $exposephp              = $php::params::exposephp_default,
                  $maxexecutiontime       = $php::params::maxexecutiontime_default,
                  $memorylimit            = $php::params::memorylimit_default,
                  $maxupload              = $php::params::maxupload_default,
                  $maxpostsize            = $php::params::maxpostsize_default,
                  $timezone               = $php::params::timezone_default,
                  $allowurlfopen          = $php::params::allowurlfopen_default,
                  $allowurlinclude        = $php::params::allowurlinclude_default,
                  $customini              = undef,
                  $max_input_vars         = $php::params::max_input_vars_default,
                  $short_open_tag         = $php::params::short_open_tag_default,
                  $serialize_precision    = $php::params::serialize_precision_default,
                  $max_input_time         = $php::params::max_input_time_default,
                  $errorlog               = $php::params::fpm_error_log_default,
                  $session_save_path      = $php::params::session_save_path_default,
                  $session_gc_probability = $php::params::session_gc_probability_default,
                  #FPM
                  $processmax             = $php::params::processmax_default,
                  $processpriority        = $php::params::processpriority_default,
                ) {

  validate_string($max_input_vars)
  validate_string($short_open_tag)
  validate_string($serialize_precision)
  validate_string($max_input_time)
  validate_string($session_save_path)
  validate_string($session_gc_probability)

  validate_absolute_path($confbase)
  validate_absolute_path($errorlog)

  validate_re($exposephp, '^O(n|ff)$', 'Not a valid option')
  validate_re($allowurlfopen, '^O(n|ff)$', 'Not a valid option')
  validate_re($allowurlinclude, '^O(n|ff)$', 'Not a valid option')

  validate_re($php_loglevel, [ '^alert$', '^error$', '^warning$', '^notice$', '^debug$' ], "Not a valid loglevel: ${php_loglevel}")

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
    content => template('php/phpfpmconf.erb'),
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
      content => template('php/phpini.erb'),
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
