#!/usr/bin/env ruby -W

class String
  def method_missing(m, *args)
    color(m)
  end

  private

  def color(key)
    color_map = {
      black:     "\033[30m#{self}\033[0m", 
      red:       "\033[31m#{self}\033[0m",
      green:     "\033[32m#{self}\033[0m",
      yellow:    "\033[33m#{self}\033[0m",
      blue:      "\033[34m#{self}\033[0m",
      purple:    "\033[35m#{self}\033[0m",
      darkgreen: "\033[36m#{self}\033[0m",
      white:     "\033[37m#{self}\033[0m",
    }
    color_map[key]
  end

end