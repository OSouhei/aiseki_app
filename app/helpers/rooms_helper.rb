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

  def retrieve_shop_name_from_xml(data)
    shop_data = data["results"]["shop"]
    shops = []
    shop_data.each do |shop|
      # shops << shop["name"]
      shops << { name: shop["name"], url: shop["urls"]["pc"] }
    end
    shops
  end
end
