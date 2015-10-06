require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::homebrewdir}/bin",
    '/usr/bin',
    '/usr/local/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew'],
  install_options => ['--appdir=/Applications', '--force']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>


node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx
  include brewcask

  include sublime_text
  # sublime_text::package { 'Emmet': source => 'sergeche/emmet-sublime' } 

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }


  #
  # NODE stuff
  #

  nodejs::version { 'v0.12.2': }
  class { 'nodejs::global': version => 'v0.12.2' }
  nodejs::module { 'npm': node_version => 'v0.12.2' }
  nodejs::module { 'appium': node_version => 'v0.12.2' }
  nodejs::module { 'ios-sim': node_version => 'v0.12.2' }


  #
  # RUBY stuff
  #

  ruby::version { '2.2.2': }
  class { 'ruby::global': version => '2.2.2' }
  ruby_gem { 'bundler':
    gem          => 'bundler',
    ruby_version => '*',
  }
  ruby_gem { 'cocoapods': 
    gem          => 'cocoapods',
    ruby_version => '*',
  }
  ruby_gem { 'ocunit2junit': # not sure if this is necessary here
    gem          => 'ocunit2junit',
    ruby_version => '*',
  }
  ruby_gem { 'appium_console': 
    gem          => 'appium_console',
    ruby_version => '*',
  }
  ruby_gem { 'rspec':
    gem          => 'rspec',
    ruby_version => '*',
  }


  #
  # PYTHON stuff
  #

  # geofencing uses python scripts
  exec { 'pip':  # python package manager
    command => 'sudo easy_install pip',
    creates => '/usr/local/bin/pip',
  }
  exec { 'virtualenv':  # python environment manager
    require => Exec['pip'],
    command => 'sudo pip install virtualenv',
    creates => '/usr/local/bin/virtualenv',
  }


  #
  # BREW and BREW CASKS
  #

  exec { "tap-discoverydev-ipa":
    command => "brew tap discoverydev/ipa",
    creates => "${homebrew::config::tapsdir}/discoverydev/homebrew-ipa",
  }

  package {
    [
      'ack',               # for searching strings within files at the command-line
      'ant',               # for builds 
      'chromedriver',      # for appium
      'docker',            # for ci 
      'docker-machine',    # for docker-machine used by ci (stash, jenkins, etc)
      'dos2unix',          # some Java cmd-line utilities are Windows-specific
      'git',               #
      'gradle',            # for builds
      'grails',            # for simple checkout
      'groovy',            # for simple checkout
      'ideviceinstaller',  # for appium on ios devices
      'imagemagick',       # for (aot) imprinting icons with version numbers
      'maven',             # for builds
      'mockserver',        # for mocking servers for testing
      'openssl',           # for ssl
      'p7zip',             # 7z, XZ, BZIP2, GZIP, TAR, ZIP and WIM
      'pv',                # pipeview for progress bar
      'rbenv',             # ruby environment manager
      'sbt',               # for Gimbal Geofence Importer
      'scala',             # for Gimbal Geofence Importer
      'sonar-runner',      # for sonar tests
      'tomcat',            # for deploying .war files
      'wget',              # 
      'xctool',            # xcode build, used by sonar
      'carthage'
    ]: 
    ensure => present,
    require => Exec['tap-discoverydev-ipa'],
  }

  file { '/usr/local/bin':
    ensure => directory,
    before => Package['virtualbox']
  }

  # common, useful packages -- brew-cask
  package { [
      'android-studio',    # IDE for android coding
      'appium148',         # for testing mobile emulators, simulators, and devices
      'caffeine',          # keep the machine from sleeping
      'citrix-receiver',   # Citrix VPN
      'genymotion',        # android in virtualbox (faster)
      'google-chrome',     # browser
      'google-hangouts',   # communication tool
      'intellij-idea',     # IDE all the things
      'iterm2',            # terminal replacement
      'java',              # java 8
      'qlgradle',          # quicklook for gradle files
      'qlmarkdown',        # quicklook for md files
      'qlprettypatch',     # quicklook for patch files
      'qlstephen',         # quicklook for text files
      'slack',             # communication tool
      'sourcetree',        # Atlassian Sourcetree
      'virtualbox',        # VM for docker-machine, genymotion, etc
    ]:
    provider => 'brewcask', 
    ensure => present,
    require => Exec['tap-discoverydev-ipa'],
  }

  exec { 'firefox':
    require => Class['homebrew'],
    command => 'sudo brew cask install firefox --appdir=/Applications --force',
    creates => '/Applications/Firefox.app',
  }


  #
  # MANUAL STUFF
  #

  # for iOS simulator to work
  exec { 'sudo /usr/sbin/DevToolsSecurity --enable':
    unless => "/usr/sbin/DevToolsSecurity | grep 'already enabled'"
  }

  exec { 'set-up-dynatrace-adk': # Dynatrace instrumentation utility
    command => "${boxen::config::repodir}/manifests/scripts/set-up-dynatrace-adk.sh",
    creates => '/opt/dynatrace',
  }

  exec { 'install_imagemagick_fonts': # Tell ImageMagick where to find fonts on this system
    require => Package['imagemagick'],
    command => "${boxen::config::repodir}/manifests/scripts/install_imagemagick_fonts.sh"
  }

  exec { 'set_up_mockability_server': # General-purpose mock HTTP server
    command => "${boxen::config::repodir}/manifests/scripts/set_up_mockability_server.sh",
    creates => '/opt/mockability-server',
  }


  #
  # HOSTNAME to IPs
  #

  host { 'jenkins':    ip => '192.168.8.31' }  
  host { 'stash':      ip => '192.168.8.31' }
  host { 'nexus':      ip => '192.168.8.31' }
  host { 'tomcat':     ip => '192.168.8.32' }
  host { 'confluence': ip => '192.168.8.34' }
  host { 'sonarqube':  ip => '192.168.8.35' }
  host { 'mockserver': ip => '192.168.8.32' }

  host { 'xavier':     ip => '192.168.8.31' }  
  host { 'rogue':      ip => '192.168.8.32' }  
  host { 'warlock':    ip => '192.168.8.33' }  
  host { 'wolverine':  ip => '192.168.8.34' }  
  host { 'beast':      ip => '192.168.8.35' }
  
  #
  # CLEAN UP
  #
  
  # packages that should not be present anymore
  package { 'android-sdk': ensure => absent }   # instead, custom pre-populated android-sdk installed after boxen

}
