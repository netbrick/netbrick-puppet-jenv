define jenv::local (
	$user		= $title,
	$group		= $user,
	$path,
	$candidate,
	$version,
) {

	if ! defined( File["jenv::local::${path}::${user}"] ) {
		file { "jenv::local::${path}::${user}":
			ensure	=> present,
			path	=> $path,
			owner	=> $user,
			group	=> $group,
			mode	=> 644,
		} 
	}

	file_line { "jenv::local::${path}::${candidate}::${user}":
                path    => "${path}/.jenvrc",
                line    => "${candidate}=${version}",
                require => File["jenv::local::${path}::${user}"],
        }

}
