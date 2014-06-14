module VScripts
  module AWS
    # EC2 Module smells of :reek:UncommunicativeModuleName
    # @ec2 smells of :reek:UncommunicativeVariableName
    # ec2 smells of :reek:UncommunicativeMethodName

    # A collection of methods used for interaction with Amazon Web Service
    # Elastic Compute Cloud.
    module EC2
      # Loads AWS SDK for EC2
      def ec2
        ::AWS::EC2.new(region: region)
      end

      # @return [AWS::EC2::Instance] the current instance
      def instance
        check_instance
        ec2.instances[instance_id]
      end

      # @return [AWS::EC2::ResourceTagCollection] all tags
      def all_tags
        instance.tags
      end

      # @param key [String] the key
      # @return [AWS::EC2::Tag] the value of the tag
      def tag(key)
        instance.tags[key]
      end

      # Creates an EC2 Tag
      # @param resource [String] the id of the resource
      # @param key [String] the key of the tag
      # @param value [String] the value of the tag
      # @return [AWS::EC2::Tag] the new tag
      def create_tag(resource, key, value)
        ec2.tags.create(resource, key, value)
      end

      # @return [Hash] a correct Hash object with all tags and keys
      def all_tags_hash
        hash = {}
        all_tags.each do |key, value|
          hash = hash.merge(Hash[key, value])
        end
        hash
      end

      # Exclude tags
      # @param list [Array] the list of tag keys to be excluded
      # @return [Hash] the filtered tags
      def tags_without(list = [])
        hash = all_tags_hash
        list.each do |key|
          hash.delete(key)
        end
        hash
      end

      # Looks for the value of the 'Name' tag for the given instance
      # @return [String] the name value
      def name
        all_tags_hash['Name']
      end

      # @return [AWS::EC2::InstanceCollection] the value of the name tag
      def named_instances
        ec2.instances.tagged('Name')
      end

      # @return [AWS::EC2::InstanceCollection] instances that are not terminated
      def functional_instances
        named_instances.map do |named_instance|
          named_instance if [:running, :shutting_down, :stopping, :stopped]
            .include?(named_instance.status)
        end
      end

      # @return [AWS::EC2::InstanceCollection] running instances that have
      #   a Name tag
      def similar_instances
        check_instance
        functional_instances.compact.map do |functional_instance|
          next if functional_instance.id == instance_id
          functional_instance.tags['Name']
        end
      end
    end # module EC2
  end # module Amazon
end # module VScripts
