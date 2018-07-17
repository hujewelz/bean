#!/usr/bin/env ruby -W

require_relative 'colored'
require 'time'

module XcodeBuilder
  class Archiver
    def self.archive(config)
      
      workspace = config.workspace
      scheme = config.scheme
      export_path = config.export_path
      tmp_dir = Workspace::TMP_DIR
      Dir.mkdir(tmp_dir) unless Dir.exist?(tmp_dir)

      # The archivePath is /your/project/root/.Tmp/scheme.xcarchive
      archive_path = File.expand_path("#{scheme}.xcarchive", tmp_dir)
      archive_command = "xcodebuild -workspace #{workspace} -scheme #{scheme} clean archive -archivePath #{archive_path}"
     
      begin_time = Time.now
     
      # puts archive_command.red
      return Workspace.clear unless system archive_command

      # If the ExportOptionsPlist does not exist, just return.
      return unless export_option_plist = config.export_options_plist

      # Print the config
      puts config

      export_command = "xcodebuild -exportArchive -archivePath #{archive_path} -exportPath #{export_path} -exportOptionsPlist #{export_option_plist}"
      # puts export_command.red
      return Workspace.clear unless system export_command

      Workspace.clear
      duration = (Time.now - begin_time) / 60
      puts "🎉🎉🎉 Done. It takes you #{duration.to_i.to_s.yellow} min."
    end

  end
end