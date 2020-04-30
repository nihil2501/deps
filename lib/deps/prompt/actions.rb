# frozen_string_literal: true

module Deps
  class Prompt
    module Actions
      struct =
        Struct.new(
          :input,
          :prompt,
          :description,
          keyword_init: true
        )

      class Action < struct
        def full_prompt
          "#{prompt} - #{description}"
        end
      end

      ALL = [
        QUERY =
          Action.new(
            input: "q",
            prompt: "#{"(q)".bold}uery",
            description: "find further dependants"
          ),

        DONE =
          Action.new(
            input: "d",
            prompt: "#{"(d)".bold}one",
            description: "there are no further dependants"
          ),

        IGNORE =
          Action.new(
            input: "i",
            prompt: "#{"(i)".bold}gnore",
            description: "this is not a dependancy"
          )
      ].freeze
    end
  end
end
