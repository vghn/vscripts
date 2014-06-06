require 'spec_helper'
require 'aws-sdk'

::AWS.config({
  :access_key_id => '1234',
  :secret_access_key => '5678',
  :region => 'us-east-1',
  :logger => nil,
  :stub_requests => true
})
