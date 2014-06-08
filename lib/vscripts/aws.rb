require 'aws-sdk'
require 'logger'
require 'yaml'

require 'vscripts/aws/ec2'
require 'vscripts/aws/metadata'

module VScripts
  # A collection of methods used for interaction with Amazon Web Services
  module AWS
    ::AWS.config
    include VScripts::AWS::EC2
    include VScripts::AWS::Metadata
  end # module AWS
end # module VScripts
