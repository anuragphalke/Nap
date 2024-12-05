class UserAppliance < ApplicationRecord
  require 'date'

  after_commit :create_article

  attr_accessor :brand

  # Associations
  belongs_to :user
  belongs_to :all_appliance
  has_many :routines, dependent: :destroy
  has_many :articles, dependent: :destroy

  def create_article
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [{
        role: "user",
        content: "Please write me an article about saving money and energy while using #{self.all_appliance.subcategory}. Provide the response as valid JSON with quoted keys 'title' (max 40 characters) and 'content', and nothing else."
        }]
      })

    # Extract the raw response content
    raw_response = chatgpt_response["choices"][0]["message"]["content"]

    # Clean the response by removing Markdown code block delimiters
    cleaned_response = raw_response.gsub(/```ruby|```/, "").strip

    # Escape unescaped quotes within strings
    escaped_response = cleaned_response.gsub(/(?<!\\)"/, '\"')

    # Replace Ruby-like hash syntax with JSON-compatible syntax (if necessary)
    json_response = escaped_response.gsub(/(\w+):/, '"\1":')

    # Parse the JSON response
    parsed_response = JSON.parse(json_response)

    # Create the article using the parsed data
    article = Article.create(
      title: parsed_response["title"],
      content: parsed_response["content"],
      subcategory: self.all_appliance.subcategory,
      user_appliance_id: self.id
    )
    article.save
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse OpenAI response: #{e.message}"
    puts "Cleaned Response: #{cleaned_response}"
    puts "Escaped Response: #{escaped_response}"
  end

  # Main method to return both rating and savings
  def performance_and_savings_this_year
    return { rating: "N/A", applied_savings: 0 } if self.routines.empty?

    applied_savings = calculate_applied_savings
    potential_savings = calculate_potential_savings

    applied_savings_this_year = prorate_savings(applied_savings)

    rating = calculate_rating(applied_savings, potential_savings)

    {
      rating: rating,
      applied_savings: applied_savings_this_year
    }
  end

  private

  # Calculate the applied monetary savings across all routines
  def calculate_applied_savings
    applied_savings = 0
    r = self.routines
              .order(:lineage, "id ASC", :starttime)
              .group_by(&:lineage)
              .values

    r.each do |lineage|
      # Savings are calculated based on the cost difference * 52 weeks (annual savings)
      applied_savings += (lineage.first.cost - lineage.last.cost) * 52
    end
    applied_savings
  end

  # Calculate potential monetary savings (what could be saved if the best routine was applied)
  def calculate_potential_savings
    potential_savings = 0
    r = self.routines
              .order(:lineage, "id ASC", :starttime)
              .group_by(&:lineage)
              .values

    r.each do |lineage|
      # Potential savings calculated by comparing the first routine with the best recommendation
      potential_savings += (lineage.first.cost - lineage.last.recommendations.first.cost) * 52
    end
    potential_savings
  end

  # Calculate the total annual cost (across all routines) to use in the savings calculation
  def calculate_annual_cost
    annual_cost = 0
    r = self.routines
              .order(:lineage, "id ASC", :starttime)
              .group_by(&:lineage)
              .values

    r.each do |lineage|
      annual_cost += lineage.last.cost * 52 # Multiply by 52 weeks to get annual cost
    end
    annual_cost
  end

  # Calculate the fraction of the year that has passed, so we can prorate the savings
  def prorate_savings(applied_savings)
    today = Date.today
    days_passed = today.yday
    days_in_year = Date.gregorian_leap?(today.year) ? 366 : 365
    yearly_fraction = days_passed.to_f / days_in_year

    yearly_fraction * applied_savings # Prorate the savings based on today's date
  end

  # Calculate performance rating based on applied and potential savings
  def calculate_rating(applied_savings, potential_savings)
    return 'N/A' if potential_savings.zero? # To avoid division by zero

    score = (applied_savings / potential_savings) * 100

    case score
    when 80..100 then 'A+'
    when 60..79 then 'A'
    when 40..59 then 'B+'
    when 20..39 then 'B-'
    else 'C'
    end
  end
end
