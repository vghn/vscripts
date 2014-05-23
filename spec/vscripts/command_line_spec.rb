require 'vscripts/command_line'

describe VScripts::CommandLine do
  before :each do
    @cmd = VScripts::Command.list.first.to_s
    @cli = VScripts::CommandLine.new([@cmd, 'extra_args'])
  end

  describe '#new' do
    it 'returns the command line arguments' do
      expect(@cli).to be_an_instance_of VScripts::CommandLine
    end
  end

  describe '#global' do
    it 'returns the global options as a Hash' do
      expect(@cli.global).to be_an_instance_of Hash
    end
  end

  describe '#command' do
    it 'returns the command name' do
      expect(@cli.command).to be_a Symbol
      expect(@cli.command).to eql @cmd.capitalize.to_sym
    end
  end

  describe '#extra' do
    it 'returns the rest of the arguments as an Array' do
      expect(@cli.arguments).to be_an_instance_of Array
      expect(@cli.arguments).to eql ['extra_args']
    end
  end
end
