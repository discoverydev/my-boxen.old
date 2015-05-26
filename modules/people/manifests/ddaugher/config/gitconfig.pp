class people::ddaugher::gitconfig (
    $my_homedir   = $people::ddaugher::params::my_homedir,
    $my_sourcedir = $people::ddaugher::params::my_sourcedir,
    $my_username  = $people::ddaugher::params::my_username,
    $my_email     = $people::ddaugher::params::my_email
    ){
  
  git::config::global {
    'user.name':    value => 'DJ Daugherty';
    'user.email':   value => 'ddaugherty@pillartechnology.com';
    'color.ui':     value => 'auto';
    'github.user':  value => 'ddaugher';
    'push.default': value => 'simple';
    'alias.a':      value => 'add';
    'alias.aa':     value => 'add -A';
    'alias.bv':     value => 'branch -avv';
    'alias.co':     value => 'checkout';
    'alias.c':      value => 'commit';
    'alias.cm':     value => 'commit -m';
    'alias.ca':     value => 'commit -a';
    'alias.cam':    value => 'commit -a -m';
    'alias.d':      value => 'diff';
    'alias.ds':     value => 'diff --stat';
    'alias.l':      value => 'log --graph --pretty=format:\'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\' --abbrev-commit --date=relative';
    'alias.l1':     value => 'log --pretty=oneline';
    'alias.s':      value => 'status';
    'alias cssl+'   value =>  'config --global http.sslVerify true';
    'alias cssl-'   value =>  'config --global http.sslVerify false';
}
  
}
