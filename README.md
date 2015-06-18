# Discovery Development Setup

This document will detail the steps required to setup/configure:
* [Development machine](#development-machine)
* [Build machine](#build-machine)
* [Jenkins Slave machine](#jenkins-slave-machine)
* [Reset the machine](#reset-the-machine)

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

##### create /usr/local on local machine
```
sudo mkdir -p /usr/local
sudo chown admin:staff /usr/local
```

##### Configure Boxen on local machine
```
sudo mkdir -p /opt/boxen
sudo chown admin:staff /opt/boxen
git clone https://github.com/discoverydev/my-boxen /opt/boxen/repo
cd /opt/boxen/repo
git checkout ads
./script/boxen
```
##### How to fix 'sudo: no tty present and no askpass program specified' error?
```
sudo visudo

find the line in the file... %admin ALL=(ALL) ALL

change the line to... %admin ALL=(ALL) NOPASSWD:ALL
```


It should run successfully, and indicate the need to source a shell script in your environment.  For users without a bash config or a `~/.profile` file, Boxen will create a shim for you that will work correctly.  If you do have a `~/.bashrc`, your shell will not use `~/.profile` so you'll need to add a line like so at _the end of your config_:

``` sh
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
```

Once the shell is ready, open a new tab/window in your Terminal
and execute - `boxen --env`.
If that runs cleanly, you're in good shape.

##### Create local OSX user
create local OSX user (admin), please use
- username: 'admin'
- password: 'agileLIVE!'
- administrator: 'y'

```
cd /opt/boxen/repo
./create_user.sh
```

##### Boxen Install Complete
The Development machine is operational.

## Build machine
The following instructions will configure a base 'build' machine, complete with Continuous Integration (Jenkins), artifact repository (Nexus) and Stash repository.

### Installation Steps
#### Configure local build machine

> if you have not completed the [Development machine](#development-machine) setup, please complete prior to Stash installation

```
cd /opt/boxen/repo
./init_build_machine_complete.sh [base stash image if available]
```

## Jenkins Slave machine
The base build installation will configure a single slave attached to the host OSX machine.  The slave is configured to accept as much traffic as available.

Additional machines (development and/or build) can be added to the jenkins instance.  These additions should be commited to the repository in order to allow subsequent machines created using the  boxen/docker install scripts to remain the same.

The configured slave will utilize the 'admin' user created during the development machine install.

## Reset the machine
The entire machine can be reset, returned to an initial state prior to Discovery install, using the following script.  This can be helpful when a machine has become unstable or needs to be repurposed.

```
cd /opt/boxen/repo
./reset_machine.sh
```

----
### Help!
More to come later !
