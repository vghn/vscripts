require 'yaml'

module VScripts
  # VScripts Configuration
  class Config
    # User's configuration file
    DOT_FILE   = "#{File.expand_path('~')}/.vscripts.yml"
    # Global configuration file
    SYSTEM_CONFIG_FILE = '/etc/vscripts/config.yml'
    # Global defaults
    GLOBAL_DEFAULTS = {}

    # @return [Hash] all configuration options
    attr_reader :get

    # Loads class
    # @param cfg_file [String] the path to the configuration file
    def initialize(cfg_file = nil)
      @cfg_file ||= cfg_file
    end

    # @return [Hash] the configuration options
    def get
      @get ||= GLOBAL_DEFAULTS.merge(options)
    end

    # Parses the configuration files in order
    # @return [Hash] the first configuration hash found
    def options
      parse(@cfg_file) ||
        parse(DOT_FILE) ||
        parse(SYSTEM_CONFIG_FILE) ||
        {}
    end

    # Parses the configuration
    # @param file [String] the path to the configuration file
    # @return [Hash] the configuration hash
    def parse(file)
      YAML.load(read(file)) if check_config(file)
    end

    # @param (see #parse)
    # @return [String] the contents of the file
    def read(file)
      File.read(file)
    end

    # @param (see #parse)
    # @return [Boolean] true if the file exists
    def check_config(file)
      file && File.exist?(file)
    end
  end # class Config
end # module VScripts
