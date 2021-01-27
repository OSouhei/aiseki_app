require 'json'
require 'net/https'
require "uri"

module RoomsHelper
  def search_shops(term)
    data = {
      key: ENV["HOTPEPPER_API_KEY"],
      keyword: term
    }
    query = data.to_query
    uri = URI("https://webservice.recruit.co.jp/hotpepper/shop/v1/?#{query}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri)
    res = http.request(req)
    Hash.from_xml(res.body)
  end

  def parse_json(data)
    shops = data["results"]["shop"]
    shop_names = []
    shops.each do |shop|
      shop_names << shop["name"]
    end
    shop_names
  end
end
