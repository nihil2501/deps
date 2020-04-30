# frozen_string_literal: true

require "colorize"

module Deps
  class Prompt
    class << self
      def perform(dep, q)
        new(dep, q).perform
      end
    end

    def initialize(dep, q)
      @dep = dep
      @q = q
    end

    def perform
      fragments =
        @dep.fragments.map.with_index do |fragment, i|
          <<~HEREDOC
            \s\s#{"Fragment #{i+1}".underline}
            \s\s#{fragment.gsub("\n", "\n\s\s").italic}
          HEREDOC
        end

      message =
        <<~HEREDOC
          \nFound a new dependant of #{@q.light_red.bold}

          #{fragments.join("\n\n")}

          URL: #{@dep.url.light_blue}
          Repo: #{@dep.repo.light_green.bold}

          #{menu.chomp}
        HEREDOC

      puts message
      capture
    end

    def capture
      case input = gets.chomp.downcase
      when Deps::Prompt::Actions::QUERY.input
        puts "\nEnter a query..."
        @dep.q = gets.chomp
      when Deps::Prompt::Actions::DONE.input
        @dep.done!
      when Deps::Prompt::Actions::IGNORE.input
        @dep.ignored!
      else
        puts "\n#{menu}"
        capture
      end
    end

    def menu
      actions = Deps::Prompt::Actions::ALL
      actions = actions.map(&:full_prompt)

      <<~HEREDOC
        Choose one of...
        #{actions.join("\n")}
      HEREDOC
    end
  end
end
