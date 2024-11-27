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






# db/seeds.rb
# db/seeds.rb

# Define Categories and Subcategories
User.destroy_all
AllAppliance.destroy_all
Routine.destroy_all
UserAppliance.destroy_all
Average.destroy_all

CATEGORIES = {
  "kitchen" => ["Oven", "Dishwasher"],
  "EV charger" => ["EV Charger"],
  "entertainment" => ["TV"],
  "climate control" => ["Air Conditioner", "Heater"],
  "laundry" => ["Washing Machine", "Dryer"]
}

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

# Seed all_appliances based on categories and subcategories
CATEGORIES.each do |category, subcategories|
  subcategories.each do |subcategory|
    # Ensure the subcategory belongs to the category
    if CATEGORIES[category].include?(subcategory)
      AllAppliance.create!(
        category: category,
        subcategory: subcategory,
        brand: 'BrandName',  # Sample brand name
        model: "#{subcategory}-Model",  # Sample model name
        wattage: rand(50..1500)  # Random wattage for variety
      )
    else
      puts "Invalid subcategory #{subcategory} for category #{category}"
    end
  end
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

# Seed routines with DateTime objects
routine1 = Routine.create!(
  cost: 1.5,
  starttime: DateTime.new(2024, 11, 27, 0, 0, 0),  # DateTime format (YYYY, MM, DD, HH, MM, SS)
  endtime: DateTime.new(2024, 11, 27, 1, 0, 0),    # Ensure endtime is after starttime
  day: '1',
  user_appliance: user_appliance1
)

routine2 = Routine.create!(
  cost: 0.8,
  starttime: DateTime.new(2024, 11, 27, 10, 0, 0),  # DateTime format (YYYY, MM, DD, HH, MM, SS)
  endtime: DateTime.new(2024, 11, 27, 12, 0, 0),   # Ensure endtime is after starttime
  day: '2',
  user_appliance: user_appliance2
)

# Seed recommendations with DateTime objects
Recommendation.create!(
  routine: routine1,
  cost: 2.5,
  starttime: DateTime.new(2024, 11, 27, 1, 0, 0),
  endtime: DateTime.new(2024, 11, 27, 8, 0, 0)    # Ensure endtime is after starttime
)

Recommendation.create!(
  routine: routine2,
  cost: 1.0,
  starttime: DateTime.new(2024, 11, 27, 2, 0, 0),
  endtime: DateTime.new(2024, 11, 27, 5, 0, 0)    # Ensure endtime is after starttime
)

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

    # Create an Average record for each hour of each day
    Average.create!(
      day: day,  # Day of the week
      time: DateTime.new(2024, 11, 27, hour, 0, 0),  # Specific hour (for the given day)
      average: average_value  # Random average value or fixed value
    )
  end
end

puts "Seeding completed successfully!"
