#!/usr/bin/env ruby

require 'dicom'


# DICOM Service Class Provider storage node
# =========================================

# port 104 is default
# port 4030 is linux default
DICOM_SERVER = DICOM::DServer.run(4030, './dicom/') { |server|
  # Application Entity
  server.host_ae = 'PICOPACS'
}
