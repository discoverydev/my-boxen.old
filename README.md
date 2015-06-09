# Discovery Development Setup

This document will detail the steps required to setup/configure:
* [Development machine](#development-machine)
* [Stash machine](#stash-machine)
* [Nexus machine](#nexus-machine)
* [Jenkins machine](#jenkins-machine)
* [Build machine complete install](#build-machine-complete-install)
* [Jenkins Slave machine](#jenkins-slave-machine)

## Development machine

The standard development machine is managed via a customized Boxen script.  The following steps are required for all Discovery Development machines... including 'build' machines.

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

## Stash machine
The internal Discovery instance of Stash will be managed via a custom shell (bash) script and a Docker image of Stash.

### Installation Steps
#### Configure Stash on local build machine

> if you have not completed the [development-machine](#development-machine) setup, please complete prior to Stash installation
```
cd /opt/boxen/repo
./init_stash.sh [provide location to base stash backup]
```

## Nexus machine
The internal Discovery instance of Nexus will be managed via a custom shell (bash) script and a Docker image of Nexus.

### Installation Steps
#### Configure Stash on local build machine

> if you have not completed the [development-machine](#development-machine) setup, please complete prior to Stash installation
```
cd /opt/boxen/repo
./init_nexus.sh
```

## Jenkins machine
The internal Discovery instance of Jenkins will be managed via a custom shell (bash) script and a Docker image of Jenkins.

### Installation Steps
#### Configure Stash on local build machine

> if you have not completed the [stash-machine](#stash-machine) setup, please complete prior to Stash installation.  The base Jenkins configuration and jobs will be maintained within the Stash Git repositories.
```
cd /opt/boxen/repo
./init_jenkins.sh
```

## Jenkins machine
The internal Discovery instance of Jenkins will be managed via a custom shell (bash) script and a Docker image of Jenkins.

### Installation Steps
#### Configure Stash on local build machine

> if you have not completed the [stash-machine](#stash-machine) setup, please complete prior to Stash installation.  The base Jenkins configuration and jobs will be maintained within the Stash Git repositories.
```
cd /opt/boxen/repo
./init_jenkins.sh
```

## Build machine complete install
As a convenience, if you would like to install of all of the 'build' machine on a single hardware instance, the following script will complete the necessary tasks.

### Installation Steps
#### Configure Stash on local build machine

> if you have not completed the [development-machine](#development-machine) setup, please complete prior to Stash installation
```
cd /opt/boxen/repo
./init_build_complete.sh
```

## Jenkins Slave machine

----
### Help!
