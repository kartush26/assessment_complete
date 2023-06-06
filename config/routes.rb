Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'shortened_urls#new'

  get "/shortened_urls/shortened", to: "shortened_urls#shortened", as: 'shortened'
  get "/shortened_urls/redirect_to_original_url"
  post "/shortened_urls/create", to: "shortened_urls#create", as: "shortened_url"
end
