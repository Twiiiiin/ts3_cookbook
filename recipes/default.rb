#
# Cookbook Name:: ts3_cookbook
# Recipe:: default
#
# Copyright (c) 2016 Twin, All Rights Reserved.

# This cookbook will install and configure a Teamspeak 3 server on the machine, with dependencies and configurations. 
# Made for Debian. Tested on debian. Actually works only on debian

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
	owner 'root'
	action :create
end

template '/etc/init.d/teamspeak' do
	source 'teamspeak.erb'
	mode '0700'
end

log "Unpacking teamspeak"

tarball_x '/home/teamspeak/teamspeak3-server_linux-amd64-3.0.11.1.tar' do
	destination '/home/teamspeak'
	owner 'root'
	action :extract
end

log "Configuring service"


execute 'update-rc.d teamspeak defaults'

service 'teamspeak' do
	action :start
end


log "Script is done. Success."