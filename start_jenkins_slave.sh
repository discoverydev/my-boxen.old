#!/bin/sh

echo "* starting jenkins slave"
javaws https://jenkins:8443/computer/`hostname -s`/slave-agent.jnlp
