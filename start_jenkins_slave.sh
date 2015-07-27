#!/bin/sh

echo "* starting jenkins slave"
javaws http://jenkins/computer/`hostname -s`/slave-agent.jnlp
echo "* starting jenkins IOS slave"
javaws http://jenkins/computer/`hostname -s`_IOS/slave-agent.jnlp
echo "* starting jenkins ANDROID slave"
javaws http://jenkins/computer/`hostname -s`_ANDROID/slave-agent.jnlp
