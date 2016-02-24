define php::enablemodule (
                            $instance,
                            $modulename=$name,
                            $confbase=$php::params::confbase,
                            $service_notify=undef,
                            $priotity='99',
                          ) {

  file { "${confbase}/${instance}/conf.d/${priotity}-${modulename}.ini":
    ensure => "${confbase}/mods-available/${$modulename}.ini",
    force  => true,
    notify => $service_notify,
  }
}
