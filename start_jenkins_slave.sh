#!/bin/sh

read -p "Enter node name: " NODE_NAME
<<<<<<< HEAD
#NODE_NAME=${NODE_NAME:-null}

echo $NODE_NAME

if [ -z "$NODE_NAME" ]; 
then 
  echo "NODE_NAME is unset or set to the empty string";
=======

if [ -z ${NODE_NAME} ]; 
then 
  echo "NODE_NAME is unset"; 
>>>>>>> 325cab130eea1af927884ba4ae5d58c737d7f2e7
  exit 1;
else 
  echo "NODE_NAME is set to '$NODE_NAME'"; 
fi

echo "* starting jenkins slave"
<<<<<<< HEAD
javaws http://192.168.8.4:8080/computer/$NODE_NAME/slave-agent.jnlp
=======
javaws http://192.168.8.4:8080/computer/$NODE_NAME/slave-agent.jnlp 2>&1
>>>>>>> 325cab130eea1af927884ba4ae5d58c737d7f2e7
