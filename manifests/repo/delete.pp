define jenv::repo::delete (
	$user,
        $group  = $user,
        $home   = '',
        $repo   = $title,
        $url,
) {
        $home_path      = $home ? { '' => "/home/${user}", default => $home }
        $jenv_path      = "${home_path}/.jenv"

	file { "${jenv_path}/repo/${repo}":
		ensure	=> absent,
	}
}
