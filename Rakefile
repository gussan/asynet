require "bundler/gem_tasks"

task :pry do
  $LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  require 'rubygems'
  require 'bundler'

  Bundler.setup()

  require 'asynet'
  require 'pry'

  binding.pry
end

