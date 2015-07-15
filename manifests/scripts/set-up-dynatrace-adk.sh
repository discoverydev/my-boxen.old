#! /bin/bash

if ! [[ -d /opt/dynatrace/Android/auto-instrumentor ]]; then
	wget --directory-prefix=/tmp/dynatrace "http://www.dynatrace.com/clientservices/agent?version=6.2&techtype=mobile"
	unzip /tmp/dynatrace/agent\?version=6.2\&techtype=mobile -d /tmp/dynatrace/extract

	rm -rf /opt/dynatrace/Android/auto-instrumentor
	mkdir -p /opt/dynatrace/Android
	mv /tmp/dynatrace/extract/Android/auto-instrumentor /opt/dynatrace/Android/
	rm -r /tmp/dynatrace
fi
