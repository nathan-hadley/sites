require 'net/http'
require 'json'

module Snow::NoaaHelper
  USER_AGENT = "nathanhadley"

  MAX_RETRIES = 3

  def self.forecast(lat, lon)
    retries = 0

    begin
      url = URI("https://api.weather.gov/points/#{lat},#{lon}")
      request = Net::HTTP::Get.new(url)
      request["User-Agent"] = USER_AGENT
      points_response = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
        http.request(request)
      end

      if points_response.code.to_i >= 500
        raise "Server error: #{points_response.code}"
      end

      points_json_data = JSON.parse(points_response.body)

      unless points_json_data.has_key?("properties") && points_json_data["properties"].has_key?("forecast")
        raise "Unexpected response structure: #{points_json_data}"
      end

      forecast_url = URI(points_json_data["properties"]["forecast"])
      url = forecast_url
      request = Net::HTTP::Get.new(url)
      request["User-Agent"] = USER_AGENT
      forecast_response = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
        http.request(request)
      end

      if forecast_response.code.to_i >= 500
        raise "Server error: #{forecast_response.code}"
      end

      forecast_json_data = JSON.parse(forecast_response.body)

      unless forecast_json_data.has_key?("properties") && forecast_json_data["properties"].has_key?("periods")
        raise "Unexpected response structure: #{forecast_json_data}"
      end

      snowfall = {
        "min_snow_total" => 0,
        "max_snow_total" => 0,
        "detail"         => {}
      }

      forecast_json_data["properties"]["periods"].each do |period|
        day_of_week = DateTime.parse(period["startTime"]).strftime("%A")
        day_or_night = period["isDaytime"] ? "day" : "night"

        snowfall["detail"][day_of_week] ||= {}
        snowfall["detail"][day_of_week][day_or_night] = {}

        case period["detailedForecast"]
        when /New snow accumulation of (\d+) to (\d+) inches possible./
          snowfall["detail"][day_of_week][day_or_night]["min"] = $1.to_i
          snowfall["detail"][day_of_week][day_or_night]["max"] = $2.to_i
          rounded_avg = (($1.to_i + $2.to_i) / 2.0).round(1)
          rounded_avg = rounded_avg.to_i if rounded_avg == rounded_avg.to_i
          snowfall["detail"][day_of_week][day_or_night]["avg"] = rounded_avg
        when /New snow accumulation of around one inch possible/
          snowfall["detail"][day_of_week][day_or_night]["avg"] =
            snowfall["detail"][day_of_week][day_or_night]["max"] =
              snowfall["detail"][day_of_week][day_or_night]["min"] = 1
        else
          snowfall["detail"][day_of_week][day_or_night]["avg"] =
            snowfall["detail"][day_of_week][day_or_night]["max"] =
              snowfall["detail"][day_of_week][day_or_night]["min"] = 0
        end

        snowfall["min_snow_total"] += snowfall["detail"][day_of_week][day_or_night]["min"]
        snowfall["max_snow_total"] += snowfall["detail"][day_of_week][day_or_night]["max"]
      end

      snowfall

    rescue JSON::ParserError => e
      puts "Failed to parse JSON response: #{e.message}"
      return { error: "Failed to parse JSON response: #{e.message}" }
    rescue RuntimeError => e
      if e.message.start_with?('Server error') && retries < MAX_RETRIES
        puts "Encountered a server error. Retrying... (Attempt: #{retries+1})"
        retries += 1
        sleep 2**retries
        retry
      else
        puts "An error occurred: #{e.message}"
        return { error: "An error occurred: #{e.message}" }
      end
    rescue => e
      puts "An error occurred: #{e.message}"
      return { error: "An error occurred: #{e.message}" }
    end
  end
end
