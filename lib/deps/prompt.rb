# frozen_string_literal: true

require "colorize"

module Deps
  module Prompt
    class << self
      def perform(dep, q)
        message =
          <<~HEREDOC

            Found a new dependant of #{q.red}: #{dep.repo.green}
            To find a further dependency query, visit: #{dep.url.light_blue}
            Then enter it here (leave blank to ignore):
          HEREDOC

        puts message
        gets.chomp.presence
      end
    end
  end
end
