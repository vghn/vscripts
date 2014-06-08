require 'spec_helper'
require 'vscripts/commands/tags2facts'

describe VScripts::Commands::Tags2facts do
  subject { VScripts::Commands::Tags2facts.new(['extra_args']) }
  before :each do
    allow_any_instance_of(VScripts::Commands::Tags2facts).to receive(:check_instance)
      .and_return(true)
    allow_any_instance_of(VScripts::Commands::Tags2facts).to receive(:region)
      .and_return('us-east-1')
  end

  describe '#new' do
    it 'returns cli arguments' do
      expect(subject.cli).to be_a Hash
    end
  end

  describe '#parser' do
    it 'returns parser' do
      expect(subject.parser).to be_an_instance_of Trollop::Parser
    end
  end

  describe '#exclude_list' do
    it 'returns exclude list' do
      expect(subject.exclude_list).to eq(['Name', 'Domain'])
    end
  end

  describe '#tags_json' do
    it 'returns JSON formatted string' do
      $stderr = StringIO.new
      allow(subject).to receive(:tags_without)
        .and_return({}, { key: 'value' })
      expect{subject.tags_json}.to raise_error(SystemExit)
      expect(subject.tags_json).to eq("{\n  \"key\": \"value\"\n}")
      $stderr = STDERR
    end
  end

  describe '#execute' do
    it 'executes the command' do
      $stdout = StringIO.new
      allow(subject).to receive(:tags_json)
      allow(subject).to receive(:ensure_file_content)
      subject.execute
      expect($stdout.string).to match(/Writing tags to/)
      $stdout = STDOUT
    end
  end
end
