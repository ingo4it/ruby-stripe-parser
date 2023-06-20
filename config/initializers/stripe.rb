require 'stripe'

Rails.configuration.stripe = {
  public_key: ENV.fetch('STRIPE_PUBLIC_KEY', nil),
  secret_key: ENV.fetch('STRIPE_SECRET_KEY', nil),
  webhook_secret: ENV.fetch('STRIPE_WEBHOOK_SECRET', nil)
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]
