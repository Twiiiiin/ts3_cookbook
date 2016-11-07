#
# Cookbook Name:: ts3_test
# Recipe:: default
#
# Copyright (c) 2016 Twin, All Rights Reserved.

# This cookbook will install and configure a Teamspeak 3 server on the machine, with dependencies and configurations. 
# Made for Debian. Tested on debian.

log "Adding User teamspeak"

user 'teamspeak' do
	comment 'teamspeak user'
	home '/home/teamspeak'
	manage_home true
	shell '/bin/bash'
	password 'bacinellavolante'
end

log "Downloading teamspeak"
remote_file '/home/teamspeak/teamspeak3-server_linux-amd64-3.0.11.1.tar' do
	source 'http://dl.4players.de/ts/releases/3.0.11.1/teamspeak3-server_linux-amd64-3.0.11.1.tar.gz'
	owner 'teamspeak'
	action :create
end

log "Unpacking teamspeak"

tarball_x '/home/teamspeak/teamspeak3-server_linux-amd64-3.0.11.1.tar' do
	destination '/home/teamspeak'
	owner 'teamspeak'
	action :extract
end

log "Configuring restart script"

file '/etc/init.d/teamspeak' do 
	action :create 
	content '#!/bin/sh
### BEGIN INIT INFO
# Provides: teamspeak
# Required-Start: $local_fs $network
# Required-Stop: $local_fs $network
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Description: Teamspeak 3 Server
### END INIT INFO

USER="teamspeak"
DIR="/home/teamspeak/teamspeak3-server_linux-amd64"
###### Teamspeak 3 server start/stop script ######
case "$1" in
start)
su $USER -c "$DIR/ts3server_startscript.sh start"
;;
stop)
su $USER -c "$DIR/ts3server_startscript.sh stop"
;;
restart)
su $USER -c "$DIR/ts3server_startscript.sh restart"
;;
status)
su $USER -c "$DIR/ts3server_startscript.sh status"
;;
*)
echo "Usage: " >&2
exit 1
;;
esac
exit 0'
	mode '0700'
	owner 'root'
end

service 'teamspeak' do
	action [:enable, :start]
end

log "Script is done. Success."