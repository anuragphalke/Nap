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
require "csv"





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

filepath = "db/seeds/appliances.csv"

appliances = []

CSV.foreach(filepath, headers: :first_row) do |row|
  appliances << AllAppliance.create!(category: row['category'], subcategory: row['subcategory'], brand: row['brand'], model: row['model'], wattage: row['wattage'].to_f)
end


# Assign three appliances to the user
UserAppliance.create!([
  { user: user, all_appliance: appliances[0] },
  { user: user, all_appliance: appliances[1] },
  { user: user, all_appliance: appliances[2] }
])

puts "Seeding completed! Created 1 user, all appliances, and 3 user appliances."
