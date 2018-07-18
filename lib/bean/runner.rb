#!/usr/bin/env ruby -W

require_relative 'colored'

module Bean
  class Runner

    # exec then bean your defined in your own Beanfile.

    def exec(name)
      return init if name.to_s == 'init'
      run_bean
    end

    private 

    def run_bean
      bean_file = Workspace::BEAN_FILE
      return puts "Beanfile does not exist.".red unless Workspace.bean?
      Action::BeanAction.new(bean_file).run(name)
    end

    def init
      beanfile = Workspace::BEAN_FILE
      return puts "Beanfile already exist.".red if File.exist?(beanfile)

      File.open(beanfile, 'w') do |f|
        f.write <<-"..."
bean :dev do |c|
  c.workspace = 'YourWorkspace'
  c.scheme = 'Yourscheme'
end
        ...
      end
    end
  end
end

