define php::mysqlnd_ms::slave(
                                $datasource_name,
                                $host_name = $name,
                                $host      = $name,
                                $port      = '3306',
                                $socket    = undef,
                              ) {
  concat::fragment{ "${php::params::confbase}/mysqlndms.conf nd_ms slave ${host_name} ${datasource_name}":
    target  => "${php::params::confbase}/mysqlndms.conf",
    order   => "10-${datasource_name}-05",
    content => template("${module_name}/mysqlnd/ms/host.erb")
  }
}
