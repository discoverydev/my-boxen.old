class osx_config {
  
  notify { 'class osx_config declared': }

  include osx::global::enable_keyboard_control_access
  include osx::global::enable_standard_function_keys
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::disable_autocorrect

  include osx::disable_app_quarantine
  include osx::no_network_dsstores
  include osx::universal_access::ctrl_mod_zoom
  include osx::universal_access::enable_scrollwheel_zoom
  include osx::safari::enable_developer_mode

  class { 'osx::global::key_repeat_delay': delay => 10 }
  class { 'osx::global::key_repeat_rate': rate => 2 }
  class { 'osx::dock::icon_size': size => 18 }

  include osx_config::terminal

}