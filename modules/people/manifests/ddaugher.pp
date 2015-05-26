class people::ddaugher {

  include people::ddaugher::config::osx
  include people::ddaugher::config::gitconfig

  notify { 'class people::ddaugher declared': }

}
