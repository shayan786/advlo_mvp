if Rails.env == 'development'
  Rails.configuration.stripe = {
      :publishable_key => 'pk_test_4KNIbgcUXuK1cAeGAoZgixpD',
      :secret_key      => 'sk_test_4KNIUb26Tb9up2etxw6Kp7mz'
  }
else
  Rails.configuration.stripe = {
      :publishable_key => ENV['PUBLISHABLE_KEY'],
      :secret_key      => ENV['SECRET_KEY']
  }
end

Stripe.api_key = Rails.configuration.stripe[:secret_key]
