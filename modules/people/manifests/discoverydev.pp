class people::discoverydev {

  include people::discoverydev::config::osx
  include people::discoverydev::config::gitconfig

  notify { 'class people::discoverydev declared': }

}
