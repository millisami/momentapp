require 'spec_helper'

describe Momentapp do
  it "should schedule a new job" do
    # WebMock.allow_net_connect!
    VCR.use_cassette "new_job", :record => :new_episodes do
      conn = Momentapp::Connection.connection
      payload = {:job => {:method => "GET", :at => '2012-01-31T18:36:21', :uri => "http://kasko.com", :limit => 5, :callback_uri => "http://callbackurl.com?var1=name&var2=size"}}
    
      response = conn.post '/jobs.json', payload.merge!(:apikey => Momentapp::Config.api_key)
      result = JSON.load(response.body)

      result['success']['job']['uri'].should eql("http://kasko.com:80/")
      result['success']['job']['method'].should eql('GET')
      result['success']['job']['at'].should eql('2012-02-01 08:21:21 +0545')
    end
  end
  it "should update a scheduled job" do
    # WebMock.allow_net_connect!
    VCR.use_cassette "update_job", :record => :new_episodes do
      conn = Momentapp::Connection.connection
      payload = {:job => {:method => "GET", :at => '2012-01-31T18:36:21', :uri => "http://kasko.com"}}
      response = conn.post '/jobs.json', payload.merge!(:apikey => Momentapp::Config.api_key)
      result = JSON.load(response.body)
      
      payload_update = {:job => {:method => "POST", :at => '2013-01-31T18:36:21', :uri => "http://tesko.com"}}
      response_update = conn.put "/jobs/#{result['success']['job']['id']}.json", payload_update.merge!(:apikey => Momentapp::Config.api_key)
      result_update = JSON.load(response_update.body)

      result_update['success']['job']['uri'].should eql("http://tesko.com:80/")
      result_update['success']['job']['method'].should eql('POST')
      result_update['success']['job']['at'].should eql('2013-02-01 08:21:21 +0545')
    end
  end
  
  it "should delete a scheduled job" do
    # WebMock.allow_net_connect!
    VCR.use_cassette "delete_job", :record => :new_episodes do
      conn = Momentapp::Connection.connection
      payload = {:job => {:method => "GET", :at => '2012-01-31T18:36:21', :uri => "http://kasko.com"}}
      response = conn.post '/jobs.json', payload.merge!(:apikey => Momentapp::Config.api_key)
      result = JSON.load(response.body)
      result['success']['job']['uri'].should eql('http://kasko.com:80/')
      
      new_response = conn.delete "/jobs/#{result['success']['job']['id']}.json?apikey=#{Momentapp::Config.api_key}"
      # new_response = conn.delete "/jobs/#{result['success']['job']['id']}.json", {:job => {}, :apikey => Momentapp::Config.api_key}
      # debugger
      new_result = JSON.load(new_response.body)
      new_result['success']['message'].should eql('Job deleted')
    end
  end
end