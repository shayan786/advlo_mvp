# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
Adventure.delete_all
Event.delete_all
Reservation.delete_all
HeroImage.delete_all

host = User.create!(email: 'test-host@gmail.com', password: 'password', password_confirmation: 'password', name: 'Matt Chapman', avatar_url: "http://graph.facebook.com/1480650951/picture", location: "Seattle, WA, United States", skillset: "Wilderness First Responder (WFR), PSIA Lvl. 1 Snow...", language: "English", sex: "Male", age: nil, is_guide: true, bio: "I'm a gentle giant with a knack for cooking delici...", dob: "1989-08-18", short_description: "Certified Badass", fb_url: "f", tw_url: "t", li_url: "l", stripe_recipient_id: 'rp_14Kgan4xV9NblOcwyCspCOmf', stripe_customer_id: 'cus_4PXlIYJUUZOgR0', rating: "", paypal_email: "chrisknight.mail@gmail.com" )
traveler = User.create!(email: 'test-traveler@gmail.com', password: 'password', password_confirmation: 'password', name: "Christopher Knight", avatar_url: "http://graph.facebook.com/1480650951/picture", location: "Seattle, WA, United States", skillset: "Wilderness First Responder (WFR), PSIA Lvl. 1 Snow...", language: "English", sex: "Male", age: nil, is_guide: true, bio: "I'm a gentle giant with a knack for cooking delici...", dob: "1989-08-18", short_description: "Certified Badass", fb_url: "f", tw_url: "t", li_url: "l", stripe_recipient_id: 'rp_14Kgam4xV9NblOcwAKZyv61R', stripe_customer_id: 'cus_4So1gVCc7J9wYM', rating: "", paypal_email: "chrisknight.mail@gmail.com" )

h = HeroImage.new(location: 'all', region: 'all')
h.attachment = File.open(File.join(Rails.root, 'db', 'fixtures', "test#{rand(1..4)}.jpg"))
h.save!

10.times do |i|
  puts "creating adventure #{i}"
  a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Boulder, CO. USA", city: "Boulder", state: 'Colorado', region: 'North America',country: 'United States',summary: 'this is a summary', cap_min: 1, cap_max: 10, price: 100, price_type: 'per_adventure', duration_num: 1, duration_type: 'Days', category: 'camping', other_notes: "qwer", latitude: 40.0149856, longitude: -105.2705456, published: true, approved: true)
  a.attachment = File.open(File.join(Rails.root, 'db', 'fixtures', "test#{rand(1..4)}.jpg"))
  a.save!
  UserAdventure.create!(user_id: host.id, adventure_id: a.id)
  event = Event.create!(adventure_id: a.id - 1, start_time: Time.now.advance(days: +20), end_time: Time.now.advance(days: +21), capacity: 5)

  payout = Payout.create!( status: 'Pending', user_id: 1, stripe_recipient_id: 'rp_14Kgan4xV9NblOcwyCspCOmf', stripe_transfer_id: 'tr_14KbEH4xV9NblOcwJdgM2tX7', amount: 16280.0, payout_via: 'stripe')

  if i % 2 == 0
    res = Reservation.new(adventure_id: a.id, user_id: traveler.id, total_price: a.price, host_id: host.id, stripe_recipient_id: host.stripe_recipient_id, stripe_customer_id: traveler.stripe_customer_id, event_start_time: Time.now.advance(days: -10), payout_id: nil, payout.id)
  else
    res = Reservation.new(adventure_id: a.id, user_id: traveler.id, total_price: a.price, host_id: host.id, stripe_recipient_id: host.stripe_recipient_id, stripe_customer_id: traveler.stripe_customer_id, event_start_time: event.start_time, payout_id: nil, )
  end
  res.host_fee = (res.total_price * 0.15).round(2)
  res.user_fee = (res.total_price * 0.04).round(2)
  res.save!


end
