require 'spec_helper'

describe Momentapp do
  context "scheduling a new job" do
    it "with no parameters" do
      # WebMock.allow_net_connect!
      VCR.use_cassette "new_job", :record => :new_episodes do
        target_uri = "http://kasko.com"
        method = "GET"
        at = '2012-01-31T18:36:21'
        result = Momentapp.create_job(target_uri, method, at)
      
        result['success']['job']['uri'].should eql("http://kasko.com:80/")
        result['success']['job']['method'].should eql('GET')
        result['success']['job']['at'].should eql('2012-02-01 08:21:21 +0545')
      end
    end
    
    it "with parameters" do
      # WebMock.allow_net_connect!
      VCR.use_cassette "new_job_with_params", :record => :new_episodes do
        target_uri = "http://kasko.com"
        method = "GET"
        at = '2012-01-31T18:36:21'
        params = {:var1 => true, :var2 => false, :var3 => "ok"}
        result = Momentapp.create_job(target_uri, method, at, params)
      
        result['success']['job']['uri'].should eql("http://kasko.com:80/?var1=true&var2=false&var3=ok")
        result['success']['job']['method'].should eql('GET')
        result['success']['job']['at'].should eql('2012-02-01 08:21:21 +0545')
      end
    end
    
    it "with parameters and options" do
      # WebMock.allow_net_connect!
      VCR.use_cassette "new_job_with_params_n_options", :record => :new_episodes do
        target_uri = "http://kasko.com"
        method = "GET"
        at = '2012-01-31T18:36:21'
        params = {:var1 => true, :var2 => false, :var3 => "ok"}
        options = {:limit => 3, :callback_uri => "http://callback.com/public/listener"}
        result = Momentapp.create_job(target_uri, method, at, params, options)
        result['success']['job']['uri'].should eql("http://kasko.com:80/?var1=true&var2=false&var3=ok")
        result['success']['job']['method'].should eql('GET')
        result['success']['job']['at'].should eql('2012-02-01 08:21:21 +0545')
      end
    end
  end
  
  it "should update a scheduled job" do
    # WebMock.allow_net_connect!
    VCR.use_cassette "update_job", :record => :new_episodes do
      target_uri = "http://kasko.com"
      method = "GET"
      at = '2012-01-31T18:36:21'
      params = {:var1 => true, :var2 => false, :var3 => "ok"}
      result = Momentapp.create_job(target_uri, method, at, params)      
      
      job_id = result['success']['job']['id']
      target_uri = "http://tesko.com"
      method = "POST"
      options = {}
      result_update = Momentapp.update_job(job_id, target_uri, method, at, params, options)

      result_update['success']['job']['uri'].should eql("http://tesko.com:80/")
      result_update['success']['job']['method'].should eql('POST')
      result_update['success']['job']['at'].should eql('2013-02-01 08:21:21 +0545')
    end
  end
  
  it "should delete a scheduled job" do
    # WebMock.allow_net_connect!
    VCR.use_cassette "delete_job", :record => :new_episodes do
      target_uri = "http://kasko.com"
      method = "GET"
      at = '2012-01-31T18:36:21'
      result = Momentapp.create_job(target_uri, method, at)
      
      job_id = result['success']['job']['id']

      new_result = Momentapp.delete_job(job_id)
      new_result['success']['message'].should eql('Job deleted')
    end
  end
end