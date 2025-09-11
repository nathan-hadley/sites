require "rails_helper"
require "webmock/rspec"

RSpec.describe Snow::NoaaHelper, type: :helper do
  describe ".forecast" do
    context "success" do
      before do
        # Stub the points request
        stub_request(:get, /api.weather.gov\/points/).
          to_return(status: 200, body: {
            "properties" => {
              "forecast" => "https://api.weather.gov/gridpoints/xxx/forecast"
            }
          }.to_json)

        # Stub the forecast request
        stub_request(:get, /api.weather.gov\/gridpoints/).
          to_return(status: 200, body: {
            "properties" => {
              "periods" => [
                {
                  "startTime"        => "2023-01-01T00:00:00+00:00",
                  "isDaytime"        => true,
                  "detailedForecast" => "New snow accumulation of 1 to 3 inches possible."
                },
                # Could add more periods...
              ]
            }
          }.to_json)
      end

      it "returns the correct snowfall" do
        snowfall = Snow::NoaaHelper.forecast(40.7128, -74.0060)

        expect(snowfall).to eq(
          {
            "min_snow_total" => 1,
            "max_snow_total" => 3,
            "detail"         => {
              "Sunday" => {
                "day" => {
                  "min" => 1,
                  "max" => 3,
                  "avg" => 2
                }
              }
            }
          }
        )
      end
    end

    context "failure" do
      before do
        # Stub the points request to return a server error
        stub_request(:get, /api.weather.gov\/points/).
          to_return(status: 500, body: "")
      end

      it "returns an error message when the server returns an error" do
        forecast = Snow::NoaaHelper.forecast(40.7128, -74.0060)

        expect(forecast[:error]).to eq("An error occurred: Server error: 500")
        expect(a_request(:get, /api.weather.gov\/points/)).to have_been_made.times(4)
      end
    end
  end
end
