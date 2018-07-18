#!/usr/bin/env ruby -W

module Action
  class BeanAction
    def initialize(bean_file)
      @bean_file = bean_file
      define_bean_action
    end

    private

    def define_bean_action
      configs = {}
      Kernel.send :define_method, :bean do |name, &block|
        config = Workspace::Config.new(name)
        block.call(config)
        configs[name.to_sym] = config
      end

      load @bean_file

      BeanAction.send :define_method, :run do |name|
        return puts "The action `#{name}` does not exist" unless config = configs[name.to_sym]
        XcodeBuilder::Archiver.archive(config) 
      end
    end
  end
end