require 'spec_helper'
require 'vscripts/commands/tags2facts'

describe VScripts::Commands::Tags2facts do

  before :each do
    allow_any_instance_of(VScripts::AWS::EC2).to receive(:region)
      .and_return('us-east-1')
    @tags2facts = VScripts::Commands::Tags2facts.new(['extra_args'])
  end

  describe '#new' do
    it 'returns cli arguments and loads EC2 SDK' do
      expect(@tags2facts.cli).to be_a Hash
      expect(@tags2facts.ec2).to be_an_instance_of VScripts::AWS::EC2
    end
  end

  describe '#parser' do
    it 'returns parser' do
      expect(@tags2facts.parser).to be_an_instance_of Trollop::Parser
    end
  end

  describe '#exclude_list' do
    it 'returns exclude list' do
      expect(@tags2facts.exclude_list).to eq(['Name', 'Domain'])
    end
  end

  describe '#filtered_tags' do
    it 'returns a filtered list' do
      allow(@tags2facts.ec2).to receive(:tags_without)
      expect(@tags2facts.filtered_tags).to be_nil
    end
  end

  describe '#tags_json' do
    it 'returns JSON formatted string' do
      $stderr = StringIO.new
      allow(@tags2facts).to receive(:filtered_tags)
        .and_return({}, { key: 'value' })
      expect{@tags2facts.tags_json}.to raise_error(SystemExit)
      expect(@tags2facts.tags_json).to eq("{\n  \"key\": \"value\"\n}")
      $stderr = STDERR
    end
  end

  describe '#execute' do
    it 'executes the command' do
      $stdout = StringIO.new
      allow(@tags2facts).to receive(:tags_json)
      allow(@tags2facts).to receive(:ensure_file_content)
      @tags2facts.execute
      expect($stdout.string).to match(/Writing tags to/)
      $stdout = STDOUT
    end
  end
end
