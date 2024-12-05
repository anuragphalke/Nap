# rubocop:disable Metrics/MethodLength
# rubocop:disable Layout/LineLength
# rubocop:disable Metrics/ClassLength
class UserAppliancesController < ApplicationController
  before_action :set_user_appliance, only: %i[show edit update destroy]

  def index
    @categories = current_user.user_appliances
                                              .joins(:all_appliance)
                                              .distinct
                                              .pluck('all_appliances.category')

    @user_appliances = if params[:category]
                         current_user.user_appliances.joins(:all_appliance)
                                                     .where(all_appliances: { category: params[:category] })
                       else
                         current_user.user_appliances
                       end

    @average_prices = Price
                           .select("EXTRACT(HOUR FROM datetime) AS hour, EXTRACT(DOW FROM datetime) AS day, AVG(cost) AS average_price")
                           .group("EXTRACT(HOUR FROM datetime), EXTRACT(DOW FROM datetime)")
                           .order("day, hour")

    @user_appliance_tags = @user_appliances.map { |appliance| calculate_tag(appliance) }
  end

  def show
    @routines = @user_appliance.routines
                               .select("DISTINCT ON (lineage) *")        # Get distinct routines by lineage
                                .order(:lineage, "id DESC", :starttime)  # Prioritize highest ID per lineage, then order by starttime
  end

  def new
    @user_appliance = UserAppliance.new
    @user_appliance.brand = params[:user_appliance][:brand] if params[:user_appliance]&.[](:brand).present?

    @brands = AllAppliance.distinct.pluck(:brand)

    if @user_appliance.brand.present?
      @models = AllAppliance.where(brand: @user_appliance.brand).pluck(:model, :id)
    else
      @models = []
    end

    return render :new if params[:user_appliance]&.[](:brand).present?
  end

  def create
    @user_appliance = UserAppliance.new(appliance_params)
    @user_appliance.user_id = current_user.id

    if params[:user_appliance][:all_appliance_id].blank?
      @brands = AllAppliance.distinct.pluck(:brand)
      @models = AllAppliance.where(brand: @user_appliance.brand).pluck(:model, :id)
      render :new
      return
    end

    device = @user_appliance.all_appliance.subcategory
    articles = Article.where(subcategory: device)

    if @user_appliance.save
      create_article(@user_appliance) if articles.empty?

      if current_user.user_appliances.count == 1
        redirect_to new_user_appliance_routine_path(@user_appliance)
      else
        redirect_to @user_appliance, notice: "Appliance was successfully created."
      end
    else
      @brands = AllAppliance.distinct.pluck(:brand)
      @models = AllAppliance.where(brand: @user_appliance.brand).pluck(:model, :id)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    @user_appliance = UserAppliance.find(params[:id])

    if @user_appliance.user_id == current_user.id
      if @user_appliance.update(appliance_params)
        redirect_to @user_appliance, notice: "Appliance was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    else
      redirect_to user_appliances_path, alert: "You are not authorized to edit this appliance."
    end
  end

  def destroy
    @user_appliance.destroy
    redirect_to user_appliances_path, notice: "Appliance was successfully deleted."
  end

  private

  def calculate_tag(user_appliance)
    return "" if user_appliance.routines.empty?

    routines_match = user_appliance.routines.any? do |routine|
      routine.recommendations.any? do |recommendation|
        routine.starttime.wday == recommendation.starttime.wday && routine.starttime.strftime("%H:%M") == recommendation.starttime.strftime("%H:%M")
      end
    end

    routines_match ? "tag-auto" : "tag-new"
  end

  def create_article(user_appliance)
    client = OpenAI::Client.new
    chatgpt_response = client.chat(parameters: {
                                                  model: "gpt-4o-mini",
                                                  messages: [{
                                                    role: "user",
                                                    content: "Please write me an article about saving money and energy while using #{user_appliance.all_appliance.subcategory}. Provide the response as valid JSON with quoted keys 'title' (max 40 characters) and 'content', and nothing else."
                                                    }]
    })

    # Extract the raw response content
    raw_response = chatgpt_response["choices"][0]["message"]["content"]

    # Clean the response by removing Markdown code block delimiters
    cleaned_response = raw_response.gsub(/```json|```/, "").strip.gsub("*", "")

    # Escape unescaped quotes within strings
    escaped_response = cleaned_response.gsub(/(?<!\\)"/, '\"')

    # Replace Ruby-like hash syntax with JSON-compatible syntax (if necessary)
    # json_response = escaped_response.gsub(/(\w+):/, '"\1":')

    # Parse the JSON response
    parsed_response = JSON.parse(cleaned_response)

    # Create the article using the parsed data

    article = Article.create(
      title: parsed_response["title"],
      content: parsed_response["content"].gsub(/(?=\b\d+\.)/, "<br>"),
      subcategory: user_appliance.all_appliance.subcategory,
      user_appliance_id: user_appliance.id
    )
    article.save
  rescue JSON::ParserError => e
    Rails.logger.error "Failed to parse OpenAI response: #{e.message}"
    puts "Cleaned Response: #{cleaned_response}"
    puts "Escaped Response: #{escaped_response}"
  end

  def set_user_appliance
    @user_appliance = UserAppliance.find(params[:id])
  end

  def appliance_params
    params.require(:user_appliance).permit(:all_appliance_id, :brand, :nickname)
  end
end
# rubocop:enable Metrics/MethodLength
# rubocop:enable Layout/LineLength
# rubocop:enable Metrics/ClassLength
