#!/usr/bin/env ruby -W

require_relative 'colored'

# include Action

module Bean
  class Runner
    def init
      beanfile = Workspace::BEAN_FILE
      return puts "Beanfile already exist." if File.exist?(beanfile)
      
      File.open(beanfile, 'w') do |f|
        f.write <<-"..."
        bean :dev do |a|
          a.workspace = '<Your Workspace>'
          a.scheme = '<Your scheme>'
        end
        ...
      end
    end

    def exec(name)
      if name.to_s == 'init'
        init
      end
      bean_file = Workspace::BEAN_FILE
      # puts "Beanfile: #{bean_file}"

      unless Workspace.bean?
        puts "Beanfile does not exist.".red
        return
      end
      
      Action::BeanAction.new(bean_file).run(name)
    end
  end
end

