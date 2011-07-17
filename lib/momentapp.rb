require 'faraday_stack'
require 'hashie/mash'

require "momentapp/version"
require 'active_support/core_ext'

module Momentapp
  module Config
    class << self
      attr_accessor :api_key
  
      def configure
        yield self
      end
    end
    
    URL = 'https://momentapp.com'
    API_VERSION = '1.0'
  end
  
  module Connection
    def connection
      @connection ||= begin
        conn = Faraday.new('https://momentapp.com', ssl: {verify: false}) do |b|
          
          b.request  :json
          # b.response :logger
          # b.adapter  :web_mock
          
          # b.use Faraday::Request::UrlEncoded
          # b.use Faraday::Response::Logger
          # b.use Faraday::Response::Mashify
          # b.use Faraday::Response::ParseJson
          # b.use FaradayStack::ResponseJSON, content_type: 'application/json'
          b.adapter Faraday.default_adapter
        end

        conn.headers['User-Agent'] = 'MomentApp Ruby Client'
        conn
      end
    end
    
    
    # resp = conn.post '/jobs.json', {:apikey => "4wV4xjaYbpWRLY_sHYYc", :job => {:method => "PUT", :at => '2012-01-31T18:36:21', :uri => "http://kasko.com"}}
    
    def get(path, params = nil)
      connection.get(path) do |request|
        request.params = params if params
      end
    end
  end
  
  module ApiMethods
    def create_job(target_uri, method, at, params={}, options={})
      unless params.nil?
        target_uri += "?" + params.to_query
      end
      
      job_payload = {:method => method.upcase, :at => at, :uri => target_uri}

      unless options.nil?
        valid_option_keys = [:limit, :callback_uri]
        options.slice(*valid_option_keys)
        job_payload.merge!({:limit => options[:limit]}) if options[:limit].present?
        job_payload.merge!({:callback_uri => options[:callback_uri]}) if options[:callback_uri].present?
      end
      
      payload = {:job => job_payload}.merge!(:apikey => Momentapp::Config.api_key)
      response = connection.post '/jobs.json', payload
      JSON.load(response.body)
    end
    
    def update_job(job_id, target_uri, method, at, params={}, options={})
      unless params.nil?
        target_uri += "?" + params.to_query
      end
      
      job_payload = {:method => method.upcase, :at => at, :uri => target_uri}

      unless options.nil?
        valid_option_keys = [:limit, :callback_uri]
        options.slice(*valid_option_keys)
        job_payload.merge!({:limit => options[:limit]}) if options[:limit].present?
        job_payload.merge!({:callback_uri => options[:callback_uri]}) if options[:callback_uri].present?
      end
      
      payload = {:job => job_payload}.merge!(:apikey => Momentapp::Config.api_key)
      response = connection.put "/jobs/#{job_id}.json", payload
      JSON.load(response.body)      
    end
    
    def delete_job(job_id)
      response = connection.delete "/jobs/#{job_id}.json?apikey=#{Momentapp::Config.api_key}"
      JSON.load(response.body)
    end
  end
  
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
  extend ApiMethods
end
