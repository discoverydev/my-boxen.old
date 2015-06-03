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

  class { 'jenkins':
    public_port    => true
  }  

  # include the following jenkins plugins
  jenkins::plugin { 'xcode-plugin': version => '1.4.8' }
  jenkins::plugin { 'token-macro': version => '1.10' }
  jenkins::plugin { 'git-client': version => '1.16.1' }
  jenkins::plugin { 'git': version => '2.3.5' }
  jenkins::plugin { 'greenballs': version => '1.14' }
  jenkins::plugin { 'scm-api': version => '0.2' }
  jenkins::plugin { 'stashNotifier': version => '1.8' }
  jenkins::plugin { 'gradle': version => '1.24' }

  # the following will remove plugins, but will not remove the 'base' standard plugins delivered with jenkins
  # jenkins::plugin { 'gradle': ensure => absent }

  file { '/usr/local/bin':
    ensure => directory,
    before => Package['virtualbox']
  }

  # common, useful packages -- brew
  package { 
    [
      'android-sdk',       #
      'ant',               #
      'boot2docker',       #
      'chromedriver',      #
      'docker',            #
      'git',               #
      'gradle',            #
      'groovy',            #
      'maven',             #
      'node',              #
      'openssl',           #
      'p7zip',             #
      'scala',             #
      'wget',              #
      'xctool',            # xcode build, used by sonar
    ]: 
    ensure => present
  }

  exec { 'drafter': 
    command => 'brew install --HEAD https://raw.github.com/apiaryio/drafter/master/tools/homebrew/drafter.rb',
    require  => Class['homebrew']
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
      'virtualbox'
    ]: 
    provider => 'brewcask', 
    ensure => present
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }

  include osx_config
}
