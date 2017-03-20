#
# concat mysqlndms.conf
#
# 00 base
# 10 datasources
# 99 end
class php::mysqlnd_ms(
                        $priority         = '10',
                        $lazy_connections = true,
                        $master_on_write  = true,
                      ) inherits php::params {

  # concat en preivisio
  concat { "${php::params::confbase}/mods-available/${priority}-mysqlnd.ini":
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  concat::fragment{ "${php::params::confbase}/mods-available/${priority}-mysqlnd ini":
    target  => "${php::params::confbase}/mods-available/${priority}-mysqlnd.ini",
    order   => '01',
    content => template("${module_name}/mysqlnd/mysqlndini.erb"),
  }

  concat::fragment{ "${php::params::confbase}/mods-available/${priority}-mysqlnd MS":
    target  => "${php::params::confbase}/mods-available/${priority}-mysqlnd.ini",
    order   => '10',
    content => template("${module_name}/mysqlnd/ms.erb"),
  }

  concat { "${php::params::confbase}/mysqlndms.conf":
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  concat::fragment{ "${php::params::confbase}/mysqlndms.conf nd_ms base":
    target  => "${php::params::confbase}/mysqlndms.conf",
    order   => '00',
    content => "{\n",
  }

  concat::fragment{ "${php::params::confbase}/mysqlndms.conf nd_ms end":
    target  => "${php::params::confbase}/mysqlndms.conf",
    order   => '99',
    content => template("${module_name}/mysqlnd/ms/end.erb")
  }


}
