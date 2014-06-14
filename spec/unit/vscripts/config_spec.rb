require 'spec_helper'
require 'vscripts/config'

describe VScripts::Config do
  include_context 'Temporary'
  subject { VScripts::Config.new }

  describe '#new' do
    context 'when config file not passed' do
      it 'returns nil' do
        expect(subject.instance_variable_get(:@file)).to be_nil
      end
    end
    context 'when config file passed' do
      it 'returns the path' do
        subject = VScripts::Config.new('/path/to/file')
        expect(subject.instance_variable_get(:@file)).to eq('/path/to/file')
      end
    end
  end

  describe '#get' do
    it 'returns a Hash' do
      expect(subject.get).to be_a Hash
    end
  end

  describe '#options' do
    it 'returns a Hash' do
      expect(subject.options).to be_a Hash
    end
  end

  describe '#parse' do
    it 'returns a Hash' do
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:read).and_return('testkey: testvalue')
      expect(subject.parse('test')).to be_a Hash
    end
  end

  describe '#read' do
    it 'returns a String' do
      expect(subject.read(test_file)).to be_a String
    end
  end

  describe '#check_config' do
    it 'returns Boolean' do
      expect(subject.check_config(test_file))
    end
  end
end
