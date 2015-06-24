class projects::ci {

  boxen::project { 'jenkins':
    nginx         => 'projects/shared/nginx-jenkins.conf.erb',
    source        => 'discvoerydev/default_boxen_project'
  }
  boxen::project { 'nexus':
    nginx         => 'projects/shared/nginx-nexus.conf.erb',
    source        => 'discvoerydev/default_boxen_project'
  }
  boxen::project { 'stash':
    nginx         => 'projects/shared/nginx-stash.conf.erb',
    source        => 'discvoerydev/default_boxen_project'
  }
}
