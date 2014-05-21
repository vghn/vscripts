require 'spec_helper'
require 'tempfile'
require 'vscripts/util/local_system'

describe VScripts::Util::LocalSystem do
  before(:all) do
    @dummy = DummyClass.new
    @dummy.extend VScripts::Util::LocalSystem
  end

  describe '#hosts_path' do
    it 'returns the path to hosts file' do
      expect(@dummy.hosts_path).to be_a String
    end
  end
  describe '#hostname_path' do
    it 'returns the path to the hostname file' do
      expect(@dummy.hostname_path).to be_a String
    end
  end
  describe '#local_fqdn' do
    it 'returns the local FQDN' do
      expect(@dummy.local_fqdn).to be_a String
    end
  end
  describe '#local_host_name' do
    it 'returns the local host name' do
      expect(@dummy.local_host_name).to be_a String
    end
  end
  describe '#local_domain_name' do
    it 'returns the local domain name' do
      expect(@dummy.local_domain_name).to be_a String
    end
  end
  describe '#ensure_file_dir' do
    it 'create a directory for the specified files' do
      test_dir  = Dir::Tmpname.make_tmpname '/tmp/vscripts', nil
      test_file = 'test_file'
      @dummy.ensure_file_dir("#{test_dir}/#{test_file}")
      expect(Dir.exists?(test_dir)).to be_true
      `rm -r #{test_dir}`
    end
  end
  describe '#write_file' do
    it 'should write to a file' do
      test_file  = Dir::Tmpname.make_tmpname '/tmp/vscripts', nil
      @dummy.write_file(test_file, 'test')
      expect(IO.read(test_file)).to eq('test')
      `rm #{test_file}`
    end
  end
  describe '#ensure_file_content' do
    it 'should ensure content of file' do
      test_dir  = Dir::Tmpname.make_tmpname '/tmp/vscripts', nil
      test_file = 'test_file'
      test      = "#{test_dir}/#{test_file}"
      @dummy.ensure_file_content(test, 'test')
      expect(IO.read(test)).to eq('test')
      `rm -r #{test_dir}`
    end
  end
  describe '#checks' do
    it 'returns an array of checks' do
      expect(@dummy.checks).to be_a Hash
    end
  end
  describe '#process_checks' do
    it 'should execute system command and return exit code' do
      @dummy.stub(:checks) {{'test command' => 'exit 5'}}
      expect(@dummy.process_checks).to eq({"test command"=>5})
    end
  end
  describe '#status_codes' do
    it 'should return an Array of exit codes' do
      @dummy.stub(:checks) {{'test command' => 'exit 5'}}
      expect(@dummy.status_codes).to eq([5])
    end
  end
end
