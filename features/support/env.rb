# This file provides setup and common functionality across all features.  It's
# included first before every test run, and the methods provided here can be 
# used in any of the step definitions used in a test.  This is a great place to
# put shared data like the location of your app, the capabilities you want to
# test with, and the setup of selenium.

require 'rspec/expectations'
require 'appium_lib'
require 'csv'
require 'cucumber/ast'

# Create a custom World class so we don't pollute `Object` with Appium methods
class AppiumWorld
end

platform = ENV['TEST_PLATFORM']
raise 'TEST_PLATFORM env variable is required (android|ios)' if platform.nil? || platform.empty?
appiumFile = "#{File.dirname(File.expand_path('./', __FILE__))}/#{platform}/appium.txt"
raise 'Appium config file does not exists: ' + appiumFile unless File.exists? appiumFile

# Load the desired configuration from appium.txt, create a driver then
# Add the methods to the world
caps = Appium.load_appium_txt file: appiumFile, verbose: true
Appium::Driver.new(caps)
Appium.promote_appium_methods AppiumWorld


ENV['BASE_DIR'] = File.expand_path('./', File.dirname(__FILE__)+'/../..')
module AppiumPlatforms
  attr_accessor :user
  def isIos?
    ENV['TEST_PLATFORM'] == 'ios'
  end
end

World do
  include AppiumPlatforms
  AppiumWorld.new
end

Before do |scenario|
  ignore = false
  scenario.tags.each do | tag |
    if tag.name.eql? '@'+platform+'_pending'
      puts "PENDING TAG FOUND"
      ignore = true
      break
    end
  end
  if ignore
    pending
  else
    begin
      $driver.start_driver
    rescue

    end
  end
end

After do |scenario|
  $driver.driver_quit unless scenario.tags.include? '@'+platform+'_ignore'
end

