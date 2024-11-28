require 'date'
require "csv"

# Define Categories and Subcategories
User.destroy_all
AllAppliance.destroy_all
Routine.destroy_all
UserAppliance.destroy_all
Average.destroy_all

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

filepath = "db/seeds/appliances.csv"
appliances = []
CSV.foreach(filepath, headers: :first_row) do |row|
  appliances << AllAppliance.create!(category: row['category'], subcategory: row['subcategory'], brand: row['brand'], model: row['model'], wattage: row['wattage'].to_f)
end

# Seed user_appliances (Associating appliances with users)
user_appliance1 = UserAppliance.create!(
  user: user1,
  all_appliance: AllAppliance.first # Just linking to the first appliance created
)

user_appliance2 = UserAppliance.create!(
  user: user2,
  all_appliance: AllAppliance.second # Just linking to the second appliance created
)

routine1 = Routine.create!(
  name: "Morning Wash Cycle",
  cost: 1.5,
  starttime: DateTime.new(2024, 11, 27, 10, 0, 0),  # Example starttime
  endtime: DateTime.new(2024, 11, 27, 12, 0, 0),    # Example endtime
  day: DateTime.new(2024, 11, 27, 10, 0, 0).strftime('%u').to_s,  # Convert wday to correct day of the week
  user_appliance: user_appliance1
)

routine2 = Routine.create!(
  name: "Evening Heating",
  cost: 0.8,
  starttime: DateTime.new(2024, 12, 1, 10, 0, 0),  # Example starttime
  endtime: DateTime.new(2024, 12, 1, 12, 0, 0),    # Example endtime
  day: DateTime.new(2024, 12, 1, 10, 0, 0).strftime('%u').to_s, # Convert wday to correct day of the week
  user_appliance: user_appliance2
)
p routine2.starttime
p Routine.last
puts "wday for starttime: #{routine1.starttime.wday}"
puts "wday for starttime: #{routine2.starttime.wday}"

# Seed prices (Adding some example prices)
Price.create!(
  datetime: DateTime.now,
  cost: 0.15
)

Price.create!(
  datetime: DateTime.now - 1.day,
  cost: 0.13
)

# Seed articles (Adding some example articles)
Article.create!(
  title: 'How to Save Energy at Home',
  content: 'Here are some great tips to help you save energy...',
  category: 'Heater'
)

Article.create!(
  title: 'Best Appliances to Reduce Power Consumption',
  content: 'If you are looking to reduce power consumption, these appliances...',
  category: 'climate control'
)

# Days of the week (starting from Sunday to Saturday)
days_of_week = ["1", "2", "3", "4", "5", "6", "7"]

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

puts "Seeding completed successfully!"
