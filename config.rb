require 'yaml'

class Settings
  def self.app_name=(app_name)
    @@app_name = app_name
  end

  def self.data_path(data_file_name = 'data.yml')
    if RUBY_PLATFORM =~ /win32/
      if ENV['USERPROFILE']
        if File.exist?(File.join(File.expand_path(ENV['USERPROFILE']), "Application Data"))
          user_data_directory = File.join File.expand_path(ENV['USERPROFILE']), "Application Data", @@app_name
        else
          user_data_directory = File.join File.expand_path(ENV['USERPROFILE']), @@app_name
        end
      else
        user_data_directory = File.join File.expand_path(Dir.getwd), 'data'
      end
    else
      user_data_directory = File.expand_path(File.join("~", ".#{@@app_name}"))
    end
    
    unless File.exist?(user_data_directory)
      Dir.mkdir(user_data_directory)
    end
    
    return File.join(user_data_directory, data_file_name)
  end

  def self.load
    if File.exist?(data_path)
      YAML::load(File.open(data_path, 'r'))
    else
      []
    end
  end
  
  
  def self.save(data)
    File.open(data_path, 'w') do |f|
      f.write data.to_yaml
    end
  end
end