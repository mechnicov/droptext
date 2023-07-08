module Snippets
  class Validate < BaseOperation
    def call(input)
      validation = SnippetSchema.(input[:params])

      if validation.success?
        Success(params: validation.to_h)
      else
        Failure(errors: validation.errors.to_h.values.flatten)
      end
    end
  end
end
