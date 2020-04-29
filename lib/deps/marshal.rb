# frozen_string_literal: true

module Deps
  class Marshal
    class << self
      def dump(dep)
        deps = dep.deps.map { |d| dump(d) }

        {
          "repo" => dep.repo,
          "url" => dep.url,
          "q" => dep.q,
          "deps" => deps
        }
      end

      def load(hash)
        Deps::Dep.new(
          hash["repo"],
          hash["url"],
          hash["q"]
        )
      end
    end
  end
end
