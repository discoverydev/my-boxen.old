class people::discoverydev {

  notify { 'class people::discoverydev declared': }

  include people::discoverydev::config::osx
  include people::discoverydev::config::gitconfig

  file { "/Users/${::boxen_user}/.profile":
    source => "${boxen::config::repodir}/manifests/files/profile"
  }

  file { "/opt/boxen/homebrew/Cellar/sonar-runner/2.4/libexec/conf/sonar-runner.properties":
    source => "${boxen::config::repodir}/manifests/files/sonar-runner.properties"
  }
}
