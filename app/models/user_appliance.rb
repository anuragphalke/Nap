class UserAppliance < ApplicationRecord
  after_commit :create_article

  attr_accessor :brand
  # Associations
  belongs_to :user
  belongs_to :all_appliance
  has_many :routines, dependent: :destroy

  # Validations
  validates :nickname, uniqueness: { scope: :user_id, message: "should be unique for your devices" },
            length: { maximum: 20 }

  def create_article
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [{
        role: "user",
        content: "Please write me an article about saving money and energy while using #{self.all_appliance.subcategory}. Provide the response as valid JSON with quoted keys 'title' and 'content', and nothing else."
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

end
