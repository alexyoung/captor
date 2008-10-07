class Tabs
  attr_accessor :tabs, :selected, :app, :content_stack, :navigation_slot
  
  class Tab
    attr_accessor :name, :content
    
    def initialize(name, content)
      @name = name
      @content = content
    end
  end
  
  def self.create(app, navigation_slot, &tab_definitions)
    tabs = self.new(app)
    tabs.instance_eval &tab_definitions
    tabs.navigation_slot = navigation_slot
    tabs.content_stack = app.stack
    tabs.content_stack.instance_eval &tabs.selected_tab.content
    app.instance_eval &tabs.navigation(tabs)
  end
  
  def initialize(app)
    @tabs = []
    @selected = 0
    @app = app
  end
  
  def tab(name, &content)
    @tabs << Tab.new(name, content)
  end
  
  def selected_tab
    @tabs[@selected]
  end
  
  def names
    tabs.collect { |tab| tab.name }
  end
  
  def navigation(tabs)
    Proc.new do
      tabs.navigation_slot.flow do
        list_box :items => tabs.names do |list|
          tabs.selected = tabs.names.index(list.text)
          tabs.content_stack.clear
          tabs.content_stack.instance_eval &tabs.selected_tab.content
        end
      end
    end
  end
  
  def title(name)
  end
end
