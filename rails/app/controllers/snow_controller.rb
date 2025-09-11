class SnowController < ApplicationController
  def index
    @locations = []

    [
      { name: "Stevens Pass", lat: 47.7443, lon: -121.0913 },
      { name: "Alpental", lat: 47.4453, lon: -121.4278 },
      { name: "Crystal Mountain Resort", lat: 46.9349, lon: -121.4762 },
      { name: "Paradise", lat: 46.7879, lon: -121.7385 },
      { name: "Mt. Baker Ski Area", lat: 48.8571, lon: -121.6619 }
    ].each do |location|
      response = Snow::NoaaHelper.forecast(location[:lat], location[:lon])
      if response[:error]
        flash[:error] = "Error fetching forecast for #{location[:name]}: #{response[:error]}"
        redirect_to root_path and return
      else
        @locations << { name: location[:name], data: response }
      end
    end
  end
end

