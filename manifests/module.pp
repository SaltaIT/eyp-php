define php::module(
                    $modulename = $name,
                    $enablefile = undef,
                    $ensure     = 'installed', #TODO
                  ) {

  if($modulename=='php5-phalcon')
  {
    case $::osfamily
    {
      'Debian':
      {
        include ::apt

        apt::ppa { 'ppa:phalcon/stable':
          ensure => 'present',
          before => Package[$modulename],
        }
      }
      default: { fail("php5-phalcon unsupported on ${::osfamily}")}
    }
  }

  if($php::use_php_package_prefix_ius==undef)
  {
    $actual_modulename=$modulename
  }
  else
  {
    $actual_modulename = regsubst($modulename, '^php[0-9.]*', $php::use_php_package_prefix_ius)
  }

  package { $actual_modulename:
    ensure  => 'installed',
  }

  if($enablefile)
  {
    if $modulename =~ /^php[0-9]*-(.*)/
    {
      file { $enablefile:
        ensure => link,
        target => "/etc/php5/mods-available/${1}.ini",
      }
    }
  }
}
