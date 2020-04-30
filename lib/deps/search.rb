# frozen_string_literal: true

require "octokit"

module Deps
  module Search
    GITHUB_ORG = "Leafly-com"
    GITHUB_TOKEN = ENV["GITHUB_TOKEN"]
    THIS_REPO = "deps"

    class << self
      def perform(q)
        memo = []
        return memo if q.blank?

        search(q).items.each do |item|
          repo = item.repository
          next if repo.name == THIS_REPO

          fragments = get_fragments(item, q)
          next if fragments.empty?

          repo = get_repo(repo)
          next if repo.archived

          dep = Deps::Dep.new(repo.name, item.html_url)
          dep.fragments = fragments
          memo << dep
        end

        memo
      end

      private
        def get_fragments(item, q)
          [].tap do |memo|
            item.text_matches.each do |match|
              r = /\b#{Regexp.quote(q)}\b/
              s = match.fragment

              if s.match?(r)
                memo << s
              end
            end
          end
        end

        def search(q)
          q = "#{q} org:#{GITHUB_ORG}"
          opts = {
            accept: "application/vnd.github.v3.text-match+json",
            per_page: 100 # github's max
          }

          client.search_code(q, opts).tap do
            rel = client.last_response.rels[:next]
            if rel.present?
              raise \
                RuntimeError,
                "Too many results"
            end
          end
        end

        def get_repo(repo)
          client.repo(repo.id)
        end

        def client
          unless defined? @client
            @client = Octokit::Client.new(access_token: GITHUB_TOKEN)
            # @client.middleware.response :logger
          end

          @client
        end
    end
  end
end
