require 'trollop'
require 'vscripts/aws/ec2'
require 'vscripts/util/local_system'

module VScripts
  # Commands module
  module Commands
    # @ec2 smells of :reek:UncommunicativeVariableName

    # Tags2Facts Class
    class Tags2facts
      include VScripts::Util::LocalSystem

      # HELP
      USAGE = <<-EOS

  This command can only be run on an AWS EC2 instance. It looks for all tags
  associated with it and dumps them in a JSON file. By default this file is
  `/etc/facter/facts.d/ec2_tags.json`. It can be overridden with the
  ***`--file`*** argument.

  The `Name` and `Domain` tags are excluded by default because this command is
  intended to add Facter facts and these 2 already exist in Facter. This
  behaviour can be overridden by adding `[-a|--all]` command line option.

  Usage:
       $ vscripts tags2facts [options]

  Options:
      EOS

      # @return [Hash] Command specific arguments
      attr_reader :cli
      # @return [AWS::EC2] EC2 SDK
      attr_reader :ec2

      def initialize(*args)
        @cli ||= parse(*args)
        @ec2 ||= VScripts::AWS::EC2.new
      end

      # Specifies command line options
      def parser
        Trollop::Parser.new do
          banner USAGE
          opt :file, 'The file that will store the tags',
              type: :string, default: '/etc/facter/facts.d/ec2_tags.json'
          opt :all, 'Collect all tags'
          stop_on_unknown
        end
      end

      # Parses command line arguments
      def parse(*args)
        Trollop.with_standard_exception_handling parser do
          parser.parse args
        end
      end

      # @return [Array] A list of tags to be excluded
      def exclude_list
        cli.all ? [] : %w(Name Domain)
      end

      # @return [Hash] Tags table
      def tags_hash
        ec2.tags_without(exclude_list)
      end

      # @return [JSON] Formatted JSON
      def tags_json
        JSON.pretty_generate(tags_hash.to_h)
      end

      # Writes the formatted JSON to a file
      def execute
        file = cli.file
        puts "Writing tags to \"#{file}\""
        ensure_file_content(file, tags_json)
        puts 'Done.'
      end
    end # class Tags2facts
  end # module Commands
end # module VScripts
