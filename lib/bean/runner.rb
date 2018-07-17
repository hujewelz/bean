#!/usr/bin/env ruby -W

require_relative 'colored'

# include Action

module Bean
  class Runner
    def exec(name)
      return init if name.to_s == 'init'
      bean_file = Workspace::BEAN_FILE
      return puts "Beanfile does not exist.".red unless Workspace.bean?
      Action::BeanAction.new(bean_file).run(name)
    end

    private 

    def init
      beanfile = Workspace::BEAN_FILE
      return puts "Beanfile already exist." if File.exist?(beanfile)

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

