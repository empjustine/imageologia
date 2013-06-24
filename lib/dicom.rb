#!/usr/bin/env ruby

require 'dicom'


# DICOM Helpers
# =============

# dicom/PatientID/StudyDate/CR/A_DCM
DICOM_PATH = "#{SINATRA_ROOT}/dicom/*/*/*/*"


def data_uri(examination, alt='data_uri')

  image = examination.image(:rescale => true)
  unless image
    image = Magick::ImageList.new
    image.new_image(0,0) {
      self.background_color = "black"
    }
  end
  raw_png = image.to_blob { |attrs| attrs.format = 'PNG' }
  data_uri = Base64.strict_encode64(raw_png)
  return "<img alt=\"#{alt}\" src=\"data:image/png;base64,#{data_uri}\">"
end


def cryptographic_hashes

  return Dir[DICOM_PATH].map { |examination_file|

    cryptographic_hash = Digest::SHA2.new

    File.open(examination_file, 'r') { |f|
      while buffer = f.read(1024)
        cryptographic_hash << buffer
      end
    }

    [examination_file, cryptographic_hash.to_s]
  }
end


def extract_dicom(examination_file)

    examination = DICOM::DObject.read(examination_file)
    return (examination.read?) ? examination : nil
end
