require 'spec_helper'
require 'vscripts/commands/identify'

describe VScripts::Commands::Identify do
  before :each do
    @identify = VScripts::Commands::Identify.new
    allow(@identify).to receive_message_chain('ec2.tag').and_return('TestTag')
    allow(@identify).to receive_message_chain('ec2.similar_instances')
      .and_return(['TestTag-TestTag-1.'])
  end

  describe '#new' do
    context 'when theme is not passed' do
      it 'returns the default theme' do
        expect(@identify.theme).to eq('Group-Role-#')
      end
    end
    context 'when theme is passed' do
      it 'returns the theme' do
        @identify = VScripts::Commands::Identify.new(['--ec2-tag-theme=test'])
        expect(@identify.theme).to eq('test')
      end
    end
    context 'when host is not passed' do
      it 'host is nil' do
        expect(@identify.host).to be_nil
      end
    end
    context 'when host is passed' do
      it 'returns the host' do
        @identify = VScripts::Commands::Identify.new(['--host=test'])
        expect(@identify.host).to eq('test')
      end
    end
    context 'when domain is not passed' do
      it 'domain is nil' do
        expect(@identify.domain).to be_nil
      end
    end
    context 'when domain is passed' do
      it 'returns the domain' do
        @identify = VScripts::Commands::Identify.new(['--domain=test'])
        expect(@identify.domain).to eq('test')
      end
    end
  end

  describe '#theme_elements' do
    it 'returns an array' do
      expect(@identify.theme_elements).to eq(['Group', 'Role', '#'])
    end
  end

  describe '#map2tags' do
    it 'returns an array' do
      expect(@identify.map2tags).to eq(['TestTag', 'TestTag', '#'])
    end
  end

  describe '#themed_host_name' do
    it 'returns a string' do
      expect(@identify.themed_host_name).to eq('TestTag-TestTag-#')
    end
  end

  describe '#incremented_hostname' do
    it 'returns a string' do
      expect(@identify.incremented_hostname).to eq('TestTag-TestTag-2')
    end
  end

  describe '#new_hostname' do
    context 'when host is not passed' do
      it 'hostname is incremented' do
        expect(@identify.new_hostname).to eq('TestTag-TestTag-2')
      end
    end
    context 'when host is passed' do
      it 'returns a string' do
        @identify = VScripts::Commands::Identify.new(['--host=test'])
        expect(@identify.new_hostname).to eq('test')
      end
    end
  end

  describe '#new_domain' do
    context 'when domain is not passed' do
      context 'when tag is not present' do
        it 'returns a String' do
          allow(@identify).to receive_message_chain('ec2.tag')
          allow(@identify).to receive(:local_domain_name).and_return('local')
          expect(@identify.new_domain).to eq('local')
        end
      end
      context 'when tag is present' do
        it 'returns a String' do
          allow(@identify).to receive_message_chain('ec2.tag')
            .and_return('Test')
          expect(@identify.new_domain).to eq('Test')
        end
      end
    end
    context 'when domain is passed' do
      it 'returns a string' do
        @identify = VScripts::Commands::Identify.new(['--domain=test'])
        expect(@identify.new_domain).to eq('test')
      end
    end
  end
end
