#Shoes.setup do
#  gem 'capistrano'
#  gem 'net-ssh'
#  gem 'net-ssh-gateway'
#  gem 'highline'
#end

require 'drb'

require 'cap_client'
require 'project'

projects = [
  Project.new(Capfile.new('/Users/alex/Documents/Code/reporting/Capfile'), 'Helicoid Stats'),
  Project.new(Capfile.new('/Users/alex/Documents/Code/tiktrac/branch/live/Capfile'), 'Tiktrac')
]

app_width = 640

Shoes.app :width => app_width, :height => 480 do
  stack do
    background black
    flow do
      title 'Captor', :weight => 'bold', :size => 22, :stroke => white
      @title_stack = flow :width => 200, :margin => 10, :margin_left => 30
    end
  end

  @project_stack = stack :margin_top => 2, :height => -200, :scroll => true, :width => app_width
  @output_stack = stack :margin_top => 2, :height => 140, :scroll => true
  
  show_output = Proc.new do |output|
    @output_stack.clear
    @output_stack.flow do
      background white
      para code(output, :width => '100%', :height => 140)
    end
  end
  
  show_output.call "Captor Ready\n\n\n\n\n\n"
  
  project_names = projects.collect { |project| project.name }
  
  show_project = Proc.new do |project|
    @project_stack.clear
    longest_task_name = project.capfile.task_names.max { |task_name| task_name.size }.size
    task_column_width = longest_task_name * 9
    run_column_width = 50
    description_column_width = app_width - task_column_width - run_column_width - 40
    colour_state = true
    
    project.capfile.task_names.each do |task_name|
      colour = (colour_state = !colour_state) ? rgb(200, 200, 200) : white
      @project_stack.flow :margin => 0 do
        background colour
        flow :width => task_column_width do
          para task_name
        end
        flow :width => description_column_width, :align => :left, :padding => 0 do
          para project.capfile.description(task_name)
        end
        flow :width => run_column_width do
          para link('Run', :stroke => black, :fill => nil).click { show_output.call project.capfile.execute(task_name) }
        end
      end
    end
  end
  
  show_project.call(projects.first)
  
  @title_stack.list_box :items => project_names do |list|
    selected = project_names.index(list.text)
    show_project.call projects[selected]
  end
end