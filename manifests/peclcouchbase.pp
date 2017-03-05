define php::peclcouchbase   (
        $enablefile=undef,
      ) {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  #TODO: integrar amb pecl generic

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
              $couchbase_dependencies= [ 'libcouchbase2-bin', 'libcouchbase2-core', 'libcouchbase2-libev', 'libcouchbase2-libevent', 'libcouchbase-dev' ]

              apt::source { 'couchbase':
                location => 'http://packages.couchbase.com/ubuntu',
                release  => $::lsbdistcodename,
                repos    => "${::lsbdistcodename}/main",
              }

              apt::key { 'couchbase':
                key        => '136CD3BA884E3CB0E44E7A5BE905C770CD406E62',
                key_source => 'http://packages.couchbase.com/ubuntu/couchbase.key',
              }

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

  php::pecl { 'couchbase':
    dependencies => [ $couchbase_dependencies ],
    enablefile   => $enablefile,
    require      => Exec['apt_update'],
  }
}
