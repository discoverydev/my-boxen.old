class people::discoverydev {

  notify { 'class people::discoverydev declared': }

  include people::discoverydev::config::osx
  include people::discoverydev::config::gitconfig

  file { "/Users/${::boxen_user}/.profile":
    source => "${boxen::config::repodir}/manifests/files/profile"
  }

  file { "/opt/boxen/homebrew/Cellar/sonar-runner/2.4/libexec/conf/sonar-runner.properties":
    require => Package['sonar-runner'],
    source => "${boxen::config::repodir}/manifests/files/sonar-runner.properties"
  }

  exec { "add-root-ca":
  	command => 'security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "/opt/boxen/repo/manifests/files/ADSCorporate-Root-CA.cer"',
  	path    => "/usr/local/bin/:/bin/:/usr/bin/",
  	user    => root,
  }

  exec { "add-retail-ca":
  	command => 'security add-trusted-cert -d -r trustRoot -k "/Library/Keychains/System.keychain" "/opt/boxen/repo/manifests/files/ADSRetail-Issuing-CA.cer"',
  	path    => "/usr/local/bin/:/bin/:/usr/bin/",
  	user    => root,
  }
}
