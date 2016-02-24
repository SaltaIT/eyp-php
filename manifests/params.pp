class php::params () {

        $phpapache_default=false

  case $::osfamily
  {
    'Debian':
    {
      case $::operatingsystem
      {
      'Ubuntu':
      {
      case $::operatingsystemrelease
      {
        /^14.*$/:
        {
          $phpdependencies=['php-pear']
          $phpfpmpackage=[ 'php5-fpm', 'libfcgi0ldbl' ]
          $phpcli=[ 'php5-cli' ]
          $phpapachepackage=[ 'libapache2-mod-php5' ]
          $user='www-data'
          $group='www-data'
          $confbase='/etc/php5/'
          $confbase_cli='/etc/php5/cli'
          $confbase_fpm='/etc/php5/fpm'
          $confbase_apache='/etc/php5/apache2'
          $pecl_dependencies=['php5-dev']
        }
        default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
      }
      }
      'Debian': { fail('Unsupported')  }
      default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }

}
