#!/usr/bin/env ruby -W

require_relative 'table'
require_relative 'colored'

module Workspace
  class Config
    attr_reader :name

    def initialize(name)
      @name = name.to_s
      @configs = {}
    end

    def method_missing(m, *args)
      # puts "config ---- method: #{m.to_s}, args: #{args}"
      name = m.to_s
      name = m.to_s.delete('=') if m.to_s =~ /=$/
      return unless %w(workspace scheme output_name compile_bitcode method signing_style team_id thinning).include? name
      if m.to_s =~ /=$/
        add_configuration(m.to_s.delete('='), args.first)
      else
        @configs[m.to_sym]
      end
    end

    # The ExportOptions Plist object.

    def export_options_plist
      get_team_identifier

      plist = ExportOptions::Plist.new(@name)
      @configs.each do | key, value |
        # puts "========= key: #{key}"
        # if ExportOptions::Plist.exist?(key)   
          # puts "call #{key.to_s}(#{value})"
          plist.send key.to_sym, value
        # end
      end
      File.join(Workspace::TMP_DIR, "#{@name.to_s.capitalize}-ExportOptions.plist")
    end

    def export_path
      path = File.join(Dir.pwd, "#{self.scheme}")
      if self.output_name 
        path = File.join(Dir.pwd, "#{self.output_name}")
      end
      return path
    end

    def to_s
      Table.new(@configs).table
    end

    private

    def get_team_identifier
      mobileprovision = File.join(File.expand_path("#{scheme}.xcarchive", Workspace::TMP_DIR), "Products/Applications/#{scheme}.app/embedded.mobileprovision")
      # puts "mobileprovision: #{mobileprovision}"
      return unless File.exist?(mobileprovision)
      team_id = XcodeTool::Mobileprovision.new(mobileprovision).team_identifier
      if team_id != ""
        @configs = {teamID: team_id.chomp} 
      end
    end

    def add_configuration(key, value)
      key = key.sub(/_\w/) { |e| e.delete('_').upcase } if key.index('_')
      key = key.gsub(/id|Id/, 'ID') if key =~ /id|Id/
      @configs[key.to_sym] = value
    end
  end
end