namespace :energy_prices do
  desc "Fetch and save energy prices from energyprices.eu"
  task fetch_prices: :environment do
    require 'net/http'
    require 'uri'

    def fetch_page
      uri = URI('https://www.energyprices.eu/electricity/netherlands')
      response = Net::HTTP.get_response(uri)

      if response.is_a?(Net::HTTPSuccess)
        response.body
      else
        Rails.logger.error "Failed to fetch energy prices: #{response.code}"
        nil
      end
    rescue StandardError => e
      Rails.logger.error "Error fetching energy prices: #{e.message}"
      nil
    end

    def extract_prices(html_content)
      match = html_content.match(/data:\s*\[([\d.,\s]+)\]/)
      return [] unless match
      match[1].scan(/[\d.]+/).map(&:to_f)
    end

    def save_prices(prices)
      today = Date.today

      prices.each_with_index do |price, hour|
        datetime = today.to_datetime.change(hour: hour)

        price_data = {
          price: {
            datetime: datetime,
            cost: price
          }
        }

        price_record = Price.new(price_data[:price])

        if price_record.save
          puts "Saved price #{price} for #{datetime}"
        else
          puts "Failed to save price for #{datetime}: #{price_record.errors.full_messages.join(', ')}"
        end
      end
    end

    # Main execution
    puts "Starting to fetch energy prices..."
    html_content = fetch_page

    if html_content
      prices = extract_prices(html_content)
      if prices.any?
        save_prices(prices)
        puts "Completed saving energy prices"
      else
        puts "No prices found in the data"
      end
    else
      puts "Failed to fetch page content"
    end
  end
end
