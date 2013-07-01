#!/usr/bin/env ruby

require 'dicom'
require 'RMagick'


# DICOM Helpers
# =============

# dicom/PatientID/Study/Instance/DCM
DICOM_PATH = "#{SINATRA_ROOT}/dicom/*/*/*/*"
SHA2_PATH = "#{SINATRA_ROOT}/sha2/*"

THUMBNAILS_PATH = "#{SINATRA_ROOT}/public/thumbnails"

def data_uri(cryptographic_hash, opts={})

  thumbnails = opts[:thumbnails]
  alt = opts[:alt] || (thumbnails ? 'Examination Thumbnail' : 'Examination')

  examination = cryptographic_hashes.select { |filename, hash|
    hash == cryptographic_hash
  }

  if examination.size == 1
    path = "#{THUMBNAILS_PATH}/#{cryptographic_hash}"

    if thumbnails && File.exist?(path)
      return "<img alt=\"#{alt}\" src=\"/thumbnails/#{cryptographic_hash}\">"
    end

    dicom = extract_dicom examination.first.first
    images = dicom.images.map { |image|
      image.resize_to_fill!(64, 64) if thumbnails

      raw_png = image.to_blob { |attrs| attrs.format = 'PNG' }
      unless File.exist? path
        File.open(path, 'w') { |f| f.write(raw_png) }
      end

      data = Base64.strict_encode64(raw_png)
      "<img alt=\"#{alt}\" src=\"data:image/png;base64,#{data}\">"
    }

    if images.size == 0
      return "N/A"
    elsif images.size == 1 || thumbnails
      return images[0]
    else
      return erb :carousel, :layout => false, :locals => {:images => images, :id => cryptographic_hash}
    end

  else

    return "ALERT: cryptographic hash colision, or invalid links at /sha2"
  end
end


def cryptographic_hashes(opts={})

  if opts[:refresh]

    return Dir[DICOM_PATH].map { |examination_file|

      cryptographic_hash = Digest::SHA2.new

      File.open(examination_file, 'r') { |f|
        while buffer = f.read(1024)
          cryptographic_hash << buffer
        end
      }

      File.symlink examination_file, "#{SINATRA_ROOT}/sha2/#{cryptographic_hash.to_s}" rescue nil

      [examination_file, cryptographic_hash.to_s]
    }
  else
    return Dir[SHA2_PATH].map { |examination_link|
      [File.readlink(examination_link), File.basename(examination_link)]
    }
  end
end


def extract_dicom(examination_file)

    examination = DICOM::DObject.read(examination_file)
    return (examination.read?) ? examination : nil
end
