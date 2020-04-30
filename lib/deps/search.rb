# frozen_string_literal: true

require "octokit"
require "faraday-http-cache"

module Deps
  class Search
    GITHUB_ORG = "Leafly-com"
    THIS_REPO = "deps"

    class << self
      def perform(q)
        new(q).perform
      end

      def client
        unless defined? @client
          @client = Octokit::Client.new
          # Unfortunately `auto_paginate` silently stops collecting results on
          # rate limit:
          #   https://github.com/octokit/octokit.rb/blob/95603295203ad86b5e2abc4426b85111577bbc5b/lib/octokit/connection.rb#L87
          @client.auto_paginate = true

          @client.middleware.response :logger, Deps.logger, log_level: :debug
          @client.middleware.use :http_cache,
            serializer: ::Marshal,
            logger: Deps.logger,
            shared_cache: false
        end

        @client
      end
    end

    delegate :client, to: :class

    def initialize(q)
      @q = q
    end

    def perform
      memo = []
      return memo if @q.blank?

      get_items.each do |item|
        repo = item.repository
        next if repo.name == THIS_REPO

        fragments = get_fragments(item)
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
      def get_fragments(item)
        [].tap do |memo|
          item.text_matches.each do |match|
            r = /\b#{Regexp.quote(@q)}\b/
            s = match.fragment

            if s.match?(r)
              memo << s
            end
          end
        end
      end

      def get_items
        query = "#{@q} org:#{GITHUB_ORG}"
        opts = { accept: "application/vnd.github.v3.text-match+json" }

        client.
          search_code(query, opts).
          items
      end

      def get_repo(repo)
        client.repo(repo.id)
      end
  end
end
