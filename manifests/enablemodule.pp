define php::enablemodule (
                            $instance,
                            $modulename=$name,
                            $confbase=$php::params::confbase,
                            $service_notify=undef,
                            $priotity='99',
                          ) {
  if($service_notify!=undef)
  {
    $service_to_notify=Service[$service_notify]
  }
  else
  {
    $service_to_notify=undef
  }

  file { "${confbase}/${instance}/conf.d/${priotity}-${modulename}.ini":
    ensure => "${confbase}/mods-available/${$modulename}.ini",
    force  => true,
    notify => $service_to_notify,
  }
}
