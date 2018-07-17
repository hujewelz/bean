#!/usr/bin/env ruby -W

require_relative 'colored'

module XcodeBuilder
  class Archiver
    def self.archive(config)
      puts config
      workspace = config.workspace
      scheme = config.scheme
      export_path = config.export_path
      tmp_dir = Workspace::TMP_DIR
      Dir.mkdir(tmp_dir) unless Dir.exist?(tmp_dir)

      # The archivePath is /your/project/root/.Tmp/scheme.xcarchive

      archive_path = File.expand_path("#{scheme}.xcarchive", tmp_dir)
      archive_command = "xcodebuild -workspace #{workspace} -scheme #{scheme} clean archive -archivePath #{archive_path}"
      # puts archive_command.red
      export_option_plist = config.export_options_plist.export_options_plist_file
      export_command = "xcodebuild -exportArchive -archivePath #{archive_path} -exportPath #{export_path} -exportOptionsPlist #{export_option_plist}"
      # puts export_command.red
      
      system archive_command
      system export_command

      Workspace.clear
    end

  end
end