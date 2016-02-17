class php::params () {

  case $::osfamily
  {
    'Debian':
    {
      case $::operatingsystem
      {
        'redhat':
        {
          #TODO: definir valors per centos
          $phpdependencies=['php']
          $phpfpmpackage=[ 'php-fpm' ]
          $phpcli=[ 'php-cli' ]
          $user='apache'
          $group='apache'
          $confbase='/etc/php5/'
          $confbase_cli='/etc/php5/cli'
          $confbase_fpm='/etc/php5/fpm'
          $pecl_dependencies=['php5-dev']

          case $::operatingsystemrelease
          {
            /^[5-7].*$/:
            {
            }
            default: { fail('Unsupported RHEL/CentOS version!')  }
          }
        }
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $phpdependencies=['php-pear']
              $phpfpmpackage=[ 'php5-fpm', 'libfcgi0ldbl' ]
              $phpcli=[ 'php5-cli' ]
              $user='www-data'
              $group='www-data'
              $confbase='/etc/php5/'
              $confbase_cli='/etc/php5/cli'
              $confbase_fpm='/etc/php5/fpm'
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
