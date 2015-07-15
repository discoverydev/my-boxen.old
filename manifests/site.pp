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

  nodejs::version { 'v0.12.2': }
  class { 'nodejs::global': version => 'v0.12.2' }
  nodejs::module { 'npm': node_version => 'v0.12.2' }
  nodejs::module { 'appium': node_version => 'v0.12.2' }
  nodejs::module { 'ios-sim': node_version => 'v0.12.2' }

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

  file { '/usr/local/bin':
    ensure => directory,
    before => Package['virtualbox']
  }

  # common, useful packages -- brew
  package { 
    [
      'ant',               # for builds 
      'boot2docker',       # for docker used by ci (stash, jenkins, etc)
      'chromedriver',      # 
      'docker',            # for ci 
      'figlet',            #
      'git',               #
      'gradle',            # for builds
      'grails',            # 
      'groovy',            #
      'ideviceinstaller',  # for appium on ios devices
      'maven',             # for builds
      'openssl',           #
      'p7zip',             # 7z, XZ, BZIP2, GZIP, TAR, ZIP and WIM
      'pv',                # pipeview for progress bar
      'rbenv',             # ruby environment manager
      'sbt',               # for Gimbal Geofence Importer
      'scala',             # for Gimbal Geofence Importer
      'sonar-runner',      # for sonar tests
      'tomcat',            # for deploying .war files
      'wget',              #
      'xctool',            # xcode build, used by sonar
    ]: 
    ensure => present
  }

  # packages that should not be present anymore
  package { 'android-sdk': ensure => absent }   # instead, custom pre-populated android-sdk installed after boxen

  # homebrew package that requires custom params
  exec { 'drafter': 
    command => 'brew install --HEAD https://raw.github.com/apiaryio/drafter/master/tools/homebrew/drafter.rb',
    require => Class['homebrew']
  }
  
  exec { 'firefox': 
    command => 'sudo brew cask install firefox --appdir=/Applications --force',
    require => Class['homebrew']
  }

  # common, useful packages -- brew-cask
  package { [
      'android-studio',
      'appium',            # ios/android app testing
      'firefox',           # browser
      'genymotion',        # android in virtualbox (faster) 
      'google-chrome',     # browser
      'google-hangouts',   # communication tool
      'intellij-idea',     # IDE all the things
      'java',              # java 8
      'qlgradle',          # quicklook for gradle files
      'qlmarkdown',        # quicklook for md files
      'qlprettypatch',     # quicklook for patch files
      'qlstephen',         # quicklook for text files
      'slack',             # communication tool
      'iterm2',            # terminal replacement
      'virtualbox',        # VM for boot2docker, genymotion, etc
      'caffeine',          # keep the machine from sleeping
      'sourcetree',        # Atlassian Sourcetree
    ]: 
    provider => 'brewcask', 
    ensure => present
  }

  exec { 'sudo /usr/sbin/DevToolsSecurity --enable': }

  # geofencing uses python scripts
  exec { 'pip':  # python package manager  
    command => 'sudo easy_install pip'
  }
  exec { 'virtualenv':  # python environment manager
    command => 'sudo pip install virtualenv',
    require => Exec['pip']
  }

  exec { 'dynatrace': # Dynatrace instrumentation utility
    command => '/opt/boxen/repo/manifests/scripts/set-up-dynatrace-adk.sh'
  }

  file { "/Users/${::boxen_user}/.m2/settings.xml":
    source => "${boxen::config::repodir}/manifests/files/settings.xml"
  }

  host { 'jenkins':    ip => '192.168.8.31' }  
  host { 'stash':      ip => '192.168.8.31' }
  host { 'nexus':      ip => '192.168.8.31' }
  host { 'tomcat':     ip => '192.168.8.32' }
  host { 'confluence': ip => '192.168.8.34' }
  host { 'sonarqube':  ip => '192.168.8.35' }

  host { 'xavier':     ip => '192.168.8.31' }  
  host { 'rogue':      ip => '192.168.8.32' }  
  host { 'warlock':    ip => '192.168.8.33' }  
  host { 'wolverine':  ip => '192.168.8.34' }  
  host { 'beast':      ip => '192.168.8.35' }  
  
}
