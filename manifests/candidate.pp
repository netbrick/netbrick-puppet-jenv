define jenv::candidate (
	$user,
	$candidate	= $title,
	$version,
	$group		= $user,
	$home		= '',
	$command	= '',
	$source		= '',
	$set_default	= true,
) {
	$home_path	= $home ? { '' => "/home/${user}", default => $home }
	$do		= $command ? { '' => 'install', default => $command }

	$default	= $set_default ? { true => 'Y', default => 'N' }

	if ! defined( Jenv::Install[$user] ) {
		debug( "Jenv is not installed for ${user}" )
		debug( "Installing jenv for ${user}..." )

		jenv::install { $user:
			home	=> $home_path,
		}
	}

	exec { "jenv::${candidate}::${do} ${user}":
		command		=> "bash --login -c 'jenv ${do} ${candidate} ${version} ${source}'",
		user		=> $user,
		group		=> $group,
		environment     => [ "HOME=${home_path}", "JENV_AUTO=true" ],
		path 		=> ['/bin', '/usr/bin', '/usr/sbin'],
		timeout 	=> 720,
		tries		=> '2',
		cwd 		=> $home_path,
		require		=> Exec["jenv::install::$user"],
	}
}
