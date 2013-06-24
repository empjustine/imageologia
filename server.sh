#!/bin/sh

. ~/.bashrc
devdev
cd ~/imageologia
bundle exec shotgun --server thin --port 9393 --host 0.0.0.0 sinatra-server.rb &
bundle exec ruby dicom-server.rb &
read