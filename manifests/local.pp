define jenv::local (
	$user		= $title,
	$group		= $user,
	$path,
	$candidate,
	$version,
) {
	file { "jenv::local::${candidate}":
		path	=> "${path}/.jenvrc,
		owner	=> $user,
		group	=> group,
		mode	=> 644,
		line	=> "${candidate}=${version}",
	} 
}
