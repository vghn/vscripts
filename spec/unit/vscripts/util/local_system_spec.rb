require 'spec_helper'
require 'tempfile'
require 'vscripts/util'

describe VScripts::Util::LocalSystem do
  subject { Object.new.extend VScripts::Util }

  let(:test_dir) { Dir::Tmpname.make_tmpname('/tmp/vscripts-test-', nil) }
  let(:test_file) { "#{test_dir}/test_file" }
  let(:test_cont) { 'testing content' }

  describe '#hosts_path' do
    it 'returns the path to hosts file' do
      expect(subject.hosts_path).to be_a String
    end
  end

  describe '#hostname_path' do
    it 'returns the path to the hostname file' do
      expect(subject.hostname_path).to be_a String
    end
  end

  describe '#hosts_file' do
    it 'returns the an array' do
      allow(File).to receive(:read).and_return(test_cont)
      expect(subject.hosts_file).to be_a String
    end
  end

  describe '#local_fqdn' do
    it 'returns the local FQDN' do
      expect(subject.local_fqdn).to be_a String
    end
  end

  describe '#local_host_name' do
    it 'returns the local host name' do
      expect(subject.local_host_name).to be_a String
    end
  end

  describe '#local_domain_name' do
    it 'returns the local domain name' do
      expect(subject.local_domain_name).to be_a String
    end
  end

  describe '#external_dns' do
    it 'returns the external dns' do
      allow(subject).to receive('`').and_return('test')
      expect(subject.external_dns).to eq('test')
      allow(subject).to receive('`').and_raise(StandardError)
      expect(subject.external_dns).to be false
    end
  end

  describe '#ensure_file_dir' do
    it 'create a directory for the specified files' do
      subject.ensure_file_dir(test_file)
      expect(Dir.exists?(test_dir)).to be true
    end
  end

  describe '#write_file' do
    it 'should write to a file' do
      subject.write_file(test_file, test_cont)
      expect(IO.read(test_file)).to eq(test_cont)
      $stderr = StringIO.new
      allow(File).to receive(:open).and_raise(Errno::EACCES)
      expect { subject.write_file(test_file, test_cont) }.to raise_error(SystemExit)
      $stderr = STDERR
    end
  end

  describe '#ensure_file_content' do
    it 'should ensure content of file' do
      subject.ensure_file_content(test_file, test_cont)
      expect(IO.read(test_file)).to eq(test_cont)
    end
  end
end
