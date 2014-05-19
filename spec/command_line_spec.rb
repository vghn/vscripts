require 'vscripts/command_line'

describe VScripts::CommandLine do
  before :each do
    @cmd = VScripts::Command.list.first.to_s
    @cli = VScripts::CommandLine.new([@cmd, 'extra_args'])
  end

  describe '#new' do
    it 'returns the command line arguments' do
      @cli.should be_an_instance_of VScripts::CommandLine
    end
  end

  describe '#global' do
    it 'returns the global options as a Hash' do
      @cli.global.should be_an_instance_of Hash
    end
  end

  describe '#command' do
    it 'returns the command name' do
      @cli.command.should be_a String
      @cli.command.should eql @cmd
    end
  end

  describe '#extra' do
    it 'returns the rest of the arguments as an Array' do
      @cli.extra.should be_an_instance_of Array
      @cli.extra.should eql ['extra_args']
    end
  end
end
