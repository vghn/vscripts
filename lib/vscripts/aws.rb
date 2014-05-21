require 'aws-sdk'
require 'logger'
require 'yaml'

module VScripts
  # Amazon Web Services Module
  module AWS
    ::AWS.config(
      # logger: Logger.new($stdout),
      # log_formatter: ::AWS::Core::LogFormatter.colored
    )
  end # module AWS
end # module VScripts
