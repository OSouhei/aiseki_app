require 'json'
require 'net/https'
require "uri"

module RoomsHelper
  def search_shops(term)
    query = {
      key: ENV["HOTPEPPER_API_KEY"],
      keyword: term,
      format: "json"
    }.to_query
    uri = URI("https://webservice.recruit.co.jp/hotpepper/shop/v1/?#{query}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(uri)
    res = http.request(req)
    JSON.parse(res.body)
  end
end
