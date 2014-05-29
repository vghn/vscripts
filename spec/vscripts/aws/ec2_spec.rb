require 'spec_helper'
require 'vscripts/aws/ec2'
require 'ostruct'

describe VScripts::AWS::EC2 do
  before :each do
    ::AWS.config({
      :access_key_id => '1234',
      :secret_access_key => '5678',
      :region => 'us-east-1',
      :logger => nil,
      :stub_requests => true
    })

    @tags = {'Name' => 'test'}

    @inst1 = OpenStruct.new(id: '1111', status: :running)
    @inst2 = OpenStruct.new(id: '2222', status: :running, tags: @tags)
    @inst3 = OpenStruct.new(id: '3333', status: :terminated)

    @ec2 = VScripts::AWS::EC2
    @ec2.any_instance.stub(:check_instance) { true }
    @ec2.any_instance.stub(:instance_id) { @inst1.id }
    @ec2.any_instance.stub(:region) { 'us-east-1' }
  end

  describe '#instance' do
    it 'returns AWS::EC2' do
      expect(subject.ec2).to be_an_instance_of ::AWS::EC2
    end
  end

  describe '#new' do
    it 'returns AWS::EC2::Instance' do
      expect(subject.instance).to be_an_instance_of ::AWS::EC2::Instance
      expect(subject.instance.id).to eq(@inst1.id)
    end
  end

  describe '#all_tags' do
    it 'returns AWS::EC2::ResourceTagCollection' do
      expect(subject.all_tags)
        .to be_an_instance_of ::AWS::EC2::ResourceTagCollection
    end
  end

  describe '#tag' do
    it 'returns the tag value' do
      subject.stub_chain(:instance, :tags) {@tags}
      expect(subject.tag('Name'))
        .to eq('test')
    end
  end

  describe '#tags_without' do
    it 'returns a Hash' do
      expect(subject.tags_without)
        .to be_an_instance_of ::AWS::EC2::ResourceTagCollection
    end
  end

  describe '#name' do
    it 'returns Hash value' do
      subject.stub(:all_tags_hash) {@tags}
      expect(subject.name).to eq(@tags['Name'])
    end
  end

  describe '#named_instances' do
    it 'returns AWS::EC2::InstanceCollection' do
      expect(subject.named_instances)
        .to be_an_instance_of ::AWS::EC2::InstanceCollection
    end
  end

  describe '#functional_instances' do
    it 'returns an Array' do
      subject.stub(:named_instances) { [@inst1, @inst2, @inst3] }
      expect(subject.functional_instances).to be_an Array
      expect(subject.functional_instances).to include(@inst1, @inst2)
    end
  end

  describe '#similar_instances' do
    it 'returns an Array' do
      subject.stub(:functional_instances) { [@inst1, @inst2] }
      expect(subject.similar_instances).to include(@tags['Name'])
    end
  end
end
