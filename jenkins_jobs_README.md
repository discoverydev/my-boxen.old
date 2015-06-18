# Jenkins Job Management

This document will detail the steps required to manage the Jenkins jobs for the Discovery Development team:

During the creation of the 'Build machine', the script will pull the latest Jenkins jobs from Stash.  This repository will be cloned to the location, /Users/Shared/data/jenkins.

If changes are made to the Jenkins instance (e.g. add/changing jobs, adding/removing a slave node, etc.), these changes will be reflected within the Jenkins configuration files.  Once your changes are complete... these changes should be commited to the repository.

#### Commiting Jenkins configuration changes
##### Perform the following on the CI host machine
```
cd /Users/Shared/data/jenkins
[do the necessary git commands to 'push'... you know them !]
```
