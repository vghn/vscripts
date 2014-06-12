require 'integration/spec_helper'

describe 'Command: Identify' do
  include_context 'System files'
  include_context 'Suppressed output'
  include_context 'VScripts'

  before(:each) do
    allow_any_instance_of(identify).to receive('`')
  end

  context 'when \'--help\'' do
    it 'returns command specific help' do
      stub_cli_with('identify --help')
      expect{subject.run}.to raise_error(SystemExit)
      expect($stdout.string).to match(/USAGE:/)
      expect($stdout.string).to match(/OPTIONS:/)
    end
  end

  context 'when unknown argument' do
    it 'returns error with message' do
      stub_cli_with('identify --xyz')
      expect{subject.run}.to raise_error(SystemExit)
      expect($stderr.string).to match(/Error: unknown argument/)
    end
  end

  context 'when not an EC2 instance' do
    include_context 'Not an EC2 Instance'
    it 'returns error with message' do
      stub_cli_with('identify')
      expect{subject.run}.to raise_error(SystemExit)
      expect($stderr.string)
        .to match('FATAL: NOT an EC2 instance or could not connect to Metadata')
    end
  end

  context 'when EC2 instance' do
    include_context 'EC2 Instance without tags'

    context 'without tags' do
      it 'writes default hostname' do
        stub_cli_with('identify')
        allow_any_instance_of(identify).to receive(:tag)
        subject.run
        expect(IO.read(hostname_file)).to eq('1')
        expect($stdout.string).to match('Done.')
      end
    end

    context 'and when \'--ec2-tag-theme\'' do
      it 'returns the themed host' do
        stub_cli_with('identify --ec2-tag-theme=Test-#')
        allow_any_instance_of(identify).to receive(:tag)
          .and_return('TestValue')
        subject.run
        expect(IO.read(hostname_file)).to eq('TestValue-1')
      end
    end

    context 'and when \'--host\'' do
      it 'returns the new host' do
        stub_cli_with('identify --host=test-host')
        subject.run
        expect(IO.read(hostname_file)).to eq('test-host')
      end
    end

    context 'and when \'--domain\'' do
      it 'returns the new domain' do
        stub_cli_with('identify --domain=example.tld')
        subject.run
        expect(IO.read(hosts_file)).to match('example.tld')
      end
    end

    context 'and when similar found' do
      it 'returns the incremented host' do
        stub_cli_with('identify --ec2-tag-theme=Test-#')
        allow_any_instance_of(identify).to receive(:tag)
          .and_return('TestName')
        allow_any_instance_of(identify).to receive(:domain)
          .and_return('TestDomain.tld')
        subject.run
        expect(IO.read(hostname_file)).to eq('TestName-2')
        expect(IO.read(hosts_file)).to match('TestName-2.TestDomain.tld')
      end
    end
   end
end
