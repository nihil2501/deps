# frozen_string_literal: true

module Deps
  class Marshal
    class << self
      def dump(dep)
        memo = {}
        return memo if dep.ignored?

        memo.merge!("repo" => dep.repo, "url" => dep.url)
        return memo if dep.done?

        memo.merge!("q" => dep.q, "deps" => [])
        dep.deps.each do |d|
          if d = dump(d).presence
            memo["deps"] << d
          end
        end

        memo
      end

      def load(dep)
        Deps::Dep.new(
          dep["repo"],
          dep["url"],
          dep["q"]
        )
      end
    end
  end
end
