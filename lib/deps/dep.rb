# frozen_string_literal: true

module Deps
  class Dep
    attr_reader :repo, :url
    attr_accessor :q, :fragments

    def initialize(repo, url, q = nil)
      @repo = repo
      @url = url
      @q = q
    end

    def resolve
      deps.each(&:resolve)
    end

    def deps
      unless defined? @deps
        @deps = []
        Deps::Search.perform(q).each do |dep|
          clones = Deps::Prompt.perform(dep, q)
          @deps.concat(clones)
        end
      end

      @deps
    end

    module Terminations
      ALL = [
        IGNORED = :ignored,
        DONE = :done
      ].freeze
    end

    Terminations::ALL.each do |t|
      define_method(:"#{t}!") { @termination = t }
      define_method(:"#{t}?") { @termination == t }
    end
  end
end
