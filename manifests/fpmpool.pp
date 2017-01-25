define php::fpmpool(
                      $poolname             = $name,
                      $confbase             = '/etc/php5/fpm',
                      $user                 = $php::params::user,
                      $group                = $php::params::group,
                      $listen               = '/var/run/php5-fpm.sock',
                      $socketmode           = '0660',
                      $allowedclients       = undef,
                      $phpstatus            = '/php-status',
                      $pingpath             = '/ping',
                      $pingresponse         = 'pong',
                      $processpriority      = '-19',
                      $extensions           = [ 'php' ],
                      $catch_workers_output = false,
                      $maxchildren          = 50,
                      $maxrequestsperchild  = 1000,
                      $pm                   = 'dynamic',
                      $minspareservers      = 5,
                      $maxspareservers      = 10,
                      $env                  = undef,
                      $monitscripts         = true,
                      $monitscriptsbase     = '/usr/local/bin',
                    ) {
  validate_absolute_path($confbase)

  if($pingpath)
  {
    validate_string($pingpath)
    validate_string($pingresponse)
  }

  validate_integer($processpriority, 20, -19)

  validate_array($extensions)

  validate_integer($maxchildren, undef, 0)
  validate_integer($maxrequestsperchild, undef, 0)

  validate_re($pm, [ '^dynamic$', '^static$', '^ondemand$' ], "Not a valid PM: ${pm}")

  if($pm=='dynamic')
  {
    validate_integer($minspareservers, undef, 1)
    validate_integer($maxspareservers, undef, 1)
  }

  file { "${confbase}/pool.d/${poolname}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/fpmpoolconf.erb"),
    notify  => Service['php5-fpm'],
    require => Package[$php::params::phpfpmpackage],
  }

  if ($monitscripts)
  {
    file { "${monitscriptsbase}/check_phpfpm_procs":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template("${module_name}/checks/check_phpfpm_procusage.erb"),
    }

    file { "${monitscriptsbase}/check_phpfpm_running_workers":
      ensure => 'present',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      source => "puppet:///modules/${module_name}/check_phpfpm_running_workers.sh",
    }

  }

}
