require 'trollop'
require 'vscripts/version'
require 'vscripts/commands'

module VScripts
  # Global Command Line
  class CommandLine
    # @return [Array] All the command line arguments
    attr_accessor :arguments
    # @return [Hash] Global command line arguments
    attr_reader :global
    # @return [String] Command name
    attr_reader :command

    # Build command line arguments
    def initialize(argv = [])
      @arguments ||= argv
      @global    ||= parse_cli_options
      @command   ||= verify_command
    end

    # Specifies command line options
    # This method smells of :reek:NestedIterators but ignores them
    # This method smells of :reek:TooManyStatements but ignores them
    def parser # rubocop:disable MethodLength
      available = Commands.list.map { |cmd| cmd.to_s.downcase }
      @parser ||= Trollop::Parser.new do
        version VScripts::VERSION_C
        banner <<-EOS
VScripts automation daemon.

Available commands:
        #{available}

Usage:
  vscripts GLOBAL-OPTIONS COMMAND OPTIONS

For help on an individual command:
  vscripts COMMAND --help

Global Options:
EOS
        stop_on available
      end
    end

    # Parses command line arguments
    def parse_cli_options
      Trollop.with_standard_exception_handling parser do
        fail Trollop::HelpNeeded if arguments.empty?
        parser.parse arguments
      end
    end

    # Ensure command is available
    # @return [String] Command name
    def verify_command
      command_cli = arguments.shift
      command_cls = command_cli.capitalize.to_sym
      if Commands.list.include?(command_cls)
        return command_cls
      else
        abort "Error: Unknown subcommand '#{command_cli}'\nTry --help."
      end
    end
  end # class CommandLine
end # module VScripts
