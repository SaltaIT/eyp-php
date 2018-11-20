# == Class: php
#
class php(
          $phpcli                     = true,
          $confbase                   = $php::params::confbase_cli,
          # PHP
          $php_loglevel               = 'notice',
          $user                       = $php::params::user,
          $group                      = $php::params::group,
          $expose_php                 = false,
          $max_execution_time         = '5',
          $memory_limit               = '10M',
          $upload_max_filesize        = '100M',
          $post_max_size              = '110M',
          $timezone                   = 'Europe/Andorra',
          $allow_url_fopen            = false,
          $allow_url_include          = false,
          $customini                  = undef,
          $max_input_vars             = '1000',
          $short_open_tag             = false,
          $serialize_precision        = '17',
          $max_input_time             = '60',
          $error_log                  = $php::params::apache_errorlog_default,
          $session_save_path          = $php::params::session_save_path_default,
          $session_gc_probability     = '0',
          $use_php_package_prefix_ius = undef,
          $magic_quotes_gpc           = undef,
          $magic_quotes_runtime       = undef,
          $magic_quotes_sybase        = undef,
        ) inherits php::params{

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
