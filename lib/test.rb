#!/usr/bin/env ruby -W

require_relative 'xbean'

# plist = ExportOptions::Plist.new
# plist.team_id = 'TeamIDDDD'
# plist.user_id = 'user', 'string'
# plist.compile_bitcode = 'true', 'bool'

# path = "/Users/huluobo/Developer/xiaoDian/Example/xiaoDian-Example.xcarchive/Products/Applications/xiaoDian_Example.app/embedded.mobileprovision"
# m = XcodeTool::Mobileprovision.new(path)
# puts m.team_identifier
# m.team_name
# m.info
# # m.value_from_plist('com.apple.developer.team-identifier')
# m.value_from_plist('Entitlements:com.apple.developer.team-identifier')


# Workspace.bean?
# Workspace.clear

# config = Workspace::Config.new('dev')
# config.workspace = 'Demo-workspace'
# config.scheme = 'Demo-scheme'
# config.compile_bitcode = true
# config.team_id = 'DHF3334HH'
# puts config

Bean::Runner.new.exec('dev')