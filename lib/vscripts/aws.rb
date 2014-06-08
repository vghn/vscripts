require 'aws-sdk'
require 'logger'
require 'yaml'

require 'vscripts/aws/ec2'
require 'vscripts/aws/metadata'

module VScripts
  # Amazon Web Services Module
  module AWS
    ::AWS.config
    include VScripts::AWS::EC2
    include VScripts::AWS::Metadata
  end # module AWS
end # module VScripts
