class people::discoverydev {

  notify { 'class people::discoverydev declared': }

  include people::discoverydev::config::osx
  include people::discoverydev::config::gitconfig

  file { "/Users/${::boxen_user}/.profile":
    source => "${boxen::config::repodir}/manifests/files/profile"
  }

  file { "LaunchAgents":
    name => "/Users/${::boxen_user}/Library/LaunchAgents",
    ensure => directory,
  }

  file { "boxen.update.plist":
    name => "/Users/${::boxen_user}/Library/LaunchAgents/boxen.update.plist",
    require => File['LaunchAgents'],
    source => "${boxen::config::repodir}/manifests/files/boxen.update.plist"
  }
  
  exec { "unload-boxen-update-to-plist":
        require => File['boxen.update.plist'],
  	command => "launchctl unload boxen.update.plist",
  	path    => "/usr/local/bin/:/bin/:/usr/bin/",
  	user    => root,
  }
  
  exec { "load-boxen-update-to-plist":
        require => Exec['unload-boxen-update-to-plist'],
  	command => "launchctl load boxen.update.plist",
  	path    => "/usr/local/bin/:/bin/:/usr/bin/",
  	user    => root,
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
