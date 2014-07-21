define jenv::repo::add (
	$user,
	$group	= $user,
	$home	= '',
	$repo	= $title,
	$url,
) {
	$home_path      = $home ? { '' => "/home/${user}", default => $home }
        $jenv_path      = "${home_path}/.jenv"	

	if ! defined( Jenv::Install[$user] ) {
                debug( "Jenv is not installed for ${user}" )
                debug( "Installing jenv for ${user}..." )

                jenv::install { $user:
                        home    => $home_path,
                }
        }

	exec { "jenv::repo::add::${repo}":
                command         => "bash --login -c 'jenv repo add ${repo} ${url}'",
                user            => $user,
                group           => $group,
                creates         => "${jenv_path}/repo/${repo}",
                environment     => [ "HOME=${home_path}" ],
                path            => [ '/bin', '/usr/bin', '/usr/sbin' ],
                timeout         => 150,
                cwd             => $home_path,
		require		=> Jenv::Install[$user],
        }
}
