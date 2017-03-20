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

  include ::php::mysqlnd

  php::pecl { 'mysqlnd_ms':
    manage_ini => false,
  }

  file { "${php::params::confbase}/mods-available/mysqlnd_ms.ini":
    ensure  => 'absent',
    require => Php::Pecl['mysqlnd_ms'],
  }

  concat { "${php::params::confbase}/mysqlndms.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Php::Pecl['mysqlnd_ms'],
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
