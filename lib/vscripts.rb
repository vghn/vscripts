require 'vscripts/command'
require 'vscripts/command_line'

# Main VScripts module
module VScripts
  # Gets the command name from command line and calls the right class.
  def self.run(*args)
    cli     = CommandLine.new(*args)
    command = VScripts::Commands.const_get(cli.command).new(*cli.extra)
    command.execute
  end
end # module VScripts
