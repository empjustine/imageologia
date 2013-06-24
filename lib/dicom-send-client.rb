#!/usr/bin/env ruby

require 'dicom'

# DICOM Client
# ============

dicom_node = DICOM::DClient.new('0.0.0.0', 4030)

examination = ARGV[0]
if ARGV[0][/dicom_client\.rb/]
  examination = ARGV[2]
end

dicom_node.test

examination_dcm = DICOM::DObject.read(examination)
if examination_dcm.read?
  # Sends one or more DICOM files to a service class provider (SCP/PACS)
  dicom_node.send(examination)
else
  puts "Invalid DICOM."
end
