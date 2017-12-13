class php::mysqlnd() inherits php::params {

  concat { "${php::params::confbase}/mods-available/mysqlnd.ini":
    ensure => 'present',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # if concat fails for some reason, don't delete the default file
  file { "${php::params::confbase}/mods-available/10-mysqlnd.ini":
    ensure  => 'absent',
    require => Concat["${php::params::confbase}/mods-available/mysqlnd.ini"],
  }

  concat::fragment{ "${php::params::confbase}/mods-available/mysqlnd ini":
    target  => "${php::params::confbase}/mods-available/mysqlnd.ini",
    order   => '01',
    content => template("${module_name}/mysqlnd/mysqlndini.erb"),
  }

  concat::fragment{ "${php::params::confbase}/mods-available/mysqlnd MS":
    target  => "${php::params::confbase}/mods-available/mysqlnd.ini",
    order   => '10',
    content => template("${module_name}/mysqlnd/ms.erb"),
  }
}
