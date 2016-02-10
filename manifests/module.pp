define php::module   (
        $modulename=$name,
        $enablefile=undef,
        $ensure='installed', #TODO
      ) {

  if defined(Class['ntteam'])
  {
    ntteam::tag{ "php::module::${modulename}": }
  }

  if($modulename=="php5-phalcon")
  {
    case $::osfamily
    {
      'Debian':
      {
        $packagedependency=Apt::Ppa['ppa:phalcon/stable']
      }
    }
  }

  package { $modulename:
    ensure => 'installed',
    require => $packagedependency,
  }

  if($enablefile)
  {
    if $modulename =~ /^php[0-9]*-(.*)/
    {
      file { $enablefile:
        ensure => "/etc/php5/mods-available/$1.ini",
      }
    }
  }
}
