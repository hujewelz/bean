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
      # puts "config ---- method: #{m.to_s}, args: #{@configs}"
      name = m.to_s
      name = m.to_s.delete('=') if m.to_s =~ /=$/
      return unless %w(workspace scheme output_name compile_bitcode method signing_style team_id thinning).include? name
      if m.to_s =~ /=$/
        add_configuration(name, args.first)
      else
        get_configuration(m.to_s)
      end
    end

    # The ExportOptions Plist object.

    def export_options_plist
      return nil unless get_team_identifier

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
      path = File.join(Dir.pwd, "#{self.scheme}-Archived")
      if self.output_name 
        path = File.join(Dir.pwd, "#{self.output_name}-Archived")
      end
      @configs[:exportPath] = path
      return path
    end

    def to_s
      Table.new(@configs).table
    end

    private

    def get_team_identifier
      application_path = File.join(File.expand_path("#{scheme}.xcarchive", Workspace::TMP_DIR), "Products/Applications") 
      # puts application_path.red
      return nil unless File.exist?(application_path)
      mobileprovision = File.join(Dir.glob("#{application_path}/*.app").first, 'embedded.mobileprovision')
      return nil unless File.exist?(mobileprovision)

      # puts "mobileprovision: #{mobileprovision}".red
      team_id = XcodeTool::Mobileprovision.new(mobileprovision).team_identifier
      @configs[:teamID] = team_id.chomp 
    end

    def add_configuration(key, value)
      key = key.sub(/_\w/) { |e| e.delete('_').upcase } if key.index('_')
      key = key.gsub(/id|Id/, 'ID') if key =~ /id|Id/
      @configs[key.to_sym] = value
    end

    def get_configuration(key)
      key = key.sub(/_\w/) { |e| e.delete('_').upcase } if key.index('_')
      key = key.gsub(/id|Id/, 'ID') if key =~ /id|Id/ 
      @configs[key.to_sym]
    end
  end
end