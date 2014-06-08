require 'spec_helper'
require 'aws_spec_helper'
require 'vscripts/aws'

describe VScripts::AWS do
  it 'Should load default configuration for AWS SDK' do
    expect(::AWS.config.stub_requests).to be true
  end
end
