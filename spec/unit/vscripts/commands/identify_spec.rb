require 'spec_helper'
require 'vscripts/commands/identify'

describe VScripts::Commands::Identify do
  before :each do
    allow(subject).to receive(:tag).and_return('TestTag')
    allow(subject).to receive(:similar_instances)
      .and_return(['TestTag-TestTag-1.'])
  end

  describe 'USAGE' do
    it 'returns a String' do
      expect(VScripts::Commands::Identify::USAGE).to be_a String
    end
  end

  describe '#new' do
    context 'when theme is not passed' do
      it 'returns the default theme' do
        expect(subject.theme).to eq('Group-Role-#')
      end
    end

    context 'when theme is passed' do
      it 'returns the theme' do
        subject1 = VScripts::Commands::Identify.new(['--ec2-tag-theme=test'])
        expect(subject1.theme).to eq('test')
      end
    end

    context 'when host is not passed' do
      it 'host is nil' do
        expect(subject.host).to be_nil
      end
    end

    context 'when host is passed' do
      it 'returns the host' do
        subject2 = VScripts::Commands::Identify.new(['--host=test'])
        expect(subject2.host).to eq('test')
      end
    end

    context 'when domain is not passed' do
      it 'domain is nil' do
        expect(subject.domain).to be_nil
      end
    end

    context 'when domain is passed' do
      it 'returns the domain' do
        subject3 = VScripts::Commands::Identify.new(['--domain=test'])
        expect(subject3.domain).to eq('test')
      end
    end
  end

  describe '#parser' do
    it 'returns Trollop' do
      expect(subject.parser).to be_a Trollop::Parser
    end
  end

  describe '#cli' do
    it 'returns cli arguments as a Hash' do
      expect(subject.cli).to be_a Hash
    end
  end

  describe '#theme_elements' do
    it 'returns an array' do
      expect(subject.theme_elements).to eq(['Group', 'Role', '#'])
    end
  end

  describe '#map2tags' do
    it 'returns an array' do
      expect(subject.map2tags).to eq(['TestTag', 'TestTag', '#'])
    end
  end

  describe '#themed_host_name' do
    it 'returns a string' do
      expect(subject.themed_host_name).to eq('TestTag-TestTag-#')
    end
  end

  describe '#incremented_hostname' do
    it 'returns a string' do
      expect(subject.incremented_hostname).to eq('TestTag-TestTag-2')
    end
  end

  describe '#new_hostname' do
    context 'when host is not passed' do
      it 'hostname is incremented' do
        expect(subject.new_hostname).to eq('TestTag-TestTag-2')
      end
    end

    context 'when host is passed' do
      it 'returns a string' do
        subject4 = VScripts::Commands::Identify.new(['--host=test'])
        expect(subject4.new_hostname).to eq('test')
      end
    end
  end

  describe '#new_domain' do
    context 'when domain is not passed' do
      context 'when tag is not present' do
        it 'returns a String' do
          allow(subject).to receive(:tag)
          allow(subject).to receive(:local_domain_name).and_return('local')
          expect(subject.new_domain).to eq('local')
        end
      end

      context 'when tag is present' do
        it 'returns a String' do
          allow(subject).to receive(:tag)
            .and_return('Test')
          expect(subject.new_domain).to eq('Test')
        end
      end
    end

    context 'when domain is passed' do
      it 'returns a string' do
        subject5 = VScripts::Commands::Identify.new(['--domain=test'])
        expect(subject5.new_domain).to eq('test')
      end
    end
  end

  describe '#new_fqdn' do
    it 'returns a string' do
      expect(subject.new_fqdn).to eq('TestTag-TestTag-2.TestTag')
    end
  end

  describe '#set_name_tag' do
    it 'returns a string' do
      allow(subject).to receive(:create_tag).and_return(true)
      allow(subject).to receive(:instance).and_return(true)
      allow(subject).to receive(:puts)
      expect(subject.set_name_tag).to be true
    end
  end

  describe '#set_hostname' do
    it 'returns nil' do
      allow(subject).to receive('`')
      allow(subject).to receive(:write_file)
      allow(subject).to receive(:puts)
      allow(File).to receive('read').and_return('test')
      expect(subject.set_hostname).to be_nil
    end
  end

  describe '#update_hosts' do
    it 'returns nil' do
      allow(subject).to receive(:write_file)
      allow(subject).to receive(:puts)
      expect(subject.update_hosts).to be_nil
    end
  end

  describe '#execute' do
    it 'returns nil' do
      allow(subject).to receive(:set_name_tag)
      allow(subject).to receive(:set_hostname)
      allow(subject).to receive(:update_hosts)
      allow(STDOUT).to receive(:puts)
      expect(subject.execute).to be_nil
    end
  end
end
