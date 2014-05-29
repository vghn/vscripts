require 'trollop'
require 'vscripts/aws/ec2'
require 'vscripts/util/local_system'

module VScripts
  # Commands module
  module Commands
    # @ec2 smells of :reek:UncommunicativeVariableName

    # Identify Class
    class Identify # rubocop:disable ClassLength
      include VScripts::Util::LocalSystem

      # HELP
      USAGE = <<-EOS
This command creates a themed host name and fully qualified domain name for
the server, using AWS EC2 tags. The default theme is `Group-Role-#` which means
that the command collects the value of the `Group` and the `Role` AWS EC2 tags
(if they are associated with the instance). Additionally, the value of the
`Domain` tag is also collected so the resulting new host name will be
`MYGROUP-MYROLE-#.MYDOMAIN`.
These tags can be any existing EC2 tags. `#` is used as a placeholder for a
number. This number starts at 1, and, in case other similarly named instances
exist in the current AWS account, it will be incremented accordingly.
Once a new host name is composed, both `/etc/hostname` and `/etc/hosts` are
modified on the local instance and a new `Name` EC2 tag is created and
associated with the current instance.

    If a ***--host*** argument is provided it will override the default theme.
    *DOMAIN* is still looked up.
    If a ***--domain*** argument is provided it will override the default
    domain.

    EXAMPLES:
    $ vscripts identify
    MyGroup-MyRole-1.Example.tld
    $ vscripts identify --ec2-tag-theme NAME-#
    MyName-1.Example.tld`
    $ vscripts identify --host myhost --domain example.com
    myhost.example.com`

    Options:
      EOS

      # @return [AWS::EC2] EC2 SDK
      attr_reader :ec2
      # @return [String] Theme string
      attr_reader :theme
      # @return [String] Host name
      attr_reader :host
      # @return [String] Domain name
      attr_reader :domain
      # @return [Array] Command specific arguments
      attr_reader :arguments

      def initialize(argv = [])
        @arguments ||= argv
        @theme     ||= cli.ec2_tag_theme
        @host      ||= cli.host
        @domain    ||= cli.domain
      end

      # Specifies command line options
      # This method smells of :reek:TooManyStatements but ignores them
      def parser
        Trollop::Parser.new do
          banner USAGE
          opt :ec2_tag_theme, 'Theme (default: Group-Role-#)',
              type: :string, default: 'Group-Role-#', short: '-t'
          opt :host, 'Host name', type: :string, short: '-n'
          opt :domain, 'Domain name', type: :string, short: '-d'
          stop_on_unknown
        end
      end

      # Parses command line arguments
      def cli
        @cli ||= Trollop.with_standard_exception_handling parser do
          parser.parse arguments
        end
      end

      # Loads AWS::EC2
      # This method smells of :reek:UncommunicativeMethodName but ignores it
      def ec2
        @ec2 ||= VScripts::AWS::EC2.new
      end

      # @return [Array] Splits theme into elements
      def theme_elements
        theme.split('-')
      end

      # @return [Array] An array of values for each tag specified in the theme
      def map2tags
        theme_elements.map do |element|
          element == '#' ? element : ec2.tag(element)
        end
      end

      # @return [String] Compose host name based on found tags
      def themed_host_name
        map2tags.compact.join('-')
      end

      # @return [String] The incremented host name
      def incremented_hostname
        number = 1
        while ec2.similar_instances.include? "#{themed_host_name}.#{domain}"
          .sub(/#/, "#{number}")
          number += 1
        end
        "#{themed_host_name}".sub(/#/, "#{number}")
      end

      # @return [String] The command line --host argument or the themed hostname
      def new_hostname
        host || incremented_hostname || local_host_name
      end

      # @return [String] The value of the command line --domain argument, or the
      #   value of the 'Domain' EC2 tag or the local domain name.
      def new_domain
        domain || ec2.tag('Domain') || local_domain_name
      end

      # @return [String] The fully qualified domain name
      def new_fqdn
        "#{new_hostname}.#{new_domain}"
      end

      # Modify the 'Name' tag
      def set_name_tag
        return if ec2.tag('Name') == new_fqdn
        puts "Setting name tag to \"#{new_fqdn}\"..."
        ec2.create_tag(ec2.instance, 'Name', value: new_fqdn)
      end

      # Modify the host name
      def set_hostname
        return if File.read(hostname_path).strip == new_hostname
        puts "Setting local hostname (#{new_hostname})..."
        write_file(hostname_path, new_hostname)
        `hostname -F /etc/hostname`
      end

      # Modify the hosts file
      def update_hosts
        return if File.readlines(hosts_path)
          .grep(/#{new_fqdn} #{new_hostname}/)
          .any?
        hosts_body = hosts_file.gsub(
          /^127\.0\.0\.1.*/,
          "127\.0\.0\.1 #{new_fqdn} #{new_hostname} localhost"
        )
        puts "Adding \"#{new_fqdn}\" to #{hosts_path}..."
        write_file(hosts_path, hosts_body)
      end

      # Executes the command
      def execute
        set_name_tag
        set_hostname
        update_hosts
        puts 'Done.'
      end
    end # class Identify
  end # module Commands
end # module VScripts
