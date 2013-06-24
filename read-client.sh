#!/bin/sh

. ~/.bashrc
devdev
cd ~/imageologia
bx ruby lib/dicom-send-client.rb "$@"