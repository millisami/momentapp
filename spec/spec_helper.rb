path = File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'momentapp'
require 'vcr'
require 'webmock'

RSpec.configure do |config|
  config.filter_run :focus => true
  config.filter_run_excluding :broken => true
  config.run_all_when_everything_filtered = true
  config.extend VCR::RSpec::Macros
  
  config.before(:all) {
    Momentapp::Config.api_key = "4wV4xjaYbpWRLY_sHYYc"
  }
end

VCR.config do |c|
  c.cassette_library_dir     = 'spec/cassettes_library'
  c.stub_with                :webmock
  c.ignore_localhost         = true
  c.default_cassette_options = { :record => :none }
end