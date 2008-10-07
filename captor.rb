#Shoes.setup do
#  gem 'capistrano'
#  gem 'net-ssh'
#  gem 'net-ssh-gateway'
#  gem 'highline'
#end

require 'drb'

require 'tabs'
require 'cap_client'

Shoes.app :width => 500, :height => 420 do
  capfile = Capfile.new('/Users/alex/Documents/Code/reporting/Capfile')
  projects = ['Helicoid Stats']
  
  stack do
    background black
    flow do
      title 'Captor', :weight => 'bold', :size => 22, :stroke => white
      @title_stack = flow :width => 200, :margin => 10, :margin_left => 30
    end
  end

  Tabs.create(self, @title_stack) do
    projects.each do |project_name|
      tab project_name do
        capfile.task_names.each do |task_name|
          para task_name
        end
      end
    end
  end
end