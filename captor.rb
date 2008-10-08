#Shoes.setup do
#  gem 'capistrano'
#  gem 'net-ssh'
#  gem 'net-ssh-gateway'
#  gem 'highline'
#end

require 'drb'

require 'cap_client'
require 'project'
require 'config'

class Projects
  def initialize
    Settings.app_name = 'Captor'
    @projects = []
    @projects = Settings.load.collect do |name, capfile|
      Project.new name, Capfile.new(capfile)
    end
  end

  def all
    @projects
  end
  
  def names
    all.collect { |project| project.name }
  end
  
  def add(project)
    @projects << project
  end
  
  def list=(project_list)
    @project_list = project_list
  end
  
  def list
    @project_list
  end
  
  def update_list
    @project_list.items = names
    Settings.save @projects.collect { |project| [project.name, project.capfile.file_name] }
  end
  
  def selected
    @projects[names.index(@project_list.text)]
  end
  
  def selected_index
    names.index(@project_list.text)
  end
  
  def remove
    @projects.delete_at selected_index
    update_list
  end
end

Shoes.app :width => 640, :height => 480 do
  @projects = projects = Projects.new
  
  def show_project(project)
    return if @projects.all.size == 0
    
    @project_stack.clear
    longest_task_name = project.capfile.task_names.max { |task_name| task_name.size }.size
    task_column_width = longest_task_name * 9
    run_column_width = 50
    description_column_width = width() - task_column_width - run_column_width - 40
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
          para link('Run', :stroke => black, :fill => nil).click { show_output project.capfile.execute(task_name) }
        end
      end
    end
  end

  def show_output(output)
    @output_stack.clear
    @output_stack.flow do
      background white
      para code(output, :width => '100%', :height => 140)
    end
  end

  stack do
    background black
    flow do
      title 'Captor', :weight => 'bold', :size => 22, :stroke => white
      flow :width => 200, :margin => 10, :margin_left => 30 do
        projects.list = list_box :items => projects.names, :width => 180 do |list|
          selected = projects.names.index(list.text)
          show_project projects.all[selected]
        end
      end
      flow :width => 200, :margin => 10 do
        button 'Add' do
          window :width => 340, :height => 260 do
            stack do
              background black
              title 'Add Project', :weight => 'bold', :size => 22, :stroke => white
            end
            stack :margin => 10 do
              para 'Name: '
              edit_line { |line| @name = line.text }
            end
            flow :margin => 10 do
              para 'Capfile: '
              button 'Open' do
                @capfile = ask_open_file
              end
            end
            flow :margin_left => 8 do
              button 'Save' do
                if @capfile.nil? or !File.exists?(@capfile)
                  alert "Error: Please enter a valid filename for your Capfile"
                elsif @name.nil?
                  alert "Error: Please enter a project name"
                else
                  projects.add Project.new(@name, Capfile.new(@capfile))
                  projects.update_list
                  close
                end
              end
              button 'Cancel' do
                close
              end
            end
          end
        end
        
        button 'Remove' do
          if confirm("Are you sure?")
            projects.remove
            show_project projects.selected
          end
        end
      end
    end
  end

  @project_stack = stack :margin_top => 2, :height => -200, :scroll => true, :width => width()
  @output_stack = stack :margin_top => 2, :height => 140, :scroll => true
  
  show_output "Captor Ready\n\n\n\n\n\n"
  show_project projects.all.first
end