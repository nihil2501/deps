#!/usr/bin/env ruby

$LOAD_PATH.unshift File.expand_path("lib", __dir__)
require "deps"

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
dep = JSON.pretty_generate(dep) + "\n"
File.write(file, dep)
