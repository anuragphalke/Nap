class UserAppliance < ApplicationRecord
  after_save :create_article
  
  attr_accessor :brand
  # Associations
  belongs_to :user
  belongs_to :all_appliance
  has_many :routines, dependent: :destroy

  # Validations
  validates :nickname, uniqueness: { scope: :user_id, message: "should be unique for your devices" },
            format: { with: /\A[a-zA-Z0-9]+\z/, message: "can only contain letters and numbers" },
            length: { maximum: 20 }

  def create_article
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: "Please write me an article about saving money and energy while using #{self.all_appliance.subcategory}, please use a short and fancy heading, please give me the response as a ruby hash with a title and content"}]
    })
    response = chatgpt_response["choices"][0]["message"]["content"]
    Article.create(title: response[:title], content: response[:content], subcategory: self.all_appliance.subcategory)
  end
end
