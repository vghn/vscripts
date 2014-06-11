# Track your code coverage
require 'coveralls'
Coveralls.wear!

TEMP_DIR = File.join(File.dirname(__FILE__),'..','tmp')

# Development code coverage
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter
]

# RSpec Configuration
RSpec.configure {|config|
  # Abort the run on first failure.
  config.fail_fast = true

  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Show test times
  config.profile_examples = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  # Create temporary files
  config.before(:suite) {
    FileUtils.mkdir_p TEMP_DIR
    FileUtils.touch "#{TEMP_DIR}/test-file"
    File.open("#{TEMP_DIR}/test-hostname", 'w') do |newfile|
      newfile.write('TestHostname')
    end
    File.open("#{TEMP_DIR}/test-hosts", 'w') do |newfile|
      newfile.write('127.0.0.1 TestHostname')
    end
  }

  # Clean up
  config.after(:suite) {
    FileUtils.rm_rf TEMP_DIR if Dir[TEMP_DIR]
  }
}

shared_context 'Suppressed output' do
  before(:each) do
    $stdout = StringIO.new
    $stderr = StringIO.new
  end

  after(:each) do
    $stdout = STDOUT
    $stderr = STDERR
  end
end

shared_context 'Temporary' do
  let(:temp_dir) { TEMP_DIR }
  let(:test_dir) { "#{TEMP_DIR}/test-dir" }
  let(:test_file) { "#{TEMP_DIR}/test-file" }
  let(:test_missing_file) { "#{test_dir}/test-file" }
  let(:test_cont) { 'VScripts Test Content.' }
end

shared_context 'System files' do
  include_context 'Temporary'

  let(:hostname_file) { "#{TEMP_DIR}/test-hostname" }
  let(:hosts_file) { "#{TEMP_DIR}/test-hosts" }

  before(:each) do
    allow_any_instance_of(VScripts::Util::LocalSystem)
      .to receive(:hostname_path).and_return(hostname_file)
    allow_any_instance_of(VScripts::Util::LocalSystem)
      .to receive(:hosts_path).and_return(hosts_file)
  end
end
