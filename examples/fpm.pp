class { 'php::fpm': }

php::fpm::pool { 'librenms':
  user       => $librenms::username,
  group      => $librenms::username,
  socketmode => '0666',
}
