require 'spec_helper'
require 'vscripts'

describe 'Command: Identify' do
  include_context 'VScripts'
  include_context 'Suppressed output'
  include_context 'Temporary'

  subject { VScripts.run }

  let(:identify)      { VScripts::Commands::Identify }
  let(:hostname_file) { "#{TEMP_DIR}/test-hostname" }
  let(:hosts_file)    { "#{TEMP_DIR}/test-hosts" }

  before(:each) do
    allow_any_instance_of(identify)
      .to receive(:hostname_path).and_return(hostname_file)
    allow_any_instance_of(identify)
      .to receive(:hosts_path).and_return(hosts_file)
    allow_any_instance_of(identify).to receive('`')
  end

  describe 'when \'--help\'' do
    it 'exits and shows help' do
      stub_cli_with('identify --help')
      expect{subject}.to raise_error(SystemExit)
      expect($stdout.string).to match(/USAGE:/)
    end
  end

  context 'when unknown argument' do
    it 'returns error with message' do
      stub_cli_with('identify --xyz')
      expect{subject}.to raise_error(SystemExit)
      expect($stderr.string).to match(/Error: unknown argument/)
    end
  end

  context 'when not an EC2 instance' do
    include_context 'Not an EC2 Instance', VScripts::Commands::Identify
    it 'returns error with message' do
      stub_cli_with('identify')
      expect{subject}.to raise_error(SystemExit)
      expect($stderr.string)
        .to match('FATAL: NOT an EC2 instance or could not connect to Metadata')
    end
  end

  context 'when EC2 instance' do
    include_context 'EC2 Instance without tags', VScripts::Commands::Identify

    context 'without tags' do
      it 'writes default hostname' do
        stub_cli_with('identify')
        allow_any_instance_of(identify).to receive(:tag)
        subject
        expect(IO.read(hostname_file)).to eq('1')
        expect($stdout.string).to match('Done.')
      end
    end

    context 'and when \'--ec2-tag-theme\'' do
      it 'returns the themed host' do
        stub_cli_with('identify --ec2-tag-theme=Test-#')
        allow_any_instance_of(identify).to receive(:tag)
          .and_return('TestValue')
        subject
        expect(IO.read(hostname_file)).to eq('TestValue-1')
      end
    end

    context 'and when \'--host\'' do
      it 'returns the new host' do
        stub_cli_with('identify --host=test-host')
        subject
        expect(IO.read(hostname_file)).to eq('test-host')
      end
    end

    context 'and when \'--domain\'' do
      it 'returns the new domain' do
        stub_cli_with('identify --domain=example.tld')
        subject
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
        subject
        expect(IO.read(hostname_file)).to eq('TestName-2')
        expect(IO.read(hosts_file)).to match('TestName-2.TestDomain.tld')
      end
    end
   end
end
