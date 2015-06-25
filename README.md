# Discovery Development Setup

This document will detail the steps required to setup/configure:
* [Development machine](#development-machine)
* [Build machine](#build-machine)
* [Jenkins Slave machine](#jenkins-slave-machine)
* [Clean everything off the machine](#clean-everything-off-the-machine)

----

## Development machine

The standard development machine is managed via a customized Boxen script.  The following steps are required for all Discovery Development machines... including 'build' machines.

### Introduction

This is intended to configure Discovery Dev and Build machines on OSX hardware only.

### Getting Started

To give you a brief overview, we're going to:

* Install dependencies (basically Xcode and command line tools)
* Pull down customized Boxen
* Run Boxen to configure environment
* execute 'after' script to handle non-boxen installs

### Dependencies

####Install the full Xcode 

* Go to App Store and install Xcode
* Open Xcode and let it initialize itself
* Accept the license (which requires entering the user's password)

####Install/Update the Command Line Tools.

Within a terminal window:

```
xcode-select --install
```

This will prompt to install Command Line Tools, click the Install button.

At this point verify dependencies are setup properly by running ```git``` from Terminal.  There should not be any error messages.

### What You Will Get

List of packages installed, intentially not listed.  Please check the [site.pp](https://github.com/discoverydev/my-boxen/blob/ads/manifests/site.pp) file to find the current list of packages installed

### Installation Steps

##### Make ga-mlsdiscovery a sudoer

```
sudo visudo
```

* find the line in the file: ```%admin ALL=(ALL) ALL```
* add a new line: ```ga-mlsdiscovery ALL=(ALL) NOPASSWD:ALL```

##### Create /usr/local on local machine

```
sudo mkdir -p /usr/local
sudo chown ga-mlsdiscovery:staff /usr/local
```

##### Configure Boxen on local machine
```
sudo mkdir -p /opt/boxen
sudo chown -R ga-mlsdiscovery:staff /opt
git clone https://github.com/discoverydev/my-boxen /opt/boxen/repo
cd /opt/boxen/repo
git checkout ads
./script/boxen
```

It should run successfully, and indicate the need to source a shell script in your environment.  For users without a bash config or a `~/.profile` file, Boxen will create a shim for you that will work correctly.  If you do have a `~/.bashrc`, your shell will not use `~/.profile` so you'll need to add a line like so at _the end of your config_:

``` sh
[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
```

Once the shell is ready:
* in Terminal, open a new tab/window (cmd-T)
* execute: ```boxen --env```

If that runs cleanly, you're in good shape.

##### 'after' script
```
the after script will install command-line appium tools and required gems

cd /opt/boxen/repo
./run_after_boxen.sh
```

[Add machine as slave node](#step-to-add-a-new-slave-node-to-the-master-jenkins-instance)

##### Boxen Install Complete
The Development machine is operational.

----

## Build machine
The following instructions will configure a base 'build' machine, complete with Continuous Integration (Jenkins), artifact repository (Nexus) and Stash repository.

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

The configured slave will utilize the 'ga-mlsdiscovery' user created during the development machine install.

### Step to add a new 'slave node' to the master jenkins instance
* access master jenkins instance
* Manage Jenkins -> Manage Nodes -> New Node
* Copy an existing node for faster setup
* Configure the node
```
Name: [something meaningful]
Description: [your choice]
# of executors: [not recommended to be more than the # of cores]
Remote root directory: /Users/ga-mlsdiscovery/jenkins_slave
Labels: [osxhost]
Usage: [Utilize this node as much as possible]
Launch Method: [Launch slave agents via Java Web Start]
Availability: [Keep this slave on-line as much as possible]
```
* Save the configuration
* Start the slave node

on the slave machine
```
cd /opt/boxen/repo
./start_jenkins_slave.sh [name of node you just created]
```

* Node will start and jenkins will connect to remote slave node

----
## Clean everything off the machine
The entire machine can be reset, returned to an initial state prior to Discovery install, using the following script.  This can be helpful when a machine has become unstable or needs to be repurposed.

```
cd /opt/boxen/repo
./nuke_machine.sh
```

----
### Help!
More to come later !
