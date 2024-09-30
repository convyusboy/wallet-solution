require "httparty"

class LatestStockPrice
  API_KEY = "c368af358cmshb64302ae75217a4p12b537jsnfc044e861436".freeze
  API_HOST = "latest-stock-price.p.rapidapi.com".freeze

  def self.price_all
    url = "https://latest-stock-price.p.rapidapi.com/any"
    headers = {
      "x-rapidapi-host" => API_HOST,
      "x-rapidapi-key" => API_KEY
    }
    res = HTTParty.get(
      url,
      headers: headers
    )
    raise "API Error: #{res.code}" unless res.success?
    res.parsed_response
  end

  def self.prices
    url = "https://latest-stock-price.p.rapidapi.com/equities"
    headers = {
      "x-rapidapi-host" => API_HOST,
      "x-rapidapi-key" => API_KEY
    }
    res = HTTParty.get(
      url,
      headers: headers
    )
    raise "API Error: #{res.code}" unless res.success?
    res.parsed_response
  end

  def self.price(search)
    url = "https://latest-stock-price.p.rapidapi.com/equities-search"
    headers = {
      "x-rapidapi-host" => API_HOST,
      "x-rapidapi-key" => API_KEY
    }
    query = {
      "Search" => search
    }
    res = HTTParty.get(
      url,
      headers: headers,
      query: query
    )
    raise "API Error: #{res.code}" unless res.success?
    res.parsed_response
  end
end
