#!/usr/bin/ruby -W
# encoding: utf-8

class Table

  def initialize(map)
    @map = map
    @left_dash = 10
    @right_dash = 20
  end

  def table
    r = header
    for (key, value) in @map 
      left = @left_dash - key.to_s.length
      right = @right_dash - value.to_s.length
      r << "| #{key}#{indent(left)} | #{value}#{indent(right)} |\n"
    end
    r << line
  end

  private

  def header
    max
    left = @left_dash - 3
    right = @right_dash - 5

    r = line
    r << "| Key#{indent(left)} | Value#{indent(right)} |\n"
    r << line
  end

  def max()
    keys = @map.keys.flat_map { |e| e.to_s.length }
    values = @map.values.flat_map { |e| e.to_s.length }

    @left_dash = find_largest(keys, @left_dash)
    @right_dash = find_largest(values, @right_dash)
  end

  def find_largest(arr, target)
    largest = target
    for item in arr 
      if item > largest
        largest = item 
      end
    end
    largest
  end

  def indent(n)
    " " * n if n > 0
  end

  def line 
    "+" + "-" * (@left_dash + @right_dash + 5) + "+\n"
  end
end


