define php::enablemodule (
                            $instance,
                            $ensure         = 'link',
                            $modulename     = $name,
                            $confbase       = $php::params::confbase,
                            $service_notify = undef,
                            $priority       = '99',
                          ) {
  if($service_notify!=undef)
  {
    $service_to_notify=Service[$service_notify]
  }
  else
  {
    $service_to_notify=undef
  }

  file { "${confbase}/${instance}/conf.d/${priority}-${modulename}.ini":
    ensure => $ensure,
    target => "${confbase}/mods-available/${$modulename}.ini",
    force  => true,
    notify => $service_to_notify,
  }
}
