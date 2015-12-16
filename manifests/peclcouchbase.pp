define php::peclcouchbase 	(
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
								release => "${::lsbdistcodename}",
								repos => "${::lsbdistcodename}/main",
							}

							apt::key { 'couchbase':
								key => '407D39EDE72067607FF1DA1CA3FAA648D9223EDA',
								key_source => 'http://packages.couchbase.com/ubuntu/couchbase.key',
							}

						}
						default: { fail("Unsupported Ubuntu version! - $::operatingsystemrelease")  }
					}
				}
				'Debian': { fail("Unsupported")  }
				default: { fail("Unsupported Debian flavour!")  }
			}
		}
		default: { fail("Unsupported OS!")  }
	}

	php::pecl { 'couchbase':
		dependencies => [ $couchbase_dependencies ],
		enablefile => $enablefile,
		require => Exec['apt_update'],
	}
}
