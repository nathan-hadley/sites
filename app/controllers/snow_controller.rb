class SnowController < ApplicationController
  def index
    @locations = [
      { name: "Stevens Pass", data: Snow::NoaaHelper.forecast(47.7443, -121.0913) },
      { name: "Alpental", data: Snow::NoaaHelper.forecast(47.4453, -121.4278) },
      { name: "Crystal Mountain Resort", data: Snow::NoaaHelper.forecast(46.9349, -121.4762) },
      { name: "Paradise", data: Snow::NoaaHelper.forecast(46.7879, -121.7385) },
      { name: "Mt. Baker Ski Area", data: Snow::NoaaHelper.forecast(48.8571, -121.6619) }
    ]
  end
end
