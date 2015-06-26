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
  require  => Class['homebrew']
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
      'ant',               #
      'boot2docker',       #
      'chromedriver',      #
      'docker',            #
      'figlet',            #
      'git',               #
      'gradle',            #
      'groovy',            #
      'maven',             #
      'openssl',           #
      'p7zip',             #
      'rbenv',             #
      'wget',              #
      'xctool',            # xcode build, used by sonar
    ]: 
    ensure => present
  }

  package { 'android-sdk': ensure => absent }   # custom pre-populated android-sdk installed after boxen

  exec { 'drafter': 
    command => 'brew install --HEAD https://raw.github.com/apiaryio/drafter/master/tools/homebrew/drafter.rb',
    require => Class['homebrew']
  }

  # common, useful packages -- brew-cask
  package { [
      'android-studio',
      'appium',
      'firefox', 
      'genymotion',        # android in virtualbox (faster) 
      'google-chrome',
      'google-hangouts',
      'intellij-idea',
      'java',              # java 8
      'qlgradle',          # quicklook for gradle files
      'qlmarkdown',        # quicklook for md files
      'qlprettypatch',     # quicklook for patch files
      'qlstephen',         # quicklook for text files
      'slack',
      'iterm2',
      'virtualbox',
    ]: 
    provider => 'brewcask', 
    ensure => present
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }

  exec { 'git config --global push.default simple': }

  include osx_config

  host { 'jenkins':  ip => '192.168.8.31' }  
  host { 'stash':    ip => '192.168.8.31' }
  host { 'nexus':    ip => '192.168.8.31' }

}
