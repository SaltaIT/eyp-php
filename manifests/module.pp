define php::module(
                    $modulename=$name,
                    $enablefile=undef,
                    $ensure='installed', #TODO
                  ) {

  if($modulename=='php5-phalcon')
  {
    case $::osfamily
    {
      'Debian':
      {
        $packagedependency=Apt::Ppa['ppa:phalcon/stable']
      }
      default: { fail("php5-phalcon unsupported on ${::osfamily}")}
    }
  }

  package { $modulename:
    ensure  => 'installed',
    require => $packagedependency,
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
