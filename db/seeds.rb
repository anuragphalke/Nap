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

# List of appliances to seed

User.destroy_all
puts "All users have been destroyed!"

AllAppliance.destroy_all
puts "All appliances have been destroyed!"
UserAppliance.destroy_all
puts "All user appliances have been destroyed!"

# Create a user
user = User.create!(
  email: "user@example.com",
  username: "testuser",
  password: "Aa123456"
)
puts "Seeded #{user.username} user"

# Create all appliances
appliances = [
  AllAppliance.create!(model: 'LG123', brand: 'LG', category: 'kitchen', subcategory: 'Oven', wattage: 2000),
  AllAppliance.create!(model: 'Bosch567', brand: 'Bosch', category: 'laundry', subcategory: 'Washing Machine', wattage: 1500),
  AllAppliance.create!(model: 'SamsungX90', brand: 'Samsung', category: 'entertainment', subcategory: 'TV', wattage: 100),
  AllAppliance.create!(model: 'DysonCool', brand: 'Dyson', category: 'climate control', subcategory: 'Air Conditioner', wattage: 2200),
  AllAppliance.create!(model: 'TeslaChg', brand: 'Tesla', category: 'EV charger', subcategory: 'EV Charger', wattage: 7200),
  AllAppliance.create!(model: 'LG2207', brand: 'LG', category: 'kitchen', subcategory: 'Oven', wattage: 2200),
  AllAppliance.create!(model: 'WhirlpoolDry', brand: 'Whirlpool', category: 'laundry', subcategory: 'Dryer', wattage: 2500)
]

# Assign three appliances to the user
UserAppliance.create!([
  { user: user, all_appliance: appliances[0] },
  { user: user, all_appliance: appliances[1] },
  { user: user, all_appliance: appliances[2] }
])

puts "Seeding completed! Created 1 user, 6 appliances, and 3 user appliances."
