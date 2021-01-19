Braintree::Configuration.environment = Rails.env.production? ? :production : :sandbox
Braintree::Configuration.merchant_id = "66gmcnn7h4crgpy7"
Braintree::Configuration.public_key = "3xgc4hxthdvg7qxx"
Braintree::Configuration.private_key = "68961e26e68d8c581272860de9fbe2c9"