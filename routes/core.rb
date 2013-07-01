#!/usr/bin/env ruby

require './routes/dicom'

# Core Routes
# ===========

get '/' do
  erb :index, :locals => {
    :title  => 'Index',
    :navbar => {
      :links => {
        'Start' => '/',
        'DICOM Listing' => '/dicom',
      },
      :active => 'Start',
    },
  }
end
