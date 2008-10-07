class Capfile
  def initialize(file_name)
    DRb.start_service
    @capfile = DRbObject.new(nil, 'druby://localhost:9000')
    @file_name = file_name
  end
  
  def method_missing(method, *args)
    # Each remote method takes a file name
    @capfile.send method, @file_name
  end
end
