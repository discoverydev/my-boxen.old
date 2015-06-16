#!/bin/sh

echo "* starting jenkins slave"
javaws http://192.168.8.4:8080/computer/osxhost/slave-agent.jnlp 2>&1
