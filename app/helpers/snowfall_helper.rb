require 'net/http'
require 'json'

module SnowfallHelper
  USER_AGENT = "nathanhadley"

  # lat and lon cannot have more than 4 decimal points
  def self.noaa_snowfall(lat, lon)
    url = URI("https://api.weather.gov/points/#{lat},#{lon}")
    request = Net::HTTP::Get.new(url)
    request["User-Agent"] = USER_AGENT
    points_response = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
      http.request(request)
    end
    points_json_data = JSON.parse(points_response.body)
    forecast_url = URI(points_json_data["properties"]["forecast"])

    url = forecast_url
    request = Net::HTTP::Get.new(url)
    request["User-Agent"] = USER_AGENT
    forecast_response = Net::HTTP.start(url.host, url.port, use_ssl: true) do |http|
      http.request(request)
    end
    forecast_json_data = JSON.parse(forecast_response.body)

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
        snowfall["detail"][day_of_week][day_or_night]["avg"] = (($1.to_i + $2.to_i) / 2.0).round(1)
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
  end
end
