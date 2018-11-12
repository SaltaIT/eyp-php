class php::apache (
                    $instancename           = $name,
                    $confbase               = $php::params::confbase_apache,
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
                    $customini              = $php::params::customini_default,
                    $max_input_vars         = $php::params::max_input_vars_default,
                    $short_open_tag         = $php::params::short_open_tag_default,
                    $serialize_precision    = $php::params::serialize_precision_default,
                    $max_input_time         = $php::params::max_input_time_default,
                    $errorlog               = $php::params::apache_errorlog_default,
                    $session_save_path      = $php::params::session_save_path_default,
                    $session_gc_probability = $php::params::session_gc_probability_default,
                  ) inherits php::params{

  if($customini)
  {
    file { "${confbase}/php.ini":
      ensure => $customini,
      force  => true,
      notify => Class['apache::service'],
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
      notify  => Class['apache::service'],
      }
  }
}
