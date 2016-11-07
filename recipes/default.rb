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


template "teamspeak" do
	path '/etc/init.d/teamspeak'
	source 'teamspeak.erb'
	owner 'teamspeak'
	mode  '0700'
end

poise_service 'teamspeak' do
	command '/etc/init.d/teamspeak'
	user 'teamspeak'
	action :enable
end


log "Script is done. Success."