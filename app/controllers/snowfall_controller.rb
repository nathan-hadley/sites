class SnowfallController < ApplicationController
  def index
    @locations = [
      { name: "Stevens Pass", data: SnowfallHelper.noaa_snowfall(47.7395, -121.0878) },
      { name: "Alpental", data: SnowfallHelper.noaa_snowfall(47.4404, -121.4347) },
      { name: "Crystal Mountain Resort", data: SnowfallHelper.noaa_snowfall(46.5608, -121.2913) },
      { name: "Paradise", data: SnowfallHelper.noaa_snowfall(46.7879, -121.7385) },
      { name: "Mt. Baker Ski Area", data: SnowfallHelper.noaa_snowfall(48.8609, -121.6660) }
    ]
  end
end
