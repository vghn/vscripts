module VScripts
  module AWS
    # EC2 Module smells of :reek:UncommunicativeModuleName
    # @ec2 smells of :reek:UncommunicativeVariableName
    # ec2 smells of :reek:UncommunicativeMethodName

    # AWS Elastic Compute Cloud
    module EC2
      # Load AWS SDK for EC2
      def ec2
        ::AWS::EC2.new(region: region)
      end

      # Get instance object
      def instance
        check_instance
        ec2.instances[instance_id]
      end

      # @return [AWS::EC2::ResourceTagCollection] Tags collection
      def all_tags
        instance.tags
      end

      # @return [AWS::EC2::ResourceTagCollection] Tags collection
      def tag(key)
        instance.tags[key]
      end

      # @return [AWS::EC2::Tag] Creates an EC2 Tag
      def create_tag(resource, key, value)
        ec2.tags.create(resource, key, value)
      end

      # Get a list of tags
      def tags_without(list = [])
        all_tags.each_with_object({}) do |tag, hash|
          key, value = tag[0], tag[1]
          hash[key] = value unless list.include? key
          hash
        end
      end

      # Looks for the value of the 'Name' tag for the given instance
      def name
        all_tags_hash['Name']
      end

      # @return[AWS::EC2::InstanceCollection] Lists instances that have a
      # 'Name' tag
      def named_instances
        ec2.instances.tagged('Name')
      end

      # @return[Array] Lists instances that are not terminated
      def functional_instances
        named_instances.map do |named_instance|
          named_instance if [:running, :shutting_down, :stopping, :stopped]
            .include?(named_instance.status)
        end
      end

      # @return[Array] The 'Name' tag value except the local instance
      def similar_instances
        check_instance
        functional_instances.map do |functional_instance|
          next if functional_instance.id == instance_id
          functional_instance.tags['Name']
        end
      end
    end # module EC2
  end # module Amazon
end # module VScripts
