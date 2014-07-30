define jenv::install (
	$user	= $title,
	$group	= $user,
	$home	= '',
	$jenv	= '',
) {
	$home_path	= $home ? { '' => "/home/${user}", default => $home }
	$jenv_path	= $jenv ? { '' => "${home_path}/.jenv", default => $jenv }

	if ! defined( Class['jenv::dependencies'] ) {
		require jenv::dependencies
	}

	exec { "jenv::install::download::${user}":
		command		=> "git clone https://github.com/netbrick/jenv.git ${jenv_path}",
		user		=> $user,
		group		=> $group,
		creates		=> $jenv_path,
		onlyif		=> "[ ! -d '${jenv_path}' ]",
		environment	=> [ "HOME=${home_path}" ],
		path		=> [ '/bin', '/usr/bin', '/usr/sbin' ],
		timeout		=> 150,
		cwd		=> $home_path,
		notify		=> Exec["jenv::install:init::${user}"],
	}	

	exec { "jenv::install:init::${user}":
		command         => "bash ${jenv_path}/commands/install.sh",
                user            => $user,
                group           => $group,
                environment     => [ "HOME=${home_path}" ],
                path            => [ '/bin', '/usr/bin', '/usr/sbin' ],
                refreshonly	=> true,
		timeout         => 150,
                cwd             => $home_path,
		require		=> Exec["jenv::install::download::${user}"],
        }
}
