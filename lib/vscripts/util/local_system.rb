module VScripts
  module Util
    # Local system functions library.
    module LocalSystem
      # @return [String] the hosts file path
      def hosts_path
        '/etc/hosts'
      end

      # @return [String] the hostname file path
      def hostname_path
        '/etc/hostname'
      end

      # @return [String] the local fully qualified domain
      def local_fqdn
        `hostname -f`.strip
      end

      # @return [String] the local host name
      def local_host_name
        `hostname`.strip
      end

      # @return [String] the local domain name
      def local_domain_name
        `dnsdomainname`.strip
      rescue
        'local'
      end

      # Tries to get the reverse dns
      # @return [String] the reverse dns
      def external_dns
        ext_ip = `wget -q -O - checkip.dyndns.org \
          | sed -e 's/[^[:digit:]|.]//g'`
        `dig +short -x #{ext_ip}`.strip
      rescue
        false
      end

      # Creates the directory for the specified file
      # @param file [String] the path of the file
      def ensure_file_dir(file)
        path = File.dirname(file)
        `mkdir -p #{path}`
      end

      # Writes to a file
      # @param file [String] the path of the file
      # @param body [String] the body of the file
      def write_file(file, body)
        ensure_file_dir(file)
        File.open(file, 'w') do |newfile|
          newfile.write(body)
        end
      rescue Errno::EACCES
        abort "FATAL: You need to be root in order to write to #{file}"
      end

      # Ensures the specified file has the specified content
      # @param file [String] the path of the file
      # @param body [String] the body of the file
      def ensure_file_content(file, body)
        write = write_file(file, body)
        read  = IO.read(file)
        read == body || write
      end
    end # module LocalSystem
  end # module Util
end # module VScripts
