require 'spec_helper'
require 'vscripts/aws'

describe VScripts::AWS::Metadata do
  subject { Class.new { extend VScripts::AWS } }

  before(:each) do
    allow(subject).to receive_message_chain('open.read')
      .and_return('Remote server response')
  end

  describe '#metadata_url' do
    it 'returns metadata url string' do
      expect(subject.metadata_url).to be_a String
    end
  end

  describe '#zone' do
    it 'returns zone string' do
      expect(subject.zone).to eq('Remote server response')
    end
  end

  describe '#region' do
    it 'returns region string' do
      allow(subject).to receive(:zone).and_return('us-test-1a')
      expect(subject.region).to eq('us-test-1')
    end
  end

  describe '#instance_id' do
    it 'returns instance id string' do
      expect(subject.instance_id).to eq('Remote server response')
    end
  end

  describe '#public_hostname' do
    it 'returns public hostname string' do
      expect(subject.public_hostname).to eq('Remote server response')
    end
  end

  describe '#ec2_instance?' do
    it 'returns true if metadata accessible' do
      allow(Net::HTTP).to receive(:get_response).and_return(true)
      expect(subject.ec2_instance?).to be true
    end
    it 'returns false if metadata not accessible' do
      allow(Net::HTTP).to receive(:get_response).and_raise(StandardError)
      expect(subject.ec2_instance?).to be false
    end
  end

  describe '#check_instance' do
    it 'exits if not ec2 instance' do
      $stderr = StringIO.new
      allow(subject).to receive(:ec2_instance?).and_return(false)
      expect { subject.check_instance }.to raise_error(SystemExit)
      $stderr = STDERR
    end
  end
end
