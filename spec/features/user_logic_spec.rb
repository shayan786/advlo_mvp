require 'rails_helper'

feature "user logic for adventure flow", :js => true do

  scenario 'no user' do 
    visit '/'
    visit '/adventures/create_prefill'
    expect(page).to have_content('Connect With Email')
  end

  scenario 'creates user && update profile && adventure create flow' do 
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
    expect(page).to have_content('Profile')
  
    #Make sure user needs to fill out data to create adv.
    visit '/adventures/info'
    expect(page).to have_content('HOST AN ADVENTURE')

    visit '/adventures/create_prefill'
    expect(page).to have_content('Become a host so travelers know more about you')
    fill_in 'Name', with: 'Topher'
    fill_in 'Tagline', with: 'Anthropologist programmer'
    fill_in 'Location', with: 'Denver, Co'
    sleep 1
    fill_in 'user[dob]', with: "1990/02/05"
    sleep 1
    fill_in "What's your story?", with: 'I once put out a fire. But I actually had started it'
    fill_in 'Languages', with: 'Frenglish, ebonics, hebrew'
    fill_in 'Ex: Certified Scuba Diver, Wilderness First Responder', with: 'TOTES'
    attach_file('user_avatar', File.join(Rails.root, '/spec/support/example.jpg'))
    click_button 'UPDATE'
    expect(page).to have_content 'You updated your account successfully'
    #updates to host capability

    visit '/adventures/new'
    expect(current_path).to eq('/adventures/new')
    fill_in 'adventure[title]', with: 'Underwater Basket-Weaving'
    fill_in 'adventure[location]', with: 'Denver, Co'
    fill_in 'adventure[summary]', with: 'EXTREME UNDERWATER BASKET WEAVING'
    fill_in 'adventure[location]', with: 'Denver, Co'
    fill_in 'adventure[cap_min]', with: 1
    fill_in 'adventure[cap_max]', with: 10
    fill_in 'adventure[duration_num]', with: 4
    fill_in 'adventure[price]', with: 100
    choose('Per Person')
    select 'Hours', from: 'adventure[duration_type]'
    
    check('BIKING')
    check('WATER')

    attach_file('adventure[attachment]', File.join(Rails.root, '/spec/support/example.jpg'))
    click_button 'NEXT'
    expect(page).to have_content('SELECT GALLERY IMAGES')

    attach_file('images[]', File.join(Rails.root, '/spec/support/example.jpg'))
    sleep 8
    visit '/adventure_steps/itinerary?adventure_id=1'
    
    # visit "/adventure_steps/itinerary?adventure_id=1"
    expect(page).to have_content('ITINERARY')

    fill_in 'headline', with: 'Itin item 1'
    fill_in 'description', with: 'Itin item 1 description goes here WOOOFOOOOHOOOO'
    click_button 'ADD ITINERARY ITEM'

    expect(page).to have_content 'WOOOFOOOOHOOOO'
    visit '/adventure_steps/schedule?adventure_id=1'

    expect(page).to have_content 'SCHEDULE'
    Event.create(id: 1, created_at: "2014-07-10 20:13:37", updated_at: "2014-07-10 20:13:37", adventure_id: 1, start_time: "2014-07-07 15:00:00", end_time: "2014-07-08 01:00:00", capacity: nil )

    visit '/adventure_steps/payment?adventure_id=1'

    expect(page).to have_content 'PAYMENT DETAILS'
    find("#add-bank").click
    fill_in 'recipient[bank_account_name]', with: 'Justin Bieber'
    fill_in 'recipient[bank_routing_number]', with: '111000025'
    fill_in 'recipient[bank_account_number]', with: '000123456789'
    find("#add_bank_form_btn").click
    visit '/adventure_steps/publish?adventure_id=1'
    click_button "PUBLISH"
    expect(page).to have_content('PENDING APPROVAL: Well notify you when it goes live')
  end
end