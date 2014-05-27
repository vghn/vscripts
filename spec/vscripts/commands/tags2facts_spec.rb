require 'vscripts/commands/tags2facts'

describe VScripts::Commands::Tags2facts do

  before :each do
    VScripts::AWS::EC2.any_instance.stub(:region) { 'us-east-1' }
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

  describe '#tags_json' do
    it 'returns JSON formatted string' do
      @tags2facts.stub_chain(:filtered_tags, :to_h) {{ key: 'value' }}
      expect(@tags2facts.tags_json).to eq("{\n  \"key\": \"value\"\n}")
    end
  end
end
