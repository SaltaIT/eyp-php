
class { 'apache':
  listen                => [ '80', '443' ],
  ssl                   => true,
  manage_docker_service => true,
}

class { 'apache::mod::php': }

class { 'php::apache': }
