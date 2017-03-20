class php::params () {

  #PHP
  $php_loglevel_default='notice'
  $exposephp_default='Off'
  $maxexecutiontime_default='5'
  $memorylimit_default='10M'
  $maxupload_default='100M'
  $maxpostsize_default='100M'
  $timezone_default='Europe/Andorra'
  $allowurlfopen_default='Off'
  $allowurlinclude_default='Off'
  $max_input_vars_default='1000'
  $short_open_tag_default='Off'
  $serialize_precision_default='17'
  $max_input_time_default='60'
  $session_gc_probability_default='0'

  $processmax_default='0'
  $processpriority_default='-19'

  case $::osfamily
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

      $fpm_error_log_default='/var/log/php5-fpm.log'
      $apache_errorlog_default='/var/log/php5-apache.log'

      $session_save_path_default='/var/lib/php5'

      case $::operatingsystemrelease
      {
        /^[5-7].*$/:
        {
          $phpversion=undef
        }
        default: { fail('Unsupported RHEL/CentOS version!')  }
      }
    }
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
              $phpdependencies=['php-pear', 'php-http']
              $phpfpmpackage=[ 'php5-fpm', 'libfcgi0ldbl' ]
              $phpcli=[ 'php5-cli' ]
              $user='www-data'
              $group='www-data'
              $confbase='/etc/php5/'
              $confbase_cli='/etc/php5/cli'
              $confbase_fpm='/etc/php5/fpm'
              $confbase_apache='/etc/php5/apache2'
              $pecl_dependencies=['php5-dev']

              $fpm_error_log_default='/var/log/php5-fpm.log'
              $apache_errorlog_default='/var/log/php5-apache.log'

              $session_save_path_default='/var/lib/php5'

              $phpversion=undef
            }
            /^16.*$/:
            {
              $phpdependencies=['php-pear', 'php-http']
              $phpfpmpackage=[ 'php-fpm', 'libfcgi0ldbl' ]
              $phpcli=[ 'php7.0-cli' ]
              $user='www-data'
              $group='www-data'
              $confbase='/etc/php/7.0'
              $confbase_cli='/etc/php/7.0/cli'
              $confbase_fpm='/etc/php/7.0/fpm'
              $confbase_apache='/etc/php/7.0/apache2'
              $pecl_dependencies=['php7.0-dev']

              $fpm_error_log_default='/var/log/php7-fpm.log'
              $apache_errorlog_default='/var/log/php7-apache.log'

              $session_save_path_default='/var/lib/php/sessions'

              $phpversion = '7.0'
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
