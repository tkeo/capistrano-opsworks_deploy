require 'capistrano'
require "capistrano/opsworks_deploy/version"

load File.expand_path('../tasks/opsworks.rake', __FILE__)
