class Capfile
  attr_accessor :config, :file_name
  
  def initialize(file_name)
    @file_name = file_name
    
    Dir.chdir(File.dirname(file_name)) do
      @config = Capistrano::Configuration.new
      @config.load(file_name)
    end
  end
  
  def task_names
    config.task_list(:all).collect { |t| t.fully_qualified_name }
  end
  
  def description(task_name)
    config.find_task(task_name).description
  end
  
  def execute(task_name)
    io = StringIO.new
    old_stdout = $stdout
    $stdout = io

    logger = Capistrano::Logger.new(:output => io)
    config.logger = logger
    config.logger.level = Capistrano::Logger::TRACE
    config.find_and_execute_task task_name

    io.string
  ensure
    $stdout = old_stdout
  end
end
