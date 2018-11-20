class php::fpm (
                  $confbase                   = $php::params::confbase_fpm,
                  #PHP
                  $php_loglevel               = 'notice',
                  $fpm_loglevel               = 'notice',
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
                  $error_log                  = $php::params::fpm_error_log_default,
                  $session_save_path          = $php::params::session_save_path_default,
                  $session_gc_probability     = '0',
                  $use_php_package_prefix_ius = undef,
                  $magic_quotes_gpc           = undef,
                  $magic_quotes_runtime       = undef,
                  $magic_quotes_sybase        = undef,
                  #FPM
                  $process_max                = '0',
                  $process_priority           = '-19',
                  $pidfile                    = $php::params::fpm_pid,
                ) inherits php::params {

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
