require 'spec_helper'
require 'vscripts'

describe 'Configuration' do
  let(:dotcfg) { "#{File.expand_path('~')}/.vscripts.yml" }
  let(:syscfg) { '/etc/vscripts/config.yml' }

  subject { VScripts::Config.new }

  before(:each) do
    allow(File).to receive(:read).with(dotcfg)
      .and_return('loaded: dot_file')
    allow(File).to receive(:read).with(syscfg)
      .and_return('loaded: sys_file')
  end

  it 'loads the configuration' do
    expect(subject.get).to be_a Hash
  end

  context 'and if a config file exists' do
    it 'returns an empty hash if file is empty' do
      allow(File).to receive(:exist?).and_return(false)
      expect(subject.get).to be_empty
    end
    it 'returns a hash if file not empty' do
      allow(File).to receive(:exist?).and_return(true)
      expect(subject.get).to be_a Hash
      expect(subject.get).not_to be_empty
    end
  end

  context 'and if both files exist' do
    it 'returns the command line configuration first' do
      allow(File).to receive(:exist?).and_return(true)
      allow(File).to receive(:read)
        .and_return('---\nloaded: cli_file')
      expect(subject.get).to be_a Hash
      expect(subject.get.values.first).to eq('cli_file')
    end

    it 'returns the dotfiles second' do
      allow(File).to receive(:exist?).with(dotcfg).and_return(true)
      allow(File).to receive(:exist?).with(syscfg).and_return(true)
      expect(subject.get).to be_a Hash
      expect(subject.get.values.first).to eq('dot_file')
    end

    it 'and system file second third' do
      allow(File).to receive(:exist?).with(dotcfg).and_return(false)
      allow(File).to receive(:exist?).with(syscfg).and_return(true)
      expect(subject.get).to be_a Hash
      expect(subject.get.values.first).to eq('sys_file')
    end
  end
end
