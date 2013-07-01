#!/usr/bin/env ruby

require 'json'


# Debug
# =====

get '/debug/session' do
  session.to_json
end

get '/debug/teapot' do
  status 418
  headers \
    "Allow"   => "BREW, POST, GET, PROPFIND, WHEN",
    "Refresh" => "Refresh: 20; http://www.ietf.org/rfc/rfc2324.txt"
  body "I'm a tea pot!"
end


get '/debug/params' do
  params.to_json
end


get '/debug/request' do
  obj = {
    :env  => request.env,
    :body => request.body,
    :host => request.host,
  }

  erb :dicom_file, :locals => {
    :title  => 'DEBUG',
    :image => nil,
    :metadata => JSON.pretty_generate(obj),
  }
end
