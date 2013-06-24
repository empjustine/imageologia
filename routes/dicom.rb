#!/usr/bin/env ruby

require 'dicom'
require 'RMagick'

require 'base64'
require 'digest/sha2'


# DICOM Routes
# ============


DICOM_CATEGORIES = [
  'Acquisition Date',
  'Instance Creation Time',
  'Modality',
  'Manufacturer',
  'Manufacturer\'s Model Name',
  #'Institutional Department Name',
  'Patient\'s Name',
  'Rows',
  'Columns',
  'Pixel Aspect Ratio',
  'Bits Stored',
  :data_uri,
]



get '/dicom' do

  examinations = cryptographic_hashes.map { |filename, cryptographic_hash|
    examination = extract_dicom(filename)
    if examination
      data = examination.to_hash
      data[:data_uri] = data_uri(examination)
      
      [data, cryptographic_hash]
    end
  }.compact

  erb :dicom_index, :locals => {
    :title  => 'DICOM Listing',
    :bootstrap => {:navbar => true},
    :categories => DICOM_CATEGORIES,
    :cryptographic_hashes => examinations.map { |e| e[1] },
    :examinations => examinations.map { |e| DICOM_CATEGORIES.map { |k| e[0][k] } },
  }
end

get '/dicom/:cryptographic_hash' do
  file = cryptographic_hashes.select { |filename, cryptographic_hash|
    cryptographic_hash == params[:cryptographic_hash]
  }.map { |filename, cryptographic_hash|
    examination = extract_dicom(filename)
    if examination
      data = examination.to_hash
      
      [data, data_uri(examination)]
    else
      [nil, nil]
    end
  }

  erb :dicom_file, :locals => {
    :title  => 'DICOM Listing',
    :bootstrap => {:navbar => true},
    :image => file.first.last,
    :metadata => JSON.pretty_generate(file.first.first),
  }
end

get '/dicom/:cryptographic_hash/:cryptographic_hash' do
  file = cryptographic_hashes.select { |filename, cryptographic_hash|
    cryptographic_hash == params[:cryptographic_hash]
  }

  send_file file.first.first
end