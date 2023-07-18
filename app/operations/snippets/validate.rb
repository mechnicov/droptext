module Snippets
  class Validate < BaseOperation
    include Droptext::Import[create_snippet_validation: 'snippets.create_contract']

    def call(input)
      validation = create_snippet_validation.(input[:params])

      if validation.success?
        Success(params: validation.to_h)
      else
        Failure(errors: validation.errors.to_h.values.flatten)
      end
    end
  end
end
