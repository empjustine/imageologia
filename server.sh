#!/bin/sh

. ~/.bashrc
devdev
cd ~/imageologia
bundle exec shotgun sinatra-server.rb &
bundle exec ruby dicom-server.rb &
read