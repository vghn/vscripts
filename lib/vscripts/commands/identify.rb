require 'vscripts/aws'
require 'vscripts/util'

module VScripts
  # Commands module
  module Commands
    # Identify Class
    class Identify # rubocop:disable ClassLength
      include VScripts::AWS
      include VScripts::Util

      # Shows help
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

  USAGE:
  $ vscripts identify
  MyGroup-MyRole-1.Example.tld
  $ vscripts identify --ec2-tag-theme NAME-#
  MyName-1.Example.tld`
  $ vscripts identify --host myhost --domain example.com
  myhost.example.com`

  OPTIONS:
      EOS

      # @return [String] the theme
      attr_reader :theme
      # @return [String] the host name
      attr_reader :host
      # @return [String] the domain name
      attr_reader :domain
      # @return [Array] the command specific arguments
      attr_reader :arguments

      # Loads the Identify command
      # @param argv [Array] the command specific arguments
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

      # @return [Hash] the command line arguments
      def cli
        @cli ||= Trollop.with_standard_exception_handling parser do
          parser.parse arguments
        end
      end

      # Splits theme into elements
      # @return [Array] the theme elements
      def theme_elements
        theme.split('-')
      end

      # Lists values corresponding to each tag specified in the theme
      # @return [Array] the values list
      def map2tags
        theme_elements.map do |element|
          element == '#' ? element : tag(element)
        end
      end

      # Composes the host name based on found tags
      # @return [String] the new host name
      def themed_host_name
        map2tags.compact.join('-')
      end

      # Increments the new hostname if it finds similar ones
      # @return [String] the incremented host name
      def incremented_hostname
        number = 1
        while similar_instances.include? "#{themed_host_name}.#{domain}"
          .sub(/#/, "#{number}")
          number += 1
        end
        "#{themed_host_name}".sub(/#/, "#{number}")
      end

      # The command line `--host` argument, the themed hostname or the existing
      # local hostname
      # @return [String] the new hostname
      def new_hostname
        host || incremented_hostname || local_host_name
      end

      # The value of the command line `--domain` argument, or the
      # value of the 'Domain' EC2 tag or the local domain name.
      # @return [String] the new domain name
      def new_domain
        domain || tag('Domain') || local_domain_name
      end

      # @return [String] the fully qualified domain name
      def new_fqdn
        "#{new_hostname}.#{new_domain}"
      end

      # Modifies the 'Name' tag
      def set_name_tag
        return if tag('Name') == new_fqdn
        puts "Setting name tag to \"#{new_fqdn}\"..."
        create_tag(instance, 'Name', value: new_fqdn)
      end

      # Modifies the host name
      def set_hostname
        return unless File.exist?(hostname_path)
        return if File.read(hostname_path).strip == new_hostname
        puts "Setting local hostname (#{new_hostname})..."
        write_file(hostname_path, new_hostname)
        `hostname -F /etc/hostname`
      end

      # Modifies the hosts file
      def update_hosts
        return unless File.exist?(hosts_path)
        return if File.readlines(hosts_path)
          .grep(/#{new_fqdn} #{new_hostname}/)
          .any?
        hosts_body = File.read(hosts_path).gsub(
          /^127\.0\.0\.1.*/,
          "127\.0\.0\.1 #{new_fqdn} #{new_hostname} localhost"
        )
        puts "Adding \"#{new_fqdn}\" to #{hosts_path}..."
        write_file(hosts_path, hosts_body)
      end

      # Executes the command
      def execute
        puts 'EC2 tag not changed!' unless set_name_tag
        puts 'Hostname not changed!' unless set_hostname
        puts 'Hosts file not changed!' unless update_hosts
        puts 'Done.'
      end
    end # class Identify
  end # module Commands
end # module VScripts
