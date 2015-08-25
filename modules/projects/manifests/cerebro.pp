class projects::cerebro {

  boxen::project { 'android_plugin_account_center':
    source  => 'http://stash/scm/mls/android_plugin_account_center.git',
    require => Host['stash']
  }
  boxen::project { 'ios_plugin_account_center':
    source  => 'http://stash/scm/mls/ios_plugin_account_center.git',
    require => Host['stash']
  }
  boxen::project { 'mlsplatform_apis':
    source  => 'http://stash/scm/mls/mlsplatform_apis.git',
    require => Host['stash']
  }
  boxen::project { 'nac_appium_test_suite':
    source  => 'http://stash/scm/mls/nac_appium_test_suite.git',
    require => Host['stash']
  }
  boxen::project { 'simple_ads_nac_android_shell':
    source  => 'http://stash/scm/mls/simple_ads_nac_android_shell.git',
    require => Host['stash']
  }
  boxen::project { 'simple_ads_nac_ios_shell':
    source  => 'http://stash/scm/mls/simple_ads_nac_ios_shell.git',
    require => Host['stash']
  }
}
