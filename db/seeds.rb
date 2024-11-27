# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

Appliance.destroy_all
puts "All appliances have been destroyed!"

User.destroy_all
puts "All users have been destroyed!"


# Create a sample user
user = User.create!(
  email: "user@example.com",
  username: "testuser",
  password: "Aa123456"
)

puts "Seeded #{user.username} user"
# List of appliances to seed
appliances = [
  {
    user_id: user.id,
    name: "MIELE WCB 390 WCS 125 Washing Machine",
    category: "laundry",
    wattage: 2100.0
  },
  {
    user_id: user.id,
    name: "Samsung AR12TXFYAWKNEU Air Conditioner",
    category: "climate control",
    wattage: 3500.0
  },
  {
    user_id: user.id,
    name: "Tesla Wall Connector Gen 3 EV Charger",
    category: "EV Charger",
    wattage: 11000.0
  },
  {
    user_id: user.id,
    name: "Honeywell T9 Smart Thermostat",
    category: "climate control",
    wattage: 5.0
  },
  {
    user_id: user.id,
    name: "Sony BRAVIA XR-55A80J OLED TV",
    category: "entertainment",
    wattage: 400.0
  }
]

# Seed appliances into the database
appliances.each do |appliance|
  Appliance.create!(appliance)
end

puts "Seeded #{appliances.count} appliances!"
