require 'integration/spec_helper'

describe 'Command: Identify' do
  include_context 'System files'
  include_context 'Suppressed output'

  subject { VScripts }

  before(:each) do
    allow_any_instance_of(VScripts::Commands::Identify)
      .to receive('`')
  end

  context 'when \'--help\'' do
    it 'returns command specific help' do
      expect{subject.run(['identify', '--help'])}.to raise_error(SystemExit)
      expect($stdout.string).to match(/USAGE:/)
      expect($stdout.string).to match(/OPTIONS:/)
    end
  end

  context 'when unknown argument' do
    it 'returns error with message' do
      expect{subject.run(['identify', '--xyz'])}.to raise_error(SystemExit)
      expect($stderr.string).to match(/Error: unknown argument/)
    end
  end

  context 'when not an EC2 instance' do
    include_context 'Not an EC2 Instance'
    it 'returns error with message' do
      expect{subject.run(['identify'])}.to raise_error(SystemExit)
      expect($stderr.string)
        .to match('FATAL: NOT an EC2 instance or could not connect to Metadata')
    end
  end

  context 'when EC2 instance' do
    include_context 'EC2 Instance without tags'

    context 'without tags' do
      it 'writes default hostname' do
        allow_any_instance_of(VScripts::Commands::Identify).to receive(:tag)
        subject.run(['identify'])
        expect(IO.read(hostname_file)).to eq('1')
        expect($stdout.string).to match('Done.')
      end
    end

    context 'and when \'--ec2-tag-theme\'' do
      it 'returns the themed host' do
        allow_any_instance_of(VScripts::Commands::Identify).to receive(:tag)
          .and_return('TestValue')
        subject.run(['identify', '--ec2-tag-theme=Test-#'])
        expect(IO.read(hostname_file)).to eq('TestValue-1')
      end
    end

    context 'and when \'--host\'' do
      it 'returns the new host' do
        subject.run(['identify', '--host=test-host'])
        expect(IO.read(hostname_file)).to eq('test-host')
      end
    end

    context 'and when \'--domain\'' do
      it 'returns the new domain' do
        subject.run(['identify', '--domain=example.tld'])
        expect(IO.read(hosts_file)).to match('example.tld')
      end
    end

    context 'and when similar found' do
      it 'returns the incremented host' do
        allow_any_instance_of(VScripts::Commands::Identify).to receive(:tag)
          .and_return('TestName')
        allow_any_instance_of(VScripts::Commands::Identify).to receive(:domain)
          .and_return('TestDomain.tld')
        subject.run(['identify', '--ec2-tag-theme=Test-#'])
        expect(IO.read(hostname_file)).to eq('TestName-2')
        expect(IO.read(hosts_file)).to match('TestName-2.TestDomain.tld')
      end
    end
   end
end
