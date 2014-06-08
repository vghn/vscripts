require 'open-uri'
require 'net/http'

module VScripts
  module AWS
    # This module contacts the AWS Metadata service to collect information
    # about the current EC2 instance.
    module Metadata
      # @return [String] the Metadata URL
      def metadata_url
        'http://instance-data/latest/meta-data'
      end

      # @return [String] the availability zone
      def zone
        open("#{metadata_url}/placement/availability-zone")
          .read
      end

      # @return [String] the region
      def region
        zone[/^(.*[\d])[a-z]$/, 1]
      end

      # @return [String] the instance ID
      def instance_id
        open("#{metadata_url}/instance-id").read
      end

      # @return [String] the instance public hostname
      def public_hostname
        open("#{metadata_url}/public-hostname").read
      end

      # Checks connection to metadata service
      # @return [Boolean]
      def ec2_instance?
        Net::HTTP.get_response(URI.parse(metadata_url)) && true
      rescue
        false
      end

      # Fails if the current instance is not an EC2 instance
      def check_instance
        return if ec2_instance?
        abort 'FATAL: NOT an EC2 instance or could not connect to Metadata'
      end
    end # module Metadata
  end # module AWS
end # module VScripts
