path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'momentapp'
require 'vcr'
require 'webmock'

ROOT_URL = Momentapp::Config::URL

FIXTURES_PATH = File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))

RSpec.configure do |config|
  config.filter_run :focus => true
  config.filter_run_excluding :broken => true
  config.run_all_when_everything_filtered = true
  config.extend VCR::RSpec::Macros
  
  config.before(:all) {
    Momentapp::Config.api_key = "4wV4xjaYbpWRLY_sHYYc"
  }
end

# WebMock.disable_net_connect!(:allow => "sprout.lvh.me")


VCR.config do |c|
  c.cassette_library_dir     = 'spec/cassettes_library'
  c.stub_with                :webmock
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :none }
end
# FakeWeb.allow_net_connect = false
# def register(options)
#   url = api_method_url(options[:url])
#   FakeWeb.register_uri(:get, url, :body => read_fixture(options[:body] + '.json'))
# end
# 
# def read_fixture(fixture)
#   File.read(File.join(FIXTURES_PATH, fixture))
# end
# 
# def api_method_url(method)
#   ROOT_URL + '/' + method
# end