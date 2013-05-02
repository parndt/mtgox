require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'base64'
require 'mtgox'
require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!(:allow => 'coveralls.io')

def a_get(path)
  a_request(:get, 'https://data.mtgox.com' + path)
end

def stub_get(path)
  stub_request(:get, 'https://data.mtgox.com' + path)
end

def a_post(path)
  a_request(:post, 'https://data.mtgox.com' + path)
end

def stub_post(path)
  stub_request(:post, 'https://data.mtgox.com' + path)
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end

def test_headers(body=test_body)
  signature = Base64.strict_encode64(
    OpenSSL::HMAC.digest 'sha512',
    Base64.decode64(MtGox.secret),
    body
  )
  {'Rest-Key' => MtGox.key, 'Rest-Sign' => signature}
end

NONCE_STUB_VALUE = 1321745961249676
def test_body(options={})
  options.merge!(nonce: NONCE_STUB_VALUE).collect{|k, v| "#{k}=#{v}"} * '&'
end
