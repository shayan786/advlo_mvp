require 'rails_helper'


describe User do
  it "orders by last name" do
    user1 = User.create!(email: "Andy@gmail.com", password: 'password', password_confirmation: 'password')
    user2 = User.create!(email: "zulu@gmail.com", password: 'password', password_confirmation: 'password')

    expect(User.first).to eq(user1)
  end
end