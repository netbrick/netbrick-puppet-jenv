define jenv::local (
	$user		= $title,
	$group		= $user,
	$path,
	$candidate,
	$version,
) {

	if ! defined( File["jenv::local::${path}::${user}"] ) {
		file { "jenv::local::${path}::${user}":
			ensure	=> directory,
			path	=> $path,
			owner	=> $user,
			group	=> $group,
		} 
	}

	if ! defined( File["jenv::local::${path}::jenvrc::${user}"] ) {
		file { "jenv::local::${path}::jenvrc::${user}":
                        ensure  => file,
                        path    => "${path}/.jenvrc",
                        owner   => $user,
                        group   => $group,
                        mode    => 644,
			require	=> File["jenv::local::${path}::${user}"],
                }
	}

	file_line { "jenv::local::${path}::${candidate}::${user}":
                path    => "${path}/.jenvrc",
                line    => "${candidate}=${version}",
                require => File["jenv::local::${path}::jenvrc::${user}"],
        }

}
