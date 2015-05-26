class people::krsmes {

  include people::krsmes::config::osx
  include people::krsmes::config::gitconfig

  notify { 'class people::krsmes declared': }

}
