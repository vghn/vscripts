require 'fileutils'
require 'yaml'
require 'English'

module VScripts
  module Util
    # Local system functions library
    module LocalSystem
      # Hosts file path
      def hosts_path
        '/etc/hosts'
      end

      # Hostname file path
      def hostname_path
        '/etc/hostname'
      end

      # Returns the current fully qualified domain
      def local_fqdn
        `hostname -f`.strip
      end

      # Returns the local host name
      def local_host_name
        `hostname`.strip
      end

      # Returns the local domain name
      def local_domain_name
        `dnsdomainname`.strip
      rescue
        'local'
      end

      # Tries to get the reverse dns
      def external_dns
        ext_ip = `wget -q -O - checkip.dyndns.org \
          | sed -e 's/[^[:digit:]|.]//g'`
        `dig +short -x #{ext_ip}`.strip
      rescue
        false
      end

      # Creates the directory for the specified file
      def ensure_file_dir(file)
        path = File.dirname(file)
        `mkdir -p #{path}`
      end

      # Writes to file
      def write_file(file, body)
        ensure_file_dir(file)
        File.open(file, 'w') do |newfile|
          newfile.write(body)
        end
      rescue Errno::EACCES
        puts "FATAL: You need to be root in order to write to #{file}"
      end

      # Ensures the specified file has the specified content
      def ensure_file_content(file, body)
        write = write_file(file, body)
        read  = IO.read(file)
        read == body || write
      rescue
        write
      end

      # Gets system checks from environment variables
      def checks
        config['SystemChecks']
      rescue
        {}
      end

      # Runs each command specified and returns the name and exit status
      def process_checks
        codes = {}
        checks.each do |name, command|
          system("#{command} > /dev/null 2>&1")
          codes[name] = $CHILD_STATUS.exitstatus
        end
        codes
      end

      # Extract the codes for each check
      def status_codes
        process_checks.values.compact
      end
    end # module LocalSystem
  end # module Util
end # module VScripts
