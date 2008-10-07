require 'rubygems'
require 'capistrano'
require 'drb'
require 'cap'

class CapfileServer
  def initialize
  end
  
  def task_names(file_name)
    Capfile.new(file_name).task_names
  end
end

DRb.start_service('druby://localhost:9000', CapfileServer.new)
DRb.thread.join