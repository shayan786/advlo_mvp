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

AdminUser.create!(:email => 'admin@example.com', :password => 'password', :password_confirmation => 'password')

host = User.create!(email: 'h@gmail.com', password: 'password', password_confirmation: 'password', name: 'Test Host', avatar_url: "http://graph.facebook.com/1480650951/picture", location: "Seattle, WA, United States", skillset: "Wilderness First Responder (WFR), PSIA Lvl. 1 Snow...", language: "English", sex: "Male", age: 25, is_guide: true, bio: "I'm a gentle giant with a knack for cooking delici...", dob: "1989-08-18", short_description: "Certified Badass", fb_url: "f", tw_url: "t", li_url: "l", stripe_recipient_id: 'rp_14Kgan4xV9NblOcwyCspCOmf', stripe_customer_id: 'cus_4PXlIYJUUZOgR0', rating: "", paypal_email: "chrisknight.mail@gmail.com" )
traveler = User.create!(email: 't@gmail.com', password: 'password', password_confirmation: 'password', name: "Test Traveller", avatar_url: "http://graph.facebook.com/1480650951/picture", location: "Seattle, WA, United States", skillset: "Wilderness First Responder (WFR), PSIA Lvl. 1 Snow...", language: "English", sex: "Male", age: 25, is_guide: true, bio: "I'm a gentle giant with a knack for cooking delici...", dob: "1989-08-18", short_description: "Certified Badass", fb_url: "f", tw_url: "t", li_url: "l", stripe_recipient_id: 'rp_14Kgam4xV9NblOcwAKZyv61R', stripe_customer_id: 'cus_4So1gVCc7J9wYM', rating: "", paypal_email: "chrisknight.mail@gmail.com" )

h = HeroImage.new(location: 'all', region: 'all')
h.attachment = File.open(File.join(Rails.root, 'db', 'fixtures', "test#{rand(1..4)}.jpg"))
h.save!

h = HeroImage.new(location: 'all', region: 'default')
h.attachment = File.open(File.join(Rails.root, 'db', 'fixtures', "test#{rand(1..4)}.jpg"))
h.save!

30.times do |i|
  puts "creating adventure #{i}"
  # if i >= 70
  #   a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Estonia puiestee, Tallinn, Estonia", summary: "City nighttime adventure", cap_min: 1, cap_max: 20, price: 300, price_type: "per_person", duration_num: 1, duration_type: "Days", category: "hiking,other", other_notes: "mtn bike", latitude: 59.434352, longitude: 24.7513833, published: true, approved: true, city: "Tallinn", state: "Estonia", region: "Europe", rating: "", country: "Estonia", rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  # elsif i >= 67
  #   a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Paris, France", summary: "City nighttime adventure", cap_min: 1, cap_max: 20, price: 300, price_type: "per_person", duration_num: 1, duration_type: "Days", category: "hiking,other", other_notes: "mtn bike", latitude: 48.856614, longitude: 2.3522219, published: true, approved: true, city: "Paris", state: "France", region: "Europe", rating: "", country: "France", rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  # elsif i >= 66
  #   a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Porto, Portugal", summary: "City nighttime adventure", cap_min: 1, cap_max: 20, price: 300, price_type: "per_person", duration_num: 1, duration_type: "Days", category: "hiking,other", other_notes: "mtn bike", latitude: 41.1566892, longitude: -8.6239254, published: true, approved: true, city: "Porto", state: "Porto District", region: "Europe", rating: "", country: "Portugal"), rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs' 
  # elsif i >= 60
  #   a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Budapest, Hungary", summary: "City nighttime adventure", cap_min: 1, cap_max: 20, price: 300, price_type: "per_person", duration_num: 1, duration_type: "Days", category: "hiking,other", other_notes: "mtn bike", latitude: 47.497912, longitude: 19.040235, published: true, approved: true, city: "Budapest", state: "Budapest", region: "Europe", rating: "", country: "Hungary", rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  # elsif i >= 56
  #   a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Prague, Czech Republic", summary: "City nighttime adventure", cap_min: 1, cap_max: 20, price: 300, price_type: "per_person", duration_num: 1, duration_type: "Days", category: "hiking,other", other_notes: "mtn bike", latitude: 50.0755381, longitude: 14.4378005, published: true, approved: true, city: "Prague", state: "Praha", region: "Europe", rating: "", country: "Czech Republic"), rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs' 
  # elsif i >= 52
  #   a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Christchurch, Canterbury, New Zealand", summary: "City nighttime adventure", cap_min: 1, cap_max: 20, price: 300, price_type: "per_person", duration_num: 1, duration_type: "Days", category: "hiking,other", other_notes: "mtn bike", latitude: -43.5320544, longitude: 172.6362254, published: true, approved: true, city: "Christchurch", state: "Canterbury", region: "Oceania", rating: "", country: "New Zealand" ), rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs' 
  # elsif i >= 47
  #   a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Argentina, Ramos Mejía, Buenos Aires Province", summary: "City nighttime adventure", cap_min: 1, cap_max: 20, price: 300, price_type: "per_adventure", duration_num: 1, duration_type: "Days", category: "hiking,other", other_notes: "mtn bike", latitude: -34.6549073, longitude: -58.5536355, published: true, approved: true, city: "Ramos Mejía", state: "Buenos Aires Province", region: "Latin America", rating: "", country: "Argentina", rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  # elsif i >= 43
  #   a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Cabo San Lucas, Mexico", summary: "Surf lessons!", cap_min: 1, cap_max: 20, price: 40, price_type: "per_person", duration_num: 2, duration_type: "Hours", category: "camping,water,other", other_notes: "mtn bike", latitude: 22.8905327, longitude: -109.9167371, published: true, approved: true, city: "Cabo San Lucas", state: "Baja California Sur", region: "Latin America", rating: "", country: "Mexico", rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  # elsif i >= 38
  #   a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Limon, Costa Rica", summary: "Surf lessons!", cap_min: 1, cap_max: 20, price: 40, price_type: "per_person", duration_num: 2, duration_type: "Hours", category: "camping,water,other", other_notes: "mtn bike", latitude: 9.983333, longitude: -83.033333, published: true, approved: true, city: "Limon", state: "Limon", region: "Latin America", rating: "", country: "Costa Rica", rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  # elsif i >= 35
    a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Gran Pacifica Resort, Managua, Nicaragua", summary: "Surf lessons!", cap_min: 1, cap_max: 20, price: 40, price_type: "per_person", duration_num: 2, duration_type: "Hours", category: "camping,water,other", other_notes: "mtn bike", latitude: 11.9173469, longitude: -86.6081894, published: true, approved: true, city: "Gran Pacifica Resort", state: "Managua", region: "Latin America", rating: "", country: "Nicaragua", rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  if i >= 25
    a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Cape Town, Western Cape, South Africa", summary: "SA adventure tourism", cap_min: 1, cap_max: 20, price: 390, price_type: "per_person", duration_num: 6, duration_type: "Hours", category: "camping,motor,climbing,hiking", other_notes: "mtn bike", latitude: -33.9248685, longitude: 18.4240553, published: true, approved: true, city: "Cape Town", state: "Western Cape", region: "Africa", rating: "", country: "South Africa", rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  elsif i >= 23
    a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Jinja Road, Kampala, Central Region, Uganda", summary: "monkey bay", cap_min: 1, cap_max: 20, price: 78, price_type: "per_person", duration_num: 6, duration_type: "Hours", category: "motor,water,other", other_notes: "mtn bike", latitude: 0.3424916, longitude: 32.6363326, published: true, approved: true, city: "Kampala", state: "Central Region", region: "Africa", rating: "", country: "Uganda", rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  elsif i >= 20
    a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Chiang Mai Thailand", summary: "nz", cap_min: 1, cap_max: 20, price: 250, price_type: "per_person", duration_num: 6, duration_type: "Hours", category: "biking,camping,hiking", other_notes: "mtn bike", latitude: 18.787747, longitude: 98.9931284, published: true, approved: true, city: "Chiang Mai", state: "Chiang Mai", region: "Asia", rating: "", country: "Thailand", rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  elsif i >= 18
    a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Lake Taupo, Waikato, New Zealand", city: "Taupo", state: "Waikato", region: "Oceania", country: "New Zealand", summary: "nz", cap_min: 1, cap_max: 20, price: 250, price_type: "per_person", duration_num: 6, duration_type: "Hours", category: "biking,camping,hiking", other_notes: "mtn bike", latitude: -38.79029, longitude: 175.8895551, published: true, approved: true, rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  elsif i >= 14
    a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Gold Coast, Queensland, Australia", city: "Gold Coast", state: 'Gold Coast', region: 'Oceana', country: 'Australia', summary: 'this is a summary', cap_min: 1, cap_max: 10, price: 250, price_type: 'per_adventure', duration_num: 1, duration_type: 'Days', category: "biking,camping,hiking", other_notes: "Im a note!",  latitude: -28.0172605, longitude: 153.4256987, published: true, approved: true, rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  elsif i >= 9                                                                                                                                                                                                                                   
    a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Manhattan Beach, CA. USA", city: "Manhattan", state: 'California', region: 'North America', country: 'United States', summary: 'this is a summary', cap_min: 1, cap_max: 10, price: 100, price_type: 'per_adventure', duration_num: 1, duration_type: 'Days', category: 'swimming', other_notes: "Im a note!", latitude: 33.8889, longitude: -118.4053, published: true, approved: true, rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  elsif i >= 6
    a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Whistler, BC. Canada", city: "Whistler", state: 'Whistler', region: 'North America', country: 'Canada', summary: 'this is a summary', cap_min: 1, cap_max: 10, price: 25, price_type: 'per_adventure', duration_num: 1, duration_type: 'Days', category: 'camping,biking,hiking', other_notes: "Im a note!", latitude: 50.1208, longitude: -122.9544, published: true, approved: true, rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  elsif i >= 4
    a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Boulder, CO. USA", city: "Boulder", state: 'Colorado', region: 'North America', country: 'United States', summary: 'this is a summary', cap_min: 1, cap_max: 10, price: 125, price_type: 'per_adventure', duration_num: 1, duration_type: 'Days', category: 'camping,swimming', other_notes: "Im a note!", latitude: 40.0149856, longitude: -105.2705456, published: true, approved: true, rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  elsif i >= 2
    a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Vancouver, B.C. Canada", city: "Vancouver", state: 'Vancouver', region: 'North America', country: 'Canada', summary: 'this is a summary', cap_min: 1, cap_max: 10, price: 310, price_type: 'per_adventure', duration_num: 1, duration_type: 'Days', category: 'motor', other_notes: "TOtes other notes", latitude: 49.261226, longitude: -123.1139268, published: true, approved: true, rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  else
    a = Adventure.new(title: "Adventure Title #{i + 1}", location: "Ubud, Bali. Indonesia", country: "Indonesia", city: "Ubud", state: "Bali", region: "Asia", summary: 'this is a summary', cap_min: 1, cap_max: 10, price: 50, price_type: 'per_adventure', duration_num: 1, duration_type: 'Days', category: 'motor', other_notes: "TOtes other notes", latitude: -8.519268, longitude: 115.263298, published: true, approved: true, rating: '4.5', video_url: 'https://www.youtube.com/watch?v=7lchD9SW4gs')
  end

  a.attachment = File.open(File.join(Rails.root, 'db', 'fixtures', "test#{rand(1..4)}.jpg"))
  a.save!
  UserAdventure.create!(user_id: host.id, adventure_id: a.id)
  event = Event.create!(adventure_id: a.id - 1, start_time: Time.now.advance(days: -5), end_time: Time.now.advance(days: -4), capacity: 5)
  a.attachment = File.open(File.join(Rails.root, 'db', 'fixtures', "test#{rand(1..4)}.jpg"))
  a.save!

  if i >= 10
    Adventure.all.each do |adv|
      h = AdventureGalleryImage.new(adventure_id: adv.id)
      h.picture = File.open(File.join(Rails.root, 'db', 'fixtures', "test#{rand(1..4)}.jpg"))
      h.save!

      puts "... Creating gallery images"
    end
  end
end
