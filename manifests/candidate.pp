define jenv::candidate (
	$user,
	$candidate	= $title,
	$version,
	$group		= $user,
	$home		= '',
	$jenv		= '',
	$command	= '',
	$source		= '',
	$set_default	= false,
) {
	$home_path	= $home ? { '' => "/home/${user}", default => $home }
	$jenv_path      = $jenv ? { '' => "${home_path}/.jenv", default => $jenv }

	$do		= $command ? { '' => 'install', default => $command }

	$default	= $set_default ? { false => 'N', default => 'Y' }

	if ! defined( Jenv::Install[$user] ) {
		debug( "Jenv is not installed for ${user}" )
		debug( "Installing jenv for ${user}..." )

		jenv::install { $user:
			home	=> $home_path,
			jenv	=> $jenv_path,
		}
	}

	exec { "jenv::${candidate}::${version}::${do}::${user}":
		command		=> "bash --login -c 'echo ${default} | jenv ${do} ${candidate} ${version} ${source}'",
		user		=> $user,
		group		=> $group,
		environment     => [ "HOME=${home_path}" ],
		path 		=> ['/bin', '/usr/bin', '/usr/sbin'],
		timeout 	=> 720,
		tries		=> '2',
		cwd 		=> $home_path,
		require		=> Jenv::Install[$user],
	}
}
