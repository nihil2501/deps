# frozen_string_literal: true

require "octokit"

module Deps
  module Search
    GITHUB_ORG = "Leafly-com"
    GITHUB_TOKEN = ENV["GITHUB_TOKEN"]

    class << self
      def perform(q, exclude:)
        memo = []
        return memo if q.blank?

        @github ||= Octokit::Client.new(access_token: GITHUB_TOKEN)
        results =
          @github.search_code(
            "#{q} org:#{GITHUB_ORG}",
            accept: "application/vnd.github.v3.text-match+json"
          )

        results[:items].each do |result|
          repo = result[:repository]
          next if repo[:name] == exclude

          next unless
            result[:text_matches].any? do |match|
              q.in?(match[:fragment])
            end

          repo = @github.repo(repo[:id])
          next if repo[:archived]

          memo <<
            Deps::Dep.new(
              repo[:name],
              result[:html_url],
              nil
            )
        end

        memo
      end
    end
  end
end
