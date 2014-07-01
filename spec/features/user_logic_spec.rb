require 'rails_helper'

feature "user logic for adventure flow", :js => true do

  scenario 'no user' do 
    visit '/'
    visit '/adventures/create_prefill'
    expect(page).to have_content('Sign In')
  end

  scenario 'creates a user & logs them in && Lets a user update profile to host' do 
    #test email validation & signup
    visit '/'
    visit '/adventures/create_prefill'
    click_link ('Sign up')
    expect(page).to have_content('Sign Up')
    fill_in 'Email Address',  with: 'test@advlo.com'
    fill_in 'Password',  with: 'nopass'
    fill_in 'Confirm Password',  with: 'nopass'
    click_button "Sign Up"
    expect(page).to have_content('Password is too short (minimum is 8 characters)')
    fill_in 'Email Address',  with: 'test@advlo.com'
    fill_in 'Password',  with: 'password'
    fill_in 'Confirm Password',  with: 'password'
    click_button "Sign Up"
    expect(page).to have_content('My Profile')
  
    #Make sure user needs to fill out data to create adv.
    visit '/adventures/create_prefill'
    sleep 1
    expect(page).to have_content('Please complete your profile so travelers know more about their host!')
    sleep 1
    visit '/users/dashboard' 
    expect(page).to have_content("You don't have any adventures yet!")
    fill_in 'Name', with: 'Topher'
    fill_in 'Short Description', with: 'Anthropologist programmer'
    fill_in 'Location', with: 'Denver'
    fill_in 'user[dob]', with: DateTime.parse('Mon, 05 Feb 1990')
    fill_in "What's your story?", with: 'I once put out a fire. But I actually had started it'
    fill_in 'Languages', with: 'Frenglish, ebonics, hebrew'
    fill_in 'Have specialized training or skills?', with: 'Denver, Colorado'
    attach_file('user_avatar', File.join(Rails.root, '/spec/support/example.jpg'))
    click_button 'UPDATE'
    expect(page).to have_content 'You updated your account successfully.'
    #updates to host capability

    visit '/adventures/new'
    current_url.should == '/adventures/new'
    fill_in 'adventure[title]', with: 'Underwater Basket-Weaving'
    fill_in 'adventure[location]', with: 'Denver, Co'
    fill_in 'adventure[summary]', with: 'EXTREME UNDERWATER BASKET WEAVING'
    fill_in 'adventure[location]', with: 'Denver, Co'
    fill_in 'adventure[cap_min]', with: 1
    fill_in 'adventure[cap_max]', with: 10
    fill_in 'adventure[duration_num]', with: 4
    fill_in 'adventure[duration_type]', with: 'Hours'
    fill_in 'adventure[category]', with: 'Skiing'
    sleep 1
    attach_file('adventure[attachment]', File.join(Rails.root, '/spec/support/example.jpg'))
    sleep 1
    click_button 'NEXT'
  end
end