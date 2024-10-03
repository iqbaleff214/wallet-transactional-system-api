require 'net/http'
require 'json'

class LatestStockPrice
  API_HOST = 'latest-stock-price.p.rapidapi.com'
  API_KEY = Rails.application.credentials.rapidapi[:api_key]
  BASE_URL = "https://#{API_HOST}"

  def initialize
    @headers = {
      'X-RapidAPI-Key' => API_KEY,
      'X-RapidAPI-Host' => API_HOST
    }
  end

  def price_all
    url = "#{BASE_URL}/any"
    response = request(url)
    return parse_response(response)
  end

  private

  def request(url, params = {})
    uri = URI(url)
    uri.query = URI.encode_www_form(params) if params.any?

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri, @headers)
    response = http.request(request)

    return response
  end

  def parse_response(response)
    if response.code.to_i == 200
      JSON.parse(response.body)
    else
      { error: "Failed to fetch data, status code: #{response.code}" }
    end
  end
end
