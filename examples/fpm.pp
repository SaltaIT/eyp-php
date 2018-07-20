class { 'php::fpm': }

php::fpm::pool { 'librenms':
  socketmode => '0666',
}
