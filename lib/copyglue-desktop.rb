require 'rubygems'
require 'uri'
require 'logger'
require 'yaml'
require 'singleton'
require 'json'
require 'clipboard' # Depends on Zucker and FFI gems
require 'pusher-client'

require File.join(File.dirname(File.expand_path(__FILE__)), 
                  'copyglue-desktop', 'logger')
require File.join(File.dirname(File.expand_path(__FILE__)), 
                  'copyglue-desktop', 'service')
require File.join(File.dirname(File.expand_path(__FILE__)), 
                  'copyglue-desktop', 'gui')
require File.join(File.dirname(File.expand_path(__FILE__)), 
                  'copyglue-desktop', 'application')

module CopyGlue
  module CGDesktop

    APP_NAME = "CopyGlue"
    INTERVAL = 5 # Interval in seconds to poll local clipboard
    HOMEPAGE = "http://copyglue.heroku.com/?ref=desktop"
    PUSHER_KEY = "73c70db2f09b7f279382"
    CONFIG_FILENAME = "clipsync_config.yml"
    PusherClient.logger = logger
  end
end

CopyGlue::CGDesktop.logger = Logger.new(STDOUT)
CopyGlue::CGDesktop::CGApplication.run!
