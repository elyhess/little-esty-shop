
# Braintree::Configuration.environment = Rails.env.development? ? ENV['BRAINTREE_ENVIRONMENT'] : :development

if Rails.env.development?
	Braintree::Configuration.environment = :sandbox
elsif Rails.env.production?
	Braintree::Configuration.environment = :sandbox
else
	Braintree::Configuration.environment = :development
end

Braintree::Configuration.logger = Logger.new('log/braintree.log')
Braintree::Configuration.merchant_id = ENV['BRAINTREE_MERCHANT_ID']
Braintree::Configuration.public_key = ENV['BRAINTREE_PUBLIC_KEY']
Braintree::Configuration.private_key = ENV['BRAINTREE_PRIVATE_KEY']