require 'date'
require 'csv'
require 'json'

# Define Categories and Subcategories

User.destroy_all
puts "Users destroyed!"
AllAppliance.destroy_all
puts "All Appliances destroyed!"
Routine.destroy_all
puts "Routines destroyed!"
Article.destroy_all
puts "Articles destroyed!"
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

# Seed appliances from CSV
filepath = "db/seeds/appliances.csv"
appliances = []
CSV.foreach(filepath, headers: :first_row) do |row|
  appliances << AllAppliance.create!(category: row['category'], subcategory: row['subcategory'], brand: row['brand'], model: row['model'], wattage: row['wattage'].to_f)
end

puts "All Appliances seeded!"

# Seed user appliances (Associating appliances with users)
user_appliance1 = UserAppliance.create!(
  user: user1,
  all_appliance: AllAppliance.first # Just linking to the first appliance created
)

user_appliance2 = UserAppliance.create!(
  user: user2,
  all_appliance: AllAppliance.second # Just linking to the second appliance created
)

puts "User Appliances seeded!"

# Seed Prices (Week of Prices)
dates = [
  { date: '2024-11-26', costs: [0.090, 0.079, 0.079, 0.071, 0.073, 0.082, 0.102, 0.110, 0.136, 0.127, 0.112, 0.100, 0.092, 0.102, 0.116, 0.124, 0.144, 0.155, 0.161, 0.153, 0.127, 0.119, 0.123, 0.114] },
  { date: '2024-11-27', costs: [0.111, 0.110, 0.110, 0.103, 0.101, 0.112, 0.129, 0.129, 0.166, 0.131, 0.139, 0.134, 0.126, 0.124, 0.120, 0.124, 0.116, 0.114, 0.110, 0.101, 0.079, 0.080, 0.086, 0.060] },
  { date: '2024-11-28', costs: [0.050, 0.041, 0.035, 0.038, 0.060, 0.092, 0.100, 0.132, 0.148, 0.140, 0.099, 0.099, 0.096, 0.099, 0.114, 0.119, 0.134, 0.151, 0.158, 0.154, 0.143, 0.131, 0.122, 0.113] },
  { date: '2024-11-29', costs: [0.110, 0.107, 0.104, 0.102, 0.103, 0.112, 0.131, 0.161, 0.174, 0.157, 0.138, 0.120, 0.110, 0.114, 0.109, 0.124, 0.146, 0.149, 0.142, 0.132, 0.120, 0.112, 0.114, 0.103] },
  { date: '2024-11-30', costs: [0.100, 0.093, 0.090, 0.087, 0.088, 0.090, 0.088, 0.102, 0.118, 0.125, 0.109, 0.086, 0.087, 0.090, 0.107, 0.122, 0.132, 0.138, 0.136, 0.132, 0.125, 0.115, 0.115, 0.107] },
  { date: '2024-12-01', costs: [0.100, 0.090, 0.088, 0.086, 0.084, 0.084, 0.083, 0.090, 0.099, 0.095, 0.089, 0.082, 0.085, 0.083, 0.088, 0.105, 0.118, 0.118, 0.123, 0.112, 0.094, 0.086, 0.097, 0.085] },
  { date: '2024-12-02', costs: [0.075, 0.066, 0.062, 0.047, 0.049, 0.068, 0.093, 0.125, 0.126, 0.124, 0.121, 0.116, 0.115, 0.126, 0.134, 0.142, 0.145, 0.147, 0.148, 0.139, 0.121, 0.113, 0.113, 0.103] },
  { date: '2024-12-03', costs: [0.111, 0.091, 0.088, 0.087, 0.095, 0.103, 0.120, 0.142, 0.156, 0.151, 0.142, 0.131, 0.127, 0.142, 0.148, 0.166, 0.200, 0.209, 0.198, 0.190, 0.168, 0.153, 0.142, 0.131] },
  { date: '2024-12-04', costs: [0.121, 0.117, 0.113, 0.110, 0.112, 0.120, 0.143, 0.202, 0.267, 0.244, 0.203, 0.192, 0.187, 0.191, 0.206, 0.228, 0.250, 0.280, 0.225, 0.194, 0.159, 0.133, 0.120, 0.111] }
]

# Loop through the dates and insert the data into the prices table
dates.each do |date_data|
  date_data[:costs].each_with_index do |cost, index|
    Price.create!(
      datetime: "#{date_data[:date]} #{index.to_s.rjust(2, '0')}:00:00", # Generate the datetime
      cost: cost
    )
  end
end

puts "Prices seeded!"

# Seed articles (Adding some example articles)
# db/seeds.rb


file_path = Rails.root.join('db', 'seeds', 'articles.json')

# JSON dosyasını oku
articles = JSON.parse(File.read(file_path))

# Her bir article verisi üzerinde döngüye gir
articles.each do |article_data|
  # Verinin formatını kontrol et ve veritabanına kaydet
  Article.create!(article_data)
end


puts "Articles seeded successfully!"

# Calculate averages for each hour of the week (168 hours total)
(0..23).each do |hour|
  (0..6).each do |day|

    # Get all the prices for this specific hour (e.g., Monday 10 AM)
    prices_for_hour = Price.where("EXTRACT(HOUR FROM datetime) = ? AND EXTRACT(DOW FROM datetime) = ?", hour, day)

    # Calculate the average of the prices for this hour
    average_cost = prices_for_hour.pluck(:cost).sum / prices_for_hour.count

    # Get a valid date for the specified day of the week
    # Use the first day of November 2024 and adjust based on the day of the week
    base_date = Date.new(2024, 11, 1)  # November 1, 2024 (can be any fixed date in November)
    day_of_week_offset = (day - base_date.wday) % 7 + 1 # Calculate offset to get the correct weekday

    valid_date = base_date + day_of_week_offset  # Get the exact date for this weekday

    # Create the average record
    Average.create!(
      day: day + 1,
      time: DateTime.new(valid_date.year, valid_date.month, valid_date.day, hour, 0, 0),
      average: average_cost
    )
  end
end

puts "Averages seeded!"

# Seed routines
Routine.create!(
  name: "Morning Wash Cycle",
  starttime: DateTime.new(2024, 11, 27, 10, 0, 0),
  endtime: DateTime.new(2024, 11, 27, 12, 0, 0),
  day: (DateTime.new(2024, 11, 27, 10, 0, 0).wday % 7) + 1,
  user_appliance: user_appliance1
)
puts "Routine cost after creation: #{Routine.last.cost}"

Routine.create!(
  name: "Evening Heating",
  starttime: DateTime.new(2024, 12, 1, 10, 0, 0),
  endtime: DateTime.new(2024, 12, 1, 12, 0, 0),
  day: (DateTime.new(2024, 11, 27, 10, 0, 0).wday % 7) + 1,
  user_appliance: user_appliance2
)
puts "Routine cost after creation: #{Routine.last.cost}"

puts "Routines seeded!"

puts "Seeding completed successfully!"
