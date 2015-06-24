# Discovery Development Setup

This document will detail the steps required to setup/configure:
* [Development machine](#development-machine)
* [Build machine](#build-machine)
* [create_user Slave machine](#create_user-slave-machine)
* [Reset the machine](#reset-the-machine)

## Development machine

The standard development machine is managed via a customized Boxen script.  The following steps are required for all Discovery Development machines... including 'build' machines.

### Introduction

This is intended to configure Discovery Dev and Build machines on OSX hardware only.

### Getting Started

To give you a brief overview, we're going to:

* create 'admin' user
* Install dependencies (basically Xcode and command line tools)
* Pull down customized Boxen
* Run Boxen to configure environment
* execute 'after' script to handle non-boxen installs

### Dependencies
##### Create local OSX user (this is not required if machine was setup with admin user)

login in as Discovery base admin user
clone the following repository [create user repository](https://github.com/discoverydev/create_user.git)

create local OSX user (admin), please use
- username: 'admin'
- password: 'agileLIVE!'
- administrator: 'y'

```
cd /opt/boxen/repo
sudo ./create_user.sh
log out
log in as new 'admin' user
```

####Install the full Xcode (from the App Store) 

Install the Command Line Tools.
```
within a terminal window -> xcode-select --install

this will prompt to install Command Line Tools
```

### What You Get

List of packages installed, intentially not listed.  Please check the [site.pp](https://github.com/discoverydev/my-boxen/blob/ads/manifests/site.pp) file to find the current list of packages installed

### Installation Steps

##### create /usr/local on local machine
```
sudo mkdir -p /usr/local
sudo chown admin:staff /usr/local
```

##### How to fix 'sudo: no tty present and no askpass program specified' error?
```
sudo visudo

find the line in the file... %admin ALL=(ALL) ALL

change the line to... %admin ALL=(ALL) NOPASSWD:ALL
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

##### 'after' script
```
the after script will install command-line appium tools and required gems

cd /opt/boxen/repo
./run_after_boxen.sh
```

[Add machine as slave node](#step-to-add-a-new-slave-node-to-the-master-create_user-instance)

It should run successfully, and indicate the need to source a shell script in your environment.  For users without a bash config or a `~/.profile` file, Boxen will create a shim for you that will work correctly.  If you do have a `~/.bashrc`, your shell will not use `~/.profile` so you'll need to add a line like so at _the end of your config_:

``` sh
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
```

Once the shell is ready, open a new tab/window in your Terminal
and execute - `boxen --env`.
If that runs cleanly, you're in good shape.

##### Boxen Install Complete
The Development machine is operational.

## Build machine
The following instructions will configure a base 'build' machine, complete with Continuous Integration (create_user), artifact repository (Nexus) and Stash repository.

### Installation Steps
#### Configure local build machine

> if you have not completed the [Development machine](#development-machine) setup, please complete prior to Stash installation

```
cd /opt/boxen/repo
./init_build_machine_complete.sh [base stash image if available]
```

## Jenkins Slave Nodes
The base build installation is configured with a single slave attached to the host OSX machine.  This node is configured to accept as much traffic as available.

Additional machines (development and/or build) can be added to the jenkins master instance.  These additions should be commited to the repository (git) in order to allow subsequent machines created using the boxen/docker install scripts to utilize.

The configured slave will utilize the 'admin' user created during the development machine install.

### Step to add a new 'slave node' to the master jenkins instance
* access master jenkins instance
* Manage Jenkins -> Manage Nodes -> New Node
* Copy an existing node for faster setup
* Configure the node
```
Name: [something meaningful]
Description: [your choice]
# of executors: [not recommended to be more than the # of cores]
Remote root directory: /Users/admin/jenkins_slave
Labels: [osxhost]
Usage: [Utilize this node as much as possible]
Launch Method: [Launch slave agents via Java Web Start]
Availability: [Keep this slave on-line as much as possible]
```
* Save the configuration
* Start the slave node
```
on the slave machine

cd /opt/boxen/repo
./start_jenkins_slave.sh [name of node you just created]
```
* Node will start and jenkins will connect to remote slave node

## Reset the machine
The entire machine can be reset, returned to an initial state prior to Discovery install, using the following script.  This can be helpful when a machine has become unstable or needs to be repurposed.

```
cd /opt/boxen/repo
./reset_machine.sh
```

----
### Help!
More to come later !
