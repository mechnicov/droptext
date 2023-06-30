Rails.application.routes.draw do
  root to: 'snippets#new'

  resources :s, only: %i[create show], param: :token, controller: :snippets, as: :snippets
end
