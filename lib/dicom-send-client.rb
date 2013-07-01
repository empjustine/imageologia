#!/usr/bin/env ruby

require 'dicom'

# DICOM Client
# ============


if ARGV[0][/dicom_client\.rb/]
  ARGV.shift
  ARGV.shift
end
host = ARGV.shift
ARGV.each do |examination|

  examination_object = DICOM::DObject.read(examination)
  unless examination_object.read?
    puts "Invalid DICOM @ #{examination}"
    next
  end

  dicom_node = DICOM::DClient.new(host, 11112)
  #dicom_node.test
  dicom_node.send(examination)
end
