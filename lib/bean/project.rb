#!/usr/bin/env ruby -W

module Workspace
  TMP_DIR = File.join(Dir.pwd, '.Tmp')

  # The bean file where your actin defined.
  # Default is /your/project/root/Beanfile.
  BEAN_FILE = File.join(Dir.pwd, 'Beanfile')

  module_function

  def bean?
    File.exist?(Workspace::BEAN_FILE)
  end

  def clear
    `rm -rf #{TMP_DIR}` if Dir.exist?(TMP_DIR)
    # Dir.delete(TMP_DIR) if Dir.exist?(TMP_DIR)
  end

end