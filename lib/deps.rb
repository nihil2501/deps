# frozen_string_literal: true

require "rubygems"
require "bundler/setup"
require "pry"
require "active_support"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/object/inclusion"

require 'dotenv'
Dotenv.load

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "deps/dep"
require "deps/search"
require "deps/prompt"
require "deps/marshal"

require "json"

file = ARGV[0]
ARGV.clear
if file.nil?
  raise \
    ArgumentError,
    "Must pass a file"
end

dep = File.read(file)
dep = JSON.load(dep)
dep = Deps::Marshal.load(dep)

dep.resolve

dep = Deps::Marshal.dump(dep)
dep = JSON.dump(dep)
File.write(file, dep)
