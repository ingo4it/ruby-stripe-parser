Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  post '/stripe/webhook' => 'stripe#webhook'
end
