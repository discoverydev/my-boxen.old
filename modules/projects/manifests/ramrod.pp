class projects::ramrod {
	

  # ramrod android projects
  boxen::project { 'ramrod_android_core':     source => 'http://stash/scm/mls/ramrod_android_core.git' }
  boxen::project { 'ramrod_android_foo':      source => 'http://stash/scm/mls/ramrod_android_foo.git' }
  boxen::project { 'ramrod_android_bar':      source => 'http://stash/scm/mls/ramrod_android_bar.git' }
  boxen::project { 'ramrod_android_shell':    source => 'http://stash/scm/mls/ramrod_android_shell.git' }
  # ramrod ios projects
  boxen::project { 'ramrod_ios_core':         source => 'http://stash/scm/mls/ramrod_ios_core.git' }
  boxen::project { 'ramrod_ios_foo':          source => 'http://stash/scm/mls/ramrod_ios_foo.git' }
  boxen::project { 'ramrod_ios_bar':          source => 'http://stash/scm/mls/ramrod_ios_bar.git' }
  boxen::project { 'ramrod_ios_shell':        source => 'http://stash/scm/mls/ramrod_ios_shell.git' }
  # ramrod functional tests
  boxen::project { 'ramrod-functional-tests': source => 'http://stash/scm/mls/ramrod-functional-tests.git' }
	
}