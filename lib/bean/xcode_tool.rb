#!/usr/bin/env ruby -W
# encoding: utf-8

module XcodeTool
  class PlistBuddy 
    def initialize(file)
      @plist_file = file
    end

    instance_methods.each do |m|
      undef_method m unless m.to_s =~ /^__|send|method_missing|object_id|response_to?/
    end

    def method_missing(m, *args) 
      # puts "PlistBuddy call #{m.to_s}, args: #{args}"
      # return unless m.to_s.include?('=')

      key = m.to_s
      format_plist(key, args)
    end

    def exit?(key)
      system "/usr/libexec/PlistBuddy -c 'Print :#{key}' #{@plist_file} > /dev/null 2>&1"
    end

    private 

    # Format the PlistBuddy commad. 
    # Set <Entry> <Value> - Sets the value at Entry to Value
    # Add <Entry> <Type> [<Value>] - Adds Entry to the plist, with value Value 
    def format_plist(key, *args)
      # Example:
      # team_id => teamID

      # Replace the `_` with upcase letter. 
      key = key.sub(/_\w/) { |e| e.delete('_').upcase } if key.index('_')
  
      # If key contain `id` or `Id`, replace it with `ID`
      key = key.gsub(/id|Id/, 'ID') if key =~ /id|Id/

      puts "#{key} #{args}"

      _args = args.join().split(", ")
      key = key.delete('=') if key.index('=')      
      name = exit?(key) ? 'Set' : 'Add'
      # type = _args.length > 1 ? _args[1] : 'string'
      case _args.first
      when String
        type = 'string'
      when Numeric
        type = 'integer'
      when Array
        type = 'array'
      when Hash
        type = 'dict'
      when TrueClass
        type = 'bool'
      when FalseClass
        type = 'bool'
      else
        type = 'string'
      end
      command(name, key, _args.first, type)
    end

    # execute the PlistBuddy command. 
    # Set <Entry> <Value> - Sets the value at Entry to Value
    # Add <Entry> <Type> [<Value>] - Adds Entry to the plist, with value Value 
    #
    # Types:
    #   string
    #   array
    #   dict
    #   bool
    #   real
    #   integer
    #   date
    #   data
    #
    # Examples:
    #   Set :CFBundleIdentifier com.apple.plistbuddy
    #     Sets the CFBundleIdentifier property to com.apple.plistbuddy
    #   Add :CFBundleGetInfoString string "App version 1.0.1"
    #     Adds the CFBundleGetInfoString property to the plist
    #   Add :CFBundleDocumentTypes: dict
    #     Adds a new item of type dict to the CFBundleDocumentTypes array
    #   Add :CFBundleDocumentTypes:0 dict
    #     Adds the new item to the beginning of the array
    #
    def command(name, key, value, type) 
      return unless %w(Add Set).include?(name)
      type = name == 'Add' ? " #{type}" : '' 
      # cmd = "/usr/libexec/PlistBuddy -c '#{name} :#{key}#{type} #{value}' #{@plist_file}"
      # puts cmd.red 
      system "/usr/libexec/PlistBuddy -c '#{name} :#{key}#{type} #{value}' #{@plist_file}"
    end

  end

  class Mobileprovision 
    def initialize(file) 
      @mobileprovision_file = file
    end

    def method_missing(m, *args)
      return if m.to_s =~ /=$/
      key = m.to_s.split(/_/).map { |e| e.capitalize }.join('')
      value_from_plist(key)
    end

    def info 
      system "security cms -D -i #{@mobileprovision_file}"
    end

    def team_identifier
      value_from_plist('Entitlements:com.apple.developer.team-identifier')
    end

    # Get value form Mobileprovision file.
    def value_from_plist(key)
      `/usr/libexec/PlistBuddy -c 'Print :#{key}' /dev/stdin <<< $(security cms -D -i #{@mobileprovision_file})`
    end

  end
end

