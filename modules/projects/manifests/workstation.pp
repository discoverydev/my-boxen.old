class projects::workstation {

  $user_home = "/Users/${::boxen_user}"
  $workstation_files = "${boxen::config::srcdir}/workstation-files"

  repository { 'workstation-files':
    path => $workstation_files,
    source => "http://${::boxen_user}@stash/scm/cypher/workstation-files.git",
    ensure => master,
  }


  #
  # maven global settings
  #

  file { 'm2':
    name => "${user_home}/.m2",
    ensure => directory,
  }

  file { 'settings.xml':
    require => [File['m2'],Repository['workstation-files']],
    name => "${user_home}/.m2/settings.xml",
    source => "${workstation_files}/m2/settings.xml",
  }

  #
  # boxen auto-updater
  #

  file { "LaunchAgents":
    name => "${user_home}/Library/LaunchAgents",
    ensure => directory,
  }

  file { "boxen.update.plist":
    require => [File['LaunchAgents'],Repository['workstation-files']],
    name => "${user_home}/Library/LaunchAgents/boxen.update.plist",
    source => "${workstation_files}/LaunchAgents/boxen.update.plist"
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

  #
  # keychain certificates
  #

  exec { "adscorporate-root-ca":
    require => Repository['workstation-files'],
    command => "security add-trusted-cert -d -r trustRoot -k '/Library/Keychains/System.keychain' '${workstation_files}/certs/ADSCorporate-Root-CA.cer'",
    path    => "/usr/local/bin/:/bin/:/usr/bin/",
    user    => root,
  }

  exec { "adsretail-issuing-ca":
    require => Repository['workstation-files'],
    command => "security add-trusted-cert -d -r trustRoot -k '/Library/Keychains/System.keychain' '${workstation_files}/certs/ADSRetail-Issuing-CA.cer'",
    path    => "/usr/local/bin/:/bin/:/usr/bin/",
    user    => root,
  }

}
