#!/bin/sh

read -p "Enter node name: " NODE_NAME

if [ -z ${NODE_NAME} ]; 
then 
  echo "NODE_NAME is unset"; 
  exit 1;
else 
  echo "NODE_NAME is set to '$NODE_NAME'"; 
fi

echo "* starting jenkins slave"
javaws http://jenkins/computer/$NODE_NAME/slave-agent.jnlp
