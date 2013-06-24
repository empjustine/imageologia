#!/usr/bin/env ruby

require './routes/dicom'

# Core Routes
# ===========

get '/' do
  erb :index, :locals => {
    :title  => 'Index',
    :bootstrap => {:navbar => true},
  }
end
