# frozen_string_literal: true

require "rubygems"
require "bundler/setup"
require "pry"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/object/inclusion"
require "active_support/core_ext/module/delegation"

require "dotenv"
Dotenv.load

require "deps/dep"
require "deps/search"
require "deps/prompt"
require "deps/prompt/actions"
require "deps/marshal"

require "logger"

module Deps
  class << self
    def logger
      unless defined? @logger
        @logger = Logger.new(STDOUT)
        @logger.level = ENV["LOG_LEVEL"] || Logger::INFO
      end

      @logger
    end
  end
end
