require 'spec_helper'
require 'vscripts/aws'

describe VScripts::AWS::EC2 do
  subject { Object.new.extend VScripts::AWS }

  let(:tags) { {'Name' => 'test'} }
  let(:fake_instances) {::AWS::Core::Data.new([
    {id: '1111', status: :running},
    {id: '2222', status: :running, tags: tags},
    {id: '3333', status: :terminated}
  ])}

  before :each do
    allow(subject).to receive(:check_instance).and_return(true)
    allow(subject).to receive(:instance_id).and_return(fake_instances[0].id)
    allow(subject).to receive(:region).and_return('us-east-1')
  end

  describe '#ec2' do
    it 'returns AWS::EC2' do
      expect(subject.ec2).to be_an_instance_of ::AWS::EC2
    end
  end

  describe '#instance' do
    it 'returns AWS::EC2' do
      expect(subject.instance).to be_an_instance_of ::AWS::EC2::Instance
      expect(subject.instance.id).to eq(fake_instances[0].id)
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
      resource = ::AWS.ec2.instances['i-12345678']
      expect(subject.create_tag(resource, 'TestTag', value: 'TestValue'))
        .to be_an_instance_of ::AWS::EC2::Tag
    end
  end

  describe '#create_tag' do
    it 'creates tag' do
      allow(subject).to receive_message_chain('instance.tags')
        .and_return(tags)
      expect(subject.tag('Name'))
        .to eq('test')
    end
  end

  describe '#all_tags_hash' do
    it 'returns a Hash' do
      allow(subject).to receive('all_tags')
        .and_return(tags)
      expect(subject.all_tags_hash).to be_an_instance_of Hash
      expect(subject.all_tags_hash).to eq({"Name"=>"test"})
    end
  end

  describe '#tags_without' do
    it 'returns a filtered Hash' do
      allow(subject).to receive('all_tags')
        .and_return(tags)
      expect(subject.tags_without).to be_an_instance_of Hash
      expect(subject.tags_without(['Name'])).to be_empty
    end
  end

  describe '#name' do
    it 'returns Hash value' do
      allow(subject).to receive(:all_tags_hash).and_return(tags)
      expect(subject.name).to eq(tags['Name'])
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
      allow(subject).to receive(:named_instances)
        .and_return(fake_instances)
      expect(subject.functional_instances).to be_an Array
      expect(subject.functional_instances)
        .to include(fake_instances[0], fake_instances[1])
    end
  end

  describe '#similar_instances' do
    it 'returns an Array' do
      allow(subject).to receive(:functional_instances)
        .and_return([fake_instances[0], fake_instances[1]])
      expect(subject.similar_instances).to include(tags['Name'])
    end
  end
end
