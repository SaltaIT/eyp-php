# == Class: php
#
class php(
          $phpcli                     = true,
          $confbase                   = $php::params::confbase_cli,
          # PHP
          $php_loglevel               = $php::params::php_loglevel_default,
          $user                       = $php::params::user,
          $group                      = $php::params::group,
          $exposephp                  = $php::params::exposephp_default,
          $maxexecutiontime           = $php::params::maxexecutiontime_default,
          $memorylimit                = $php::params::memorylimit_default,
          $maxupload                  = $php::params::maxupload_default,
          $maxpostsize                = $php::params::maxpostsize_default,
          $timezone                   = $php::params::timezone_default,
          $allowurlfopen              = $php::params::allowurlfopen_default,
          $allowurlinclude            = $php::params::allowurlinclude_default,
          $customini                  = $php::params::customini_default,
          $max_input_vars             = $php::params::max_input_vars_default,
          $short_open_tag             = $php::params::short_open_tag_default,
          $serialize_precision        = $php::params::serialize_precision_default,
          $max_input_time             = $php::params::max_input_time_default,
          $errorlog                   = $php::params::apache_errorlog_default,
          $session_save_path          = $php::params::session_save_path_default,
          $session_gc_probability     = $php::params::session_gc_probability_default,
          $use_php_package_prefix_ius = undef,
          $magic_quotes_gpc           = undef,
          $magic_quotes_runtime       = undef,
          $magic_quotes_sybase        = undef,
        ) inherits php::params{

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

  validate_re($php_loglevel, [ '^alert$', '^error$', '^warning$', '^notice$', '^debug$' ], "Not a valid loglevel:     ${php_loglevel}")

  if($use_php_package_prefix_ius!=undef)
  {
    include ::ius
  }

  if($use_php_package_prefix_ius==undef)
  {
    $actual_phpdependencies=$php::params::phpdependencies
  }
  else
  {
    $actual_phpdependencies = regsubst($php::params::phpdependencies, '^php[0-9.]*', $use_php_package_prefix_ius)

    Package[$actual_phpdependencies] {
      require => Class['::ius'],
    }
  }

  package { $actual_phpdependencies:
    ensure => 'installed',
  }

  if($phpcli)
  {
    if($use_php_package_prefix_ius==undef)
    {
      $actual_phpcli=$php::params::phpcli
    }
    else
    {
      $actual_phpcli = regsubst($php::params::phpcli, '^php[0-9.]*', $use_php_package_prefix_ius)
    }

    package { $actual_phpcli:
      ensure  => 'installed',
      require => Package[$actual_phpdependencies],
    }

    if($customini!=undef)
    {
      file { "${confbase}/php.ini":
        ensure  => $customini,
        force   => true,
        require => Package[$actual_phpcli],
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
        require => Package[$actual_phpcli],
      }
    }
  }
}
