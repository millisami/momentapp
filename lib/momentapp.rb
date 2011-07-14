require 'faraday_stack'
require 'hashie/mash'

require "momentapp/version"

module Momentapp
  module Config
    class << self
      attr_accessor :api_key
  
      def configure
        yield self
      end
    end
    
    URL = 'http://momentapp.com/'
    API_VERSION = '1.0'
  end
  
  module Connection
    def self.connection
      @connection ||= begin
        conn = Faraday.new('http://momentapp.com/') do |b|
          # b.use Faraday::Response::Mashify
          # b.use Faraday::Response::ParseJson
          # b.use FaradayStack::ResponseJSON, content_type: 'application/json'
          b.adapter Faraday.default_adapter
        end

        conn.headers['User-Agent'] = 'MomentApp Ruby Client'
        conn
      end
    end
    
    def get(path, params = nil)
      connection.get(path) do |request|
        request.params = params if params
      end
    end
  end
  
  # module ApiMethods
  #   def get(path, params = nil)
  #     raw = params && params.delete(:raw)
  #     response = super
  #     raw ? response.env[:raw_body] : response.body.data
  #   end
  #   
  #   def post
  #     
  #   end
  #   
  #   def new_job(*args)
  #     conn.post '/nigiri', payload
  #   end
  #   
  #   def user(user_id, *args)
  #     get("users/#{user_id}", *args)
  #   end
  # 
  #   def user_recent_media(user_id, *args)
  #     get("users/#{user_id}/media/recent", *args)
  #   end
  # 
  #   def media_popular(*args)
  #     get("media/popular", *args)
  #   end
  # 
  #   def tag_search(query, params = {})
  #     get("tags/search", params.merge(:q => query))
  #   end
  # 
  #   def tag_recent_media(tag, *args)
  #     get("tags/#{tag}/media/recent", *args)
  #   end
  # end
  # 
  extend Config
  extend Connection
  # extend ApiMethods
end
