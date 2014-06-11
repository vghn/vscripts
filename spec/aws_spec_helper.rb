require 'spec_helper'
require 'aws-sdk'

shared_context 'Not an EC2 Instance' do
  before(:each) do
   allow(Net::HTTP).to receive(:get_response).and_return(false)
  end
end

shared_context 'Amazon Web Services' do
  # Preload AWS library
  AWS.eager_autoload! AWS::Core     # Make sure to load Core first.
  AWS.eager_autoload! AWS::EC2      # Load the EC2 class

  ::AWS.config({
    :access_key_id => '1234',
    :secret_access_key => '5678',
    :logger => nil,
    :stub_requests => true
  })

  let(:region) {'us-east-1'}

  let(:fake_instances) {::AWS::Core::Data.new([
    {id: 'i-abcdefg1', status: :running, tags: tags},
    {id: 'i-abcdefg2', status: :terminated, tags: tags},
    {id: 'i-abcdefg3', status: :running, tags: {}},
    {id: 'i-abcdefg4', status: :terminated, tags: {}},
  ])}

  let(:tags) {{
    'Name' => 'TestName-1.TestDomain.tld',
    'Domain' => 'TestDomainValue.tld',
    'TestTagKey' => 'TestTagValue',
  }}

  before(:each) do
    allow_any_instance_of(VScripts::AWS::EC2)
      .to receive_message_chain('ec2.instances.tagged')
      .and_return(fake_instances)
    allow_any_instance_of(VScripts::AWS::EC2)
      .to receive_message_chain(:named_instances)
      .and_return(fake_instances[0..1])
  end
end

shared_context 'EC2 Instance' do
  include_context 'Amazon Web Services'

  before(:each) do
    allow(Net::HTTP).to receive(:get_response).and_return(true)
    allow(VScripts::AWS::Metadata).to receive_message_chain('open.read')
      .and_return('Remote server response')
    allow_any_instance_of(VScripts::AWS::Metadata).to receive(:zone)
    allow_any_instance_of(VScripts::AWS::Metadata).to receive(:region)
      .and_return('us-east-1')
    allow_any_instance_of(VScripts::AWS::Metadata).to receive(:instance_id)
      .and_return(fake_instances[1].id)
    allow_any_instance_of(VScripts::AWS::EC2)
      .to receive_message_chain('ec2.tags.create')
  end
end

shared_context 'EC2 Instance without tags' do
  include_context 'EC2 Instance'

  before(:each) do
    allow_any_instance_of(VScripts::AWS::EC2)
      .to receive_message_chain('instance.tags')
      .and_return({})
  end
end

shared_context 'EC2 Instance with tags' do
  include_context 'EC2 Instance'

  before(:each) do
     allow_any_instance_of(VScripts::AWS::EC2)
      .to receive_message_chain('instance.tags')
       .and_return(tags)
  end
end
