class jenv::dependencies {	
	if ! defined( Package['git'] )		{ package { "git": 		ensure => installed, name => 'git-core' } }
	if ! defined( Package['subversion'] )	{ package { "subversion":	ensure => installed } }
	if ! defined( Package['sudo'] ) 	{ package { "sudo": 		ensure => installed } }
	if ! defined( Package['curl'] )		{ package { "curl":		ensure => installed } }
	if ! defined( Package['unzip'] )	{ package { "unzip":		ensure => installed } }
}
