#
# concat datasoource
#
# 00 datasource begin
# 01 master begin
# 02 - master list
# 03 master end
# 04 slave begin
# 05 - slave list
# 06 slave end
#

#
#     "ndtest": {
#         "master": {
#             "master0": {
#                 "host": "localhost",
#                 "socket": "/var/lib/mysql/mysql.sock"
#             }
#         },
#         "slave": {
#             "slave0": {
#                 "host": "192.168.56.103",
#                 "port": "3306"
#               },
#         "slave1": {
#                 "host": "192.168.56.103",
#                 "port": "3307"
#               }
#         }
#     },

define php::mysqlnd_ms::datasource(
                                    $datasource_name = $name,
                                  ) {

  include ::php::mysqlnd_ms

  concat::fragment{ "${php::params::confbase}/mysqlndms.conf nd_ms datasource ${datasource_name}":
    target  => "${php::params::confbase}/mysqlndms.conf",
    order   => "10-${datasource_name}-00",
    content => template("${module_name}/mysqlnd/ms/datasource.erb")
  }

  concat::fragment{ "${php::params::confbase}/mysqlndms.conf nd_ms master begin ${datasource_name}":
    target  => "${php::params::confbase}/mysqlndms.conf",
    order   => "10-${datasource_name}-01",
    content => "    \"master\": {\n",
  }

  concat::fragment{ "${php::params::confbase}/mysqlndms.conf nd_ms master end ${datasource_name}":
    target  => "${php::params::confbase}/mysqlndms.conf",
    order   => "10-${datasource_name}-03",
    content => "    },\n",
  }

  concat::fragment{ "${php::params::confbase}/mysqlndms.conf nd_ms slave begin ${datasource_name}":
    target  => "${php::params::confbase}/mysqlndms.conf",
    order   => "10-${datasource_name}-04",
    content => "    \"slave\": {\n",
  }

  concat::fragment{ "${php::params::confbase}/mysqlndms.conf nd_ms slave end ${datasource_name}":
    target  => "${php::params::confbase}/mysqlndms.conf",
    order   => "10-${datasource_name}-06",
    content => "    },\n",
  }

}
