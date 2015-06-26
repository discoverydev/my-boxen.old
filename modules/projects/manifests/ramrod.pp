class projects::ramrod {
	
  # ramrod android projects
  boxen::project { 'ramrod_android_core':     
    source => 'http://stash/scm/mls/ramrod_android_core.git',
    require => Host['stash'] 
  }
  boxen::project { 'ramrod_android_foo':      
    source => 'http://stash/scm/mls/ramrod_android_foo.git', 
    require => Host['stash'] 
  }
  boxen::project { 'ramrod_android_bar':      
    source => 'http://stash/scm/mls/ramrod_android_bar.git', 
    require => Host['stash'] 
  }
  boxen::project { 'ramrod_android_shell':    
    source => 'http://stash/scm/mls/ramrod_android_shell.git', 
    require => Host['stash'] 
  }

  # ramrod ios projects
  boxen::project { 'ramrod_ios_core':         
    source => 'http://stash/scm/mls/ramrod_ios_core.git', 
    require => Host['stash'] 
  }
  boxen::project { 'ramrod_ios_foo':          
    source => 'http://stash/scm/mls/ramrod_ios_foo.git', 
    require => Host['stash'] 
  }
  boxen::project { 'ramrod_ios_bar':          
    source => 'http://stash/scm/mls/ramrod_ios_bar.git', 
    require => Host['stash'] 
  }
  boxen::project { 'ramrod_ios_shell':        
    source => 'http://stash/scm/mls/ramrod_ios_shell.git', 
    require => Host['stash'] 
  }

  # ramrod functional tests
  boxen::project { 'ramrod-functional-tests': 
    source => 'http://stash/scm/mls/ramrod-functional-tests.git', 
    require => Host['stash'] 
  }
	
}