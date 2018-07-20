class php::fpm (
                  $confbase               = $php::params::confbase_fpm,
                  #PHP
                  $php_loglevel           = $php::params::php_loglevel_default,
                  $fpm_loglevel           = 'notice',
                  $user                   = $php::params::user,
                  $group                  = $php::params::group,
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
                  $pidfile                = $php::params::fpm_pid,
                ) inherits php::params {

  include ::php

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

  include ::php

  if($php::use_php_package_prefix_ius==undef)
  {
    $actual_phpfpmpackage=$php::params::phpfpmpackage
  }
  else
  {
    $actual_phpfpmpackage = regsubst($php::params::phpfpmpackage, '^php[0-9.]*', $php::use_php_package_prefix_ius)
  }

  package { $actual_phpfpmpackage:
    ensure  => 'installed',
    require => Class['::php'],
  }

  file { "${confbase}/php-fpm.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/phpfpmconf.erb"),
    notify  => Service[$php::params::fpm_service_name],
    require => Package[$actual_phpfpmpackage],
  }

  if($customini!=undef)
  {
    file { "${confbase}/${php::params::phpini_fpm}":
      ensure => $customini,
      force  => true,
      notify => Service[$php::params::fpm_service_name],
    }
  }
  else
  {
    file { "${confbase}/${php::params::phpini_fpm}":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/phpini.erb"),
      notify  => Service[$php::params::fpm_service_name],
      require => Package[$actual_phpfpmpackage],
    }
  }

  file { "${php::params::confbase_fpm}/${php::params::fpm_pooldir}":
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => true,
    purge   => true,
  }

  # [root@centos7 etc]# cat /usr/lib/systemd/system/php-fpm.service
  # [Unit]
  # Description=The PHP FastCGI Process Manager
  # After=syslog.target network.target
  #
  # [Service]
  # Type=notify
  # PIDFile=/run/php-fpm/php-fpm.pid
  # EnvironmentFile=/etc/sysconfig/php-fpm
  # ExecStart=/usr/sbin/php-fpm --nodaemonize
  # ExecReload=/bin/kill -USR2 $MAINPID
  # PrivateTmp=true
  #
  # [Install]
  # WantedBy=multi-user.target
  if($php::params::custom_systemd)
  {

    # Type=notify
    # PIDFile=/run/php-fpm/php-fpm.pid
    # ExecStart=/usr/sbin/php-fpm --nodaemonize
    # ExecReload=/bin/kill -USR2 $MAINPID
    # PrivateTmp=true

    systemd::service { $php::params::fpm_service_name:
      description       => 'The PHP FastCGI Process Manager',
      after_units       => [ 'syslog.target network.target' ],
      type              => 'notify',
      environment_files => [ '-/etc/sysconfig/php-fpm' ],
      execstart         => "/usr/sbin/php-fpm --nodaemonize -c ${confbase}/${php::params::phpini_fpm}",
      execreload        => '/bin/kill -USR2 $MAINPID',
      private_tmp       => true,
      restart_sec       => '2',
      pid_file          => '/run/php-fpm/php-fpm.pid',
    }
  }

  service { $php::params::fpm_service_name:
    ensure  => 'running',
    enable  => true,
    require => [ Class['::systemd'], File[ [ "${confbase}/php-fpm.conf", "${confbase}/${php::params::phpini_fpm}" ] ] ],
  }
}
