require 'spec_helper'

describe Momentapp do
  it "should schedule a new job" do
    conn = Momentapp::Connection.connection

      
    payload = URI.escape("apikey=kOrROwbVPNC34VZYhbET&job[at]=2011-11-31T18:36:21&job[method]=POST&job[uri]=http://myapp.com/?var1=false")
    
    conn.post '/jobs.json', payload
  end
end