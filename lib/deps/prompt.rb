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
      message =
        <<~HEREDOC

          Found a new dependant of #{@q.red}
          URL: #{@dep.url.light_blue}
          Repo: #{@dep.repo.green}

          Choose one of...
          (q)uery    Find further dependants
          (d)one     There are no further dependants
          (i)gnore   This is not a dependancy
        HEREDOC

      puts message
      capture
    end

    def capture
      case input = gets.chomp.downcase
      when "q"
        puts "\nEnter a query..."
        @dep.q = gets.chomp
      when "d"
        @dep.done!
      when "i"
        @dep.ignored!
      else
        puts "\nInvalid input: #{input}"
        puts "Choose one of (q)uery, (d)one, (i)gnore..."
        capture
      end
    end
  end
end
