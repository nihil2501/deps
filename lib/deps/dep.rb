# frozen_string_literal: true

module Deps
  class Dep
    attr_reader :repo, :url
    attr_accessor :q

    def initialize(repo, url, q = nil)
      @repo = repo
      @url = url
      @q = q
    end

    def resolve
      deps.each do |dep|
        Deps::Prompt.perform(dep, q)
        dep.resolve
      end
    end

    def deps
      @deps ||=
        [].tap do |memo|
          results = Deps::Search.perform(q)
          memo.concat(results)
        end
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
