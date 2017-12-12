define php::fpm::pool(
                      $poolname             = $name,
                      $confbase             = $php::params::confbase_fpm,
                      $fpm_pooldir          = $php::params::fpm_pooldir,
                      $user                 = $php::params::user,
                      $group                = $php::params::group,
                      $listen               = "/var/run/php-fpm.${name}.sock",
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
  include ::php::fpm

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

  if($php::use_php_package_prefix_ius==undef)
  {
    $actual_phpfpmpackage=$php::params::phpfpmpackage
  }
  else
  {
    $actual_phpfpmpackage = regsubst($php::params::phpfpmpackage, '^php[0-9.]*', $php::use_php_package_prefix_ius)
  }

  file { "${confbase}/${fpm_pooldir}/${poolname}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("${module_name}/fpmpoolconf.erb"),
    notify  => Service[$php::params::fpm_service_name],
    require => Package[$actual_phpfpmpackage],
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
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => file("${module_name}/check_phpfpm_running_workers.sh"),
      #source => "puppet:///modules/${module_name}/check_phpfpm_running_workers.sh",
    }

  }

}
