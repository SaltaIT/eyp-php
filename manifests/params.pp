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
  $customini_default=undef

  $processmax_default='0'
  $processpriority_default='-19'

  case $::osfamily
  {
    'redhat':
    {
      case $::operatingsystemrelease
      {
        /^7.*$/:
        {
          # [root@centos7 opt]# rpm -ql php-fpm
          # /etc/logrotate.d/php-fpm
          # /etc/php-fpm.conf
          # /etc/php-fpm.d
          # /etc/php-fpm.d/www.conf
          # /etc/sysconfig/php-fpm
          # /run/php-fpm
          # /usr/lib/systemd/system/php-fpm.service
          # /usr/lib/tmpfiles.d/php-fpm.conf
          # /usr/sbin/php-fpm
          # /usr/share/doc/php-fpm-5.4.16
          # /usr/share/doc/php-fpm-5.4.16/fpm_LICENSE
          # /usr/share/doc/php-fpm-5.4.16/php-fpm.conf.default
          # /usr/share/fpm
          # /usr/share/fpm/status.html
          # /usr/share/man/man8/php-fpm.8.gz
          # /var/log/php-fpm
          # [root@centos7 opt]#
          $phpdependencies=[ 'php-common' ]
          $phpfpmpackage=[ 'php-fpm' ]
          $phpcli=[ 'php-cli' ]
          $user='apache'
          $group='apache'
          $confbase='/etc'
          $confbase_cli='/etc'
          $confbase_fpm='/etc'
          $phpini_fpm = 'php-fpm.ini'
          $fpm_pooldir = 'php-fpm.d'
          $pecl_dependencies=['php-devel']

          $fpm_error_log_default='/var/log/php-fpm.log'
          $apache_errorlog_default='/var/log/php-apache.log'

          $session_save_path_default='/var/lib/php/session/'

          $phpversion=undef

          $fpm_service_name = 'php-fpm'

          $fpm_pid='/run/php-fpm/php-fpm.pid'

          $custom_systemd=true

          $fpm_includedir = '/etc/php.d'
        }
        default: { fail('Unsupported RHEL/CentOS version!')  }
      }
    }
    'Debian':
    {
      $fpm_pooldir = 'pool.d'

      case $::operatingsystem
      {
        'Ubuntu':
        {
          $fpm_service_name = 'php5-fpm'

          $fpm_pid='/var/run/php5-fpm.pid'

          $custom_systemd=false

          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $phpdependencies=[ 'php-pear', 'php-http' ]
              $phpfpmpackage=[ 'php5-fpm', 'libfcgi0ldbl' ]
              $phpcli=[ 'php5-cli' ]
              $user='www-data'
              $group='www-data'
              $confbase='/etc/php5/'
              $confbase_cli='/etc/php5/cli'
              $confbase_fpm='/etc/php5/fpm'
              $phpini_fpm = 'php.ini'
              $confbase_apache='/etc/php5/apache2'
              $pecl_dependencies=['php5-dev']

              $fpm_error_log_default='/var/log/php5-fpm.log'
              $apache_errorlog_default='/var/log/php5-apache.log'

              $session_save_path_default='/var/lib/php5'

              $phpversion=undef

              $fpm_includedir = undef
            }
            /^16.*$/:
            {
              $phpdependencies=[ 'php-pear', 'php-http' ]
              $phpfpmpackage=[ 'php-fpm', 'libfcgi0ldbl' ]
              $phpcli=[ 'php7.0-cli' ]
              $user='www-data'
              $group='www-data'
              $confbase='/etc/php/7.0'
              $confbase_cli='/etc/php/7.0/cli'
              $confbase_fpm='/etc/php/7.0/fpm'
              $phpini_fpm = 'php.ini'
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
