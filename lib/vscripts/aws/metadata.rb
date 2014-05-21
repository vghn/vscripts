require 'open-uri'
require 'net/http'

module VScripts
  module AWS
    # This module contacts the AWS Metadata service to collect information
    # about the EC2 instance.
    module Metadata
      # @return [String] Metadata URL
      def metadata_url
        'http://instance-data/latest/meta-data'
      end

      # @return [String] Get availability zone from metadata
      def zone
        open("#{metadata_url}/placement/availability-zone")
          .read
      end

      # @return [String] Get the region from the zone
      def region
        zone[/^(.*[\d])[a-z]$/, 1]
      end

      # @return [String] Get instance's ID from metadata
      def instance_id
        open("#{metadata_url}/instance-id").read
      end

      # @return [String] Get instance's public hostname from metadata
      def public_hostname
        open("#{metadata_url}/public-hostname").read
      end

      # @return [Boolean] Check connection to service
      def ec2_instance?
        Net::HTTP.get_response(URI.parse(metadata_url)) && true
      rescue
        false
      end

      # Fail if the current instance is not an EC2 instance
      def check_instance
        unless ec2_instance?
          abort 'FATAL: NOT an EC2 instance or could not connect to Metadata'
        end
      end
    end # module Metadata
  end # module AWS
end # module VScripts
