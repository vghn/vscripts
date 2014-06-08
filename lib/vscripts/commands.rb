require 'vscripts/commands/tags2facts'
require 'vscripts/commands/identify'

module VScripts
  # Commands module
  module Commands
    # @return [Array] the available commands
    def self.list
      VScripts::Commands.constants.select do |cls|
        VScripts::Commands.const_get(cls).is_a? Class
      end
    end
  end # class Command
end # module VScripts
