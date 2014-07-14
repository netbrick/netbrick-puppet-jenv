define jenv::install (
	$user	= $title,
	$group	= $user,
	$home	= '',
) {
	$home_path	= $home ? { '' => "/home/${user}", default => $home }
	$jenv_path	= "${home_path}/.jenv"

	$jenvrc		= ".jenvrc"

	if ! defined( Class['jenv::dependencies'] ) {
		require jenv::dependencies
	}

	exec { "jenv::install::${user}":
		command		=> "curl -L -s get.jenv.io | bash > /dev/null",
		user		=> $user,
		group		=> $group,
		creates		=> $jenv_path,
		onlyif		=> "[ ! -d '${home_path}/.jenv' ]",
		environment	=> [ "HOME=${home_path}" ],
		path		=> [ '/bin', '/usr/bin', '/usr/sbin' ],
		timeout		=> 150,
		cwd		=> $home_path,
		require		=> [ Package['unzip'], Package['curl'] ],
	}	
}
