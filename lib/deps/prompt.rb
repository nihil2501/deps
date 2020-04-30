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
          fragment.gsub!(@q, @q.bold)
          fragment.gsub!("\n", "\n\s\s")

          <<~HEREDOC
            \s\s#{"Fragment #{i+1}".underline}
            \n\s\s#{fragment}
          HEREDOC
        end

      message =
        <<~HEREDOC
          \n#{"-------------------------#{"-" * @q.size}".bold}
          \nFound a new dependant of #{@q.bold}

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
        clones = []

        loop do
          puts "\nEnter a new query (or just hit #{"ENTER".bold} when finished)..."
          new_q = gets.chomp
          if new_q.blank?
            return clones
          end

          clone = @dep.clone
          clones << clone
          clone.q = new_q
        end
      when Deps::Prompt::Actions::DONE.input
        @dep.done!
        [@dep]
      when Deps::Prompt::Actions::IGNORE.input
        @dep.ignored!
        [@dep]
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
