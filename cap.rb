class Capfile
  attr_accessor :config
  
  def initialize(file)
    Dir.chdir(File.dirname(file)) do
      @config = Capistrano::Configuration.new
      @config.load(file)
    end
  end
  
  def task_names
    config.task_list(:all).collect { |t| t.fully_qualified_name }
  end
end
