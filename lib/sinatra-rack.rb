#!/usr/bin/env ruby

require 'sinatra'


# Sinatra
# =======

SINATRA_ROOT = File.expand_path(
    File.dirname(
        __FILE__[%r{^(.*)/.*$},1]
    )
)
puts "SINATRA_ROOT => #{SINATRA_ROOT}"
set :root, SINATRA_ROOT

set :bind, '0.0.0.0'
set :port, 9393

# Rack
# ====

use Rack::Session::Cookie, {
  :key =>          'picopacs.org',
 #:domain =>       'picopacs.org',
  :path =>         '/',
  :expire_after => 2592000, # In seconds
  :secret =>       'picopacs.secret'
}

use Rack::Auth::Basic, 'picopacs' do |username, password|
  username == '1' && password == '1'
end
