require 'open-uri'

class GoogleGeocoding

  def initialize
    @base_url = "https://maps.googleapis.com/maps/api/geocode/json"
    @params = {
      key: CREDENTIALS[:google_token],
      region: 'ar'
    }
  end

  def search_address(address)
    @params[:address] = address
    encoded_params = URI.encode_www_form(@params)
    full_url = [@base_url, encoded_params].join("?")
    response = open(full_url).read
    parse_response(response)
  end

  private

  def parse_response(response)
    json_response = JSON.parse(response)
    if json_response['status'] == 'OK'
      json_response['results']
    else
      []
    end
  end

end