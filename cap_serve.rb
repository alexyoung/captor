require 'rubygems'
require 'capistrano'
require 'drb'
require 'cap'

class CapfileServer
  def initialize
  end
  
  def file_name=(file_name)
    @capfile = Capfile.new(file_name)
  end
  
  def task_names
    @capfile.task_names
  end
  
  def description(task_name)
    @capfile.description task_name
  end
  
  def execute(task_name)
    @capfile.execute task_name
  end
end

DRb.start_service('druby://localhost:9000', CapfileServer.new)
DRb.thread.join