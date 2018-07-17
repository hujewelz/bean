#!/usr/bin/env ruby -W

require_relative 'colored'

# include Action

module Bean
  class Runner
    def exec(name)
      bean_file = Workspace::BEAN_FILE
      puts "Beanfile: #{bean_file}"

      unless Workspace.bean?
        puts "BeanFile does not exist.".red
        return
      end
      
      Action::BeanAction.new(bean_file).run(name)
    end
  end
end

