class osx_config {
  
  notify { 'class osx_config declared': }

  include osx::global::enable_keyboard_control_access
  include osx::global::enable_standard_function_keys
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::disable_autocorrect

  include osx::finder::unhide_library
  include osx::finder::show_hidden_files
  include osx::finder::enable_quicklook_text_selection
  include osx::finder::show_all_filename_extensions

  include osx::disable_app_quarantine
  include osx::no_network_dsstores
  include osx::universal_access::ctrl_mod_zoom
  include osx::universal_access::enable_scrollwheel_zoom
  include osx::safari::enable_developer_mode

  class { 'osx::mouse::button_mode': mode => 2 }
  class { 'osx::global::key_repeat_delay': delay => 30 }
  class { 'osx::global::key_repeat_rate': rate => 2 }
  class { 'osx::dock::icon_size': size => 18 }

  boxen::osx_defaults { 'Show Path Bar in Finder': 
    user   => $::boxen_user,
    domain => 'com.apple.finder',
    key    => 'ShowPathbar',  #lowercase 'b' is correct here
    value  => true,
    notify => Exec['killall Finder']
  }
  boxen::osx_defaults { 'Show Status Bar in Finder': 
    user   => $::boxen_user,
    domain => 'com.apple.finder',
    key    => 'ShowStatusBar', 
    value  => true,
    notify => Exec['killall Finder']
  }
  boxen::osx_defaults { 'Show Tab Bar in Finder': 
    user   => $::boxen_user,
    domain => 'com.apple.finder',
    key    => 'ShowTabView', 
    value  => true,
    notify => Exec['killall Finder']
  }

  include osx_config::terminal

  exec { 'Turn on screen sharing':
    command => 'sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -privs -all -restart -agent -menu' 
  }
  exec { 'Turn on remote login':
    command => 'sudo systemsetup -setremotelogin on' 
  }
  exec { 'Set display sleep':
    command => 'sudo systemsetup -setdisplaysleep 10' 
  }
  exec { 'Set computer sleep':
    command => 'sudo systemsetup -setcomputersleep Never' 
  }
  exec { 'Set hard disk sleep':
    command => 'sudo systemsetup -setharddisksleep Never' 
  }
}
