class LaunchJob < ApplicationJob
  queue_as :default

  def perform(user_appliance)
    # You can directly use your article creation logic here
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [{
        role: "user",
        content: "Please write me an article about saving money and energy while using #{user_appliance.all_appliance.subcategory}. Provide the response as valid JSON with quoted keys 'title' (max 40 characters) and 'content', and nothing else."
      }]
    })

    raw_response = chatgpt_response["choices"][0]["message"]["content"]
    cleaned_response = raw_response.gsub(/```json|```/, "").strip.gsub("*", "")
    parsed_response = JSON.parse(cleaned_response)

    Article.create(
      title: parsed_response["title"],
      content: parsed_response["content"].gsub(/(?=\b\d+\.)/, "<br>"),
      subcategory: user_appliance.all_appliance.subcategory,
      user_appliance_id: user_appliance.id
    )
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse OpenAI response: #{e.message}"
  end
end
