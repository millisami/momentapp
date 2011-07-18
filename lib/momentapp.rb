require 'faraday'
require 'hashie/mash'

require "momentapp/version"
require 'active_support/core_ext'
require 'core_ext/hash'

module Momentapp
  module Config
    class << self
      attr_accessor :api_key
  
      def configure
        yield self
      end
    end
  end
  
  module Connection
    def connection
      @connection ||= begin
        conn = Faraday.new('https://momentapp.com', ssl: {verify: false}) do |b|
          
          b.request  :json
          b.adapter Faraday.default_adapter
        end

        conn.headers['User-Agent'] = 'MomentApp Ruby Client'
        conn
      end
    end
  end
  
  module ApiMethods
    def create_job(target_uri, http_method, at, params={}, options={})
      unless params.nil?
        target_uri += "?" + params.to_query
      end
      
      job_payload = {:method => http_method.upcase, :at => at, :uri => target_uri}

      unless options.nil?
        valid_option_keys = [:limit, :callback_uri]
        options.slice(*valid_option_keys)
        job_payload.merge!({:limit => options[:limit]}) if options[:limit].present?
        job_payload.merge!({:callback_uri => options[:callback_uri]}) if options[:callback_uri].present?
      end
      
      payload = {:job => job_payload}.merge!(:apikey => Momentapp::Config.api_key)
      response = connection.post '/jobs.json', payload
      job = Hashie::Mash.new(JSON.load(response.body)['success']['job'])
      job = job.rename_key!('method', 'http_method')
      job
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
      job = Hashie::Mash.new(JSON.load(response.body)['success']['job'])
      job = job.rename_key!('method', 'http_method')
      job  
    end
    
    def delete_job(job_id)
      response = connection.delete "/jobs/#{job_id}.json?apikey=#{Momentapp::Config.api_key}"
      job = Hashie::Mash.new(JSON.load(response.body)['success'])
      job
    end
  end

  extend Config
  extend Connection
  extend ApiMethods
end
