#!/usr/bin/env ruby -W

module Action

  class BeanAction
    def initialize(bean_file)
      @bean_file = bean_file
      @configs = {}
      define_bean_action
    end

    # Run the action with action name.

    # def run(name) 
    #   puts "action name: #{name}"
    #   return puts "The action `#{name}` does not exist" unless config = @configs[name.to_sym]
    #   puts "archive info:"
    #   XcodeBuilder::Archiver.new(config)
    # end

  
    private

    def define_bean_action
      configs = {}
      Kernel.send :define_method, :bean do |name, &block|
        # yield add_config(Workspace::Config.new(name)) if block
        config = Workspace::Config.new(name)
        block.call(config)
        configs[config.name.to_sym] = config
      end

      load @bean_file

      BeanAction.send :define_method, :run do |name|
        # puts "action name: #{name}"
        return puts "The action `#{name}` does not exist" unless config = configs[name.to_sym]
        # puts "archive info:"
        XcodeBuilder::Archiver.archive(config) 
      end

    end

    def add_config(config) 
      @configs[config.name.to_sym] = archiver
    end
  end

  
end

# module Kernel
#   def bean(name, )
# end