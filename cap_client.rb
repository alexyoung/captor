class Capfile
  def initialize(file_name)
    DRb.start_service
    @capfile = DRbObject.new(nil, 'druby://localhost:9000')
    @file_name = file_name
  end
  
  def task_names
    @capfile.file_name = @file_name
    @capfile.task_names
  end

  def description(task_name)
    @capfile.file_name = @file_name
    @capfile.description task_name
  end
  
  def execute(task_name)
    @capfile.file_name = @file_name
    @capfile.execute task_name
  end
end
