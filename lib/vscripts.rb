require 'vscripts/commands'
require 'vscripts/command_line'

# Main VScripts module
module VScripts
  # Gets the command name from command line and calls the right class.
  def self.run(argv)
    cli = CommandLine.new(argv)
    command = VScripts::Commands.const_get(cli.command).new(cli.arguments)
    command.execute
  end
end # module VScripts
