#!/bin/sh

echo "* starting jenkins slave"
javaws http://jenkins/computer/`hostname -s`/slave-agent.jnlp
