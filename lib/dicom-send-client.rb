#!/usr/bin/env ruby

require 'dicom'

# DICOM Client
# ============


host = ARGV[0]
examination = ARGV[1]
if ARGV[0][/dicom_client\.rb/]
  host = ARGV[2]
  examination = ARGV[3]
end

dicom_node = DICOM::DClient.new(host, 11112)

dicom_node.test

examination_dcm = DICOM::DObject.read(examination)
if examination_dcm.read?
  # Sends one or more DICOM files to a service class provider (SCP/PACS)
  dicom_node.send(examination)
else
  puts "Invalid DICOM."
end
