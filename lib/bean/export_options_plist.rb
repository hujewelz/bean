#!/usr/bin/env ruby -W

module ExportOptions
  class Plist
    ALL_KEYS = %w(compileBitcode method signingStyle teamID thinning)

    def initialize(name)
      @export_options_plist_file = File.join(Workspace::TMP_DIR, "#{name.to_s.capitalize}-ExportOptions.plist")

      Dir.mkdir(Workspace::TMP_DIR) unless Dir.exist?(Workspace::TMP_DIR)
      File.open(@export_options_plist_file, 'w') do |f|
        f.write <<-"..."
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
          <key>compileBitcode</key>
          <true/>
          <key>method</key>
          <string>ad-hoc</string>
          <key>signingStyle</key>
          <string>automatic</string>
          <key>stripSwiftSymbols</key>
          <true/>
          <key>thinning</key>
          <string>&lt;none&gt;</string>
        </dict>
        </plist>
        ...
      end
    end

    instance_methods.each do |m|
      undef_method m unless m.to_s =~ /^__|send|method_missing|export_options_plist_file|object_id|response_to?/
    end

    def method_missing(m, *args) 
      if m.to_s == 'export_options_plist_file'
        return @export_options_plist_file
      end
      # puts "Plist call #{m.to_s}(#{args.join(',')})"
      return unless ALL_KEYS.include? m.to_s

      plist_buddy = XcodeTool::PlistBuddy.new(@export_options_plist_file)
      plist_buddy.send m.to_sym, args.join(', ')
    end

    def self.exist?(name)
      ALL_KEYS.include?(name.to_s)
      # puts ALL_KEYS.include?(name.to_s) 
    end

    def export_options_plist_file
      @export_options_plist_file
    end
  end
end