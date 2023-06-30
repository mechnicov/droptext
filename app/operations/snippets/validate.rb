module Snippets
  class Validate
    include Dry::Transaction::Operation

    def call(input)
      validation = SnippetSchema.(input[:params])

      if validation.success?
        input[:params] = validation.to_h

        Success(input)
      else
        Failure(errors: validation.errors.to_h.values.flatten)
      end
    end
  end
end
