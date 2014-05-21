require 'trollop'
require 'vscripts/command'

module VScripts
  # Global Command Line
  class CommandLine
    # @return [Hash] Global command line arguments
    attr_reader :global
    # @return [String] Command name
    attr_reader :command
    # @return [Array] Extra arguments passed to the command
    attr_reader :extra

    # Build command line arguments
    def initialize(*args)
      @global ||= parse(*args)
      @command ||= check_command(*args)
      @extra ||= rest(*args)
    end

    # Specifies command line options
    # This method smells of :reek:NestedIterators but ignores them
    # This method smells of :reek:TooManyStatements but ignores them
    def parser # rubocop:disable MethodLength
      available = Command.list
      Trollop::Parser.new do
        version VScripts::VERSION_C
        banner <<-EOS
VScripts automation daemon.

Available commands:
        #{available.map { |cmd| cmd.to_s.downcase }}

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
    def parse(*args)
      Trollop.with_standard_exception_handling parser do
        fail Trollop::HelpNeeded if args.empty?
        parser.parse args
      end
    end

    # Ensure command is available
    # @return [String] Command name
    def check_command(args)
      command_cli = args.shift
      command_cls = command_cli.capitalize.to_sym
      if command_cli && Command.list.include?(command_cls)
        return command_cls
      else
        puts "Error: Unknown subcommand '#{command_cli}'"
        puts 'Try --help for help.'
        exit 1
      end
    end

    # @return [Array] The rest of the arguments
    def rest(args)
      args
    end
  end # class CommandLine
end # module VScripts
