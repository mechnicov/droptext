module Snippets
  class Create < BaseTransaction
    step :check_recaptcha, with: 'snippets.check_recaptcha'
    step :validate, with: 'snippets.validate'
    step :persist, with: 'snippets.persist'
  end
end
