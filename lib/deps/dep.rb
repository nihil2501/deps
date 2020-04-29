# frozen_string_literal: true

module Deps
  class Dep
    attr_reader :repo, :url
    attr_accessor :q

    def initialize(repo, url, q)
      @repo = repo
      @url = url
      @q = q
    end

    def resolve
      deps.each do |dep|
        dep.q ||= Deps::Prompt.perform(dep, q)
        dep.resolve
      end
    end

    def deps
      @deps ||=
        [].tap do |memo|
          results = Deps::Search.perform(q, exclude: repo)
          memo.concat(results)
        end
    end
  end
end
