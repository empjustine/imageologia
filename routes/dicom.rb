#!/usr/bin/env ruby

require 'dicom'
require 'RMagick'

require 'base64'
require 'digest/sha2'


# DICOM Routes
# ============


DICOM_CATEGORIES = [
  'Acquisition Date',
  #'Instance Creation Time',
  'Modality',
  'Study Description',
  'Manufacturer',
  'Manufacturer\'s Model Name',
  #'Institutional Department Name',
  #'Patient\'s Name',
  'Rows',
  'Columns',
  'Number of Frames',
  'Pixel Aspect Ratio',
  'Bits Stored',
  :data_uri,
]



get '/dicom' do

  examinations = cryptographic_hashes(:refresh => params['refresh']).map { |filename, cryptographic_hash|
    examination = extract_dicom(filename)
    if examination
      data = examination.to_hash
      data[:data_uri] = data_uri(cryptographic_hash, :thumbnails => true)
      
      [data, cryptographic_hash]
    end
  }.compact

  erb :dicom_index, :locals => {
    :title  => 'DICOM Listing',
    :navbar => {
      :links => {
        'Start' => '/',
        'DICOM Listing' => '/dicom',
      },
      :active => 'DICOM Listing',
    },
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
      
      [data, data_uri(cryptographic_hash)]
    else
      [nil, nil]
    end
  }

  erb :dicom_file, :locals => {
    :title  => 'DICOM Listing',
    :navbar => {
      :links => {
        'Start' => '/',
        'DICOM Listing' => '/dicom',
      },
      :active => params[:cryptographic_hash],
    },
    :image => file.first.last,
    :metadata => JSON.pretty_generate(file.first.first),
  }
end

get '/dicom/:cryptographic_hash/file/:file' do
  file = cryptographic_hashes.select { |filename, cryptographic_hash|
    cryptographic_hash == params[:cryptographic_hash]
  }

  send_file file.first.first
end