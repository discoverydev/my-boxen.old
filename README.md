# Discovery Development Setup

This document will detail the steps required to setup/configure:
* [Development machine](#development-machine)
* [Jenkins machine](#jenkins-machine)
* [Nexus machine](#nexus-machine)
* [Stash machine](#stash-machine)
* [Jenkins Slave machine](#jenkins-slave-machine)

## Development machine

The standard development machine is managed via a customized Boxen script.  The following steps are required for all Discovery Development machines.

### Prerequisite

This is intended to configure Discovery Dev and Build machines on OSX hardware only.

### Getting Started

To give you a brief overview, we're going to:

* Install dependencies (basically Xcode)
* Pull down customized Boxen
* Run Boxen to configure environment

### Dependencies

Install the full Xcode and Command Line Tools.**

### What You Get

List of packages installed, intentially not listed.  Please check the [site.pp](https://github.com/discoverydev/my-boxen/blob/ads/manifests/site.pp) file to find the current list of packages installed

### Installation Steps

##### Create local OSX user
create local OSX user (jenkins) as Administrator, please use
- username: 'jenkins'
- password: 'password'

##### Configure Boxen on local machine
```
sudo mkdir -p /opt/boxen
sudo chown admin:staff /opt/boxen
git clone https://github.com/discoverydev/my-boxen /opt/boxen/repo
cd /opt/boxen/repo
git checkout ads
./script/boxen
```

It should run successfully, and indicate the need to source a shell script in your environment.  For users without a bash config or a `~/.profile` file, Boxen will create a shim for you that will work correctly.  If you do have a `~/.bashrc`, your shell will not use `~/.profile` so you'll need to add a line like so at _the end of your config_:

``` sh
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
```

Once the shell is ready, open a new tab/window in your Terminal
and execute - `boxen --env`.
If that runs cleanly, you're in good shape.

##### Boxen Install Complete
The Development machine is operational.

## Jenkins machine
## Nexus machine
## Stash machine
## Jenkins Slave machine
----

### Help!
