require 'rails_helper'
 
describe AdvloMailer do
  describe 'instructions' do
    before(:each) do 
      ActionMailer::Base.delivery_method = :test
      ActionMailer::Base.perform_deliveries = true
      ActionMailer::Base.deliveries = []

      user = User.create!(email: 'lucas@email.com', password: 'password', password_confirmation: 'password')
      AdvloMailer.welcome_email(user).deliver
    end
 
    it 'sends the welcome email' do
      ActionMailer::Base.deliveries.count == 1
      expect(ActionMailer::Base.deliveries.first.to).to eq(['lucas@email.com'])
      expect(ActionMailer::Base.deliveries.first.subject).to eq('Welcome to Adventure Local')
    end

    after(:each) do 
      ActionMailer::Base.deliveries.clear
    end
  end
end