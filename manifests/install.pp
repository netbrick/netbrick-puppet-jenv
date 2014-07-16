define jenv::install (
	$user	= $title,
	$group	= $user,
	$home	= '',
) {
	$home_path	= $home ? { '' => "/home/${user}", default => $home }
	$jenv_path	= "${home_path}/.jenv"

	if ! defined( Class['jenv::dependencies'] ) {
		require jenv::dependencies
	}

	file_line { "jenv::install::profile::${user}":
                path    => "${home_path}/.profile",
                line    => "[[ -s \"${jenv_path}/bin/jenv-init.sh\" ]] && source \"${jenv_path}/bin/jenv-init.sh\" && source \"${jenv_path}/commands/completion.sh\"",
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
		command         => "${jenv_path}/bin/jenv-init.sh",
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
