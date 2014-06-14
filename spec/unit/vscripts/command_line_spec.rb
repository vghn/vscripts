require 'spec_helper'
require 'vscripts/command_line'

describe VScripts::CommandLine do
  let(:cmd) { VScripts::Commands.list.first.to_s }

  subject { VScripts::CommandLine.new([cmd, 'extra_args']) }

  describe '#new' do
    it 'returns the command line arguments' do
      expect(subject).to be_an_instance_of VScripts::CommandLine
    end
  end

  describe '#global' do
    it 'returns the global options as a Hash' do
      expect(subject.global).to be_a Hash
    end
  end

  describe '#command' do
    it 'returns the command name' do
      expect(subject.command).to be_a Symbol
      expect(subject.command).to eql cmd.capitalize.to_sym
    end
  end

  describe '#extra' do
    it 'returns the rest of the arguments as an Array' do
      expect(subject.command_options).to be_an_instance_of Array
      expect(subject.command_options).to eql ['extra_args']
    end
  end

  describe '#verify_command' do
    it 'fails if command not present' do
      $stderr = StringIO.new
      expect {
        VScripts::CommandLine.new(['TestCommand', 'TestArguments']).command
      }.to raise_error(SystemExit)
      $stderr = STDERR
    end
  end
end
