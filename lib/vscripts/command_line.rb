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
    def parser
      available = Command.list
      Trollop::Parser.new do
        version VScripts::VERSION_C
        banner <<-EOS
VScripts automation daemon.

Available commands:
  #{available.map { |cmd| cmd.to_s }}

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
      @command = args.shift
      if Command.list.include?(@command.to_sym)
        return @command
      else
        fail "Unknown subcommand #{@command.inspect}"
      end
    end

    # @return [Array] The rest of the arguments
    def rest(args)
      args
    end
  end # class CommandLine
end # module VScripts
