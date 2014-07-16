define jenv::use (
	$user		= $title,
	$group		= $user,
	$home		= '',
	$candidate,
	$version,
) {
	$home_path	= $home ? { '' => "/home/${user}", default => $home }

	if ! defined( Jenv::Candidate["jenv::${candidate}::${version}::install ${user}"] ) {
		debug( "Candidate ${candidate} ${version} is not installed" )
		debug( "Installing candidate ${candidate} ${version}..." )

		jenv::candidate { "${candidate}::${version}::${user}":
			user		=> $user,
			home		=> $home_path,
			candidate	=> $candidate,
			version		=> $version,
		} 
	}

	exec { "jenv::use::${candidate}::${version} ${user}":
		command		=> "bash --login -c 'jenv use ${candidate} ${version}'",
		user		=> $user,
		group		=> $group,
		environment 	=> [ "HOME=${home_path}" ],
		path 		=> ['/bin', '/usr/bin', '/usr/sbin'],
		timeout 	=> 100,
		cwd 		=> $home_path,
		require		=> Exec["jenv::${candidate}::${version}::install ${user}"],
	}
}
