require 'trollop'
require 'vscripts/version'
require 'vscripts/commands'

module VScripts
  # Parses the command line arguments
  class CommandLine
    # @return [Hash] the global command line arguments.
    attr_reader :global
    # @return [String] the command name
    attr_reader :command
    # @return [Array] the command specific arguments.
    attr_reader :command_options

    # @param args [Array] the command line arguments
    # @return [Hash] the command line options
    def initialize(args = ARGV)
      parse_global(args)
    end

    # Specifies command line options
    # This method smells of :reek:NestedIterators but ignores them
    # This method smells of :reek:TooManyStatements but ignores them
    def parser # rubocop:disable MethodLength
      available = Commands.list.map { |cmd| cmd.to_s.downcase }
      Trollop::Parser.new do
        version VScripts::VERSION::COPYRIGHT
        banner <<-EOS
VScripts automation daemon.

Available commands:
        #{available}

USAGE:
  vscripts GLOBAL-OPTIONS COMMAND OPTIONS

For help on an individual command:
  vscripts COMMAND --help

GLOBAL OPTIONS:
EOS
        opt :config, 'Specify configuration file',
            type: :string, short: '-c'
        stop_on available
        stop_on_unknown
      end
    end

    # @param args [Array] the command line arguments
    # @return [Hash] the command line options
    def parse_global(args)
      Trollop.with_standard_exception_handling parser do
        @global = parser.parse args
        fail Trollop::HelpNeeded if args.empty? || !parse_command(args)
      end
      @global
    end

    # Ensures command is available
    # @return [String] the command name
    # @return [Array] the command specific arguments
    def parse_command(args)
      command = args.shift
      return unless command
      command_class = command.capitalize.to_sym
      abort "Error: unknown subcommand '#{command}'\nTry --help." \
        unless Commands.list.include?(command_class)
      @command = command_class
      @command_options = args
    end
  end # class CommandLine
end # module VScripts
