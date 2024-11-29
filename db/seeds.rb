require 'date'

# Define Categories and Subcategories
User.destroy_all
puts "Users destroyed!"
AllAppliance.destroy_all
puts "All Appliances destroyed!"
Routine.destroy_all
puts "Routines destroyed!"
UserAppliance.destroy_all
puts "User Appliances destroyed!"
Average.destroy_all
puts "Averages destroyed!"
Price.destroy_all
puts "Prices destroyed!"

# Seed users
user1 = User.create!(
  email: 'user1@example.com',
  password: 'Aassword123',
  username: 'user1'
)

user2 = User.create!(
  email: 'user2@example.com',
  password: 'Aassword123',
  username: 'user2'
)

puts "Users seeded!"

filepath = "db/seeds/appliances.csv"
appliances = []
CSV.foreach(filepath, headers: :first_row) do |row|
  appliances << AllAppliance.create!(category: row['category'], subcategory: row['subcategory'], brand: row['brand'], model: row['model'], wattage: row['wattage'].to_f)
end

puts "All Appliances seeded!"

# Seed user_appliances (Associating appliances with users)
user_appliance1 = UserAppliance.create!(
  user: user1,
  all_appliance: AllAppliance.first # Just linking to the first appliance created
)

user_appliance2 = UserAppliance.create!(
  user: user2,
  all_appliance: AllAppliance.second # Just linking to the second appliance created
)

puts "User Appliances seeded!"

Routine.create!(
  name: "Morning Wash Cycle",
  cost: 1.5,
  starttime: DateTime.new(2024, 11, 27, 10, 0, 0),  # Example starttime
  endtime: DateTime.new(2024, 11, 27, 12, 0, 0),    # Example endtime
  day: (DateTime.new(2024, 11, 27, 10, 0, 0).wday % 7) + 1, # Convert wday to correct day of the week
  user_appliance: user_appliance1
)

Routine.create!(
  name: "Evening Heating",
  cost: 0.8,
  starttime: DateTime.new(2024, 12, 1, 10, 0, 0),  # Example starttime
  endtime: DateTime.new(2024, 12, 1, 12, 0, 0),    # Example endtime
  day: (DateTime.new(2024, 11, 27, 10, 0, 0).wday % 7) + 1, # Convert wday to correct day of the week
  user_appliance: user_appliance2
)
puts "Routines seeded!"

# Seed prices (Adding some example prices)
# Price.create!(
#   datetime: DateTime.now,
#   cost: 0.15
# )

# Price.create!(
#   datetime: DateTime.now - 1.day,
#   cost: 0.13
# )
# # db/seeds.rb

# Define the date range
dates = [
  { date: '2024-11-26', costs: [0.090, 0.079, 0.079, 0.071, 0.073, 0.082, 0.102, 0.110, 0.136, 0.127, 0.112, 0.100, 0.092, 0.102, 0.116, 0.124, 0.144, 0.155, 0.161, 0.153, 0.127, 0.119, 0.123, 0.114] },
  { date: '2024-11-27', costs: [0.111, 0.110, 0.110, 0.103, 0.101, 0.112, 0.129, 0.129, 0.166, 0.131, 0.139, 0.134, 0.126, 0.124, 0.120, 0.124, 0.116, 0.114, 0.110, 0.101, 0.079, 0.080, 0.086, 0.060] },
  { date: '2024-11-28', costs: [0.050, 0.041, 0.035, 0.038, 0.060, 0.092, 0.100, 0.132, 0.148, 0.140, 0.099, 0.099, 0.096, 0.099, 0.114, 0.119, 0.134, 0.151, 0.158, 0.154, 0.143, 0.131, 0.122, 0.113] },
  { date: '2024-11-29', costs: [0.110, 0.107, 0.104, 0.102, 0.103, 0.112, 0.131, 0.161, 0.174, 0.157, 0.138, 0.120, 0.110, 0.114, 0.109, 0.124, 0.146, 0.149, 0.142, 0.132, 0.120, 0.112, 0.114, 0.103] }
]

# Loop through the dates and insert the data into the prices table
dates.each do |date_data|
  date_data[:costs].each_with_index do |cost, index|
    # Create a new Price record for each hour
    Price.create!(
      datetime: "#{date_data[:date]} #{index.to_s.rjust(2, '0')}:00:00", # Generate the datetime
      cost: cost
    )
  end
end

puts "Prices have been seeded successfully!"


puts "Prices seeded!"

# Seed articles (Adding some example articles)
Article.create!(
  title: 'How to Save Energy at Home',
  content: 'Here are some great tips to help you save energy...',
  subcategory: 'Heater'
)

Article.create!(
  title: 'Best Appliances to Reduce Power Consumption',
  content: 'If you are looking to reduce power consumption, these appliances...',
  subcategory: 'climate control'
)

puts "Articles seeded!"

# Days of the week (starting from Sunday to Saturday)
days_of_week = [1, 2, 3, 4, 5, 6, 7]

# Seed averages for every hour (24 hours per day) for every day of the week (7 days)
days_of_week.each_with_index do |day, index|
  # Loop through each hour of the day (0 to 23)
  (0..23).each do |hour|
    # Generate a random average value (or you can set it as needed)
    average_value = rand(0.5..2.0).round(2)  # Example: Random average between 0.5 and 2.0

    # Calculate the time for each day
    time = DateTime.new(2024, 11, index + 4, hour, 0, 0) # Specific hour (for the given day)

    # Create an Average record for each hour of each day
    Average.create!(
      day: day,
      time: time,
      average: average_value  # Random average value or fixed value
    )
  end
end
puts "Averages seeded!"
puts "Seeding completed successfully!"
