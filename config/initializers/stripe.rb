Rails.configuration.stripe = {
  :publishable_key => ENV['RP_STRIPE_PUBLIC_KEY'],
  :secret_key      => ENV['RP_STRIPE_SECRET_KEY']
}

Stripe.api_key = Rails.configuration.stripe[:secret_key]