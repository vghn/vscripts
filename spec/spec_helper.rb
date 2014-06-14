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

shared_context 'Temporary' do
  let(:temp_dir) { TEMP_DIR }
  let(:test_dir) { "#{TEMP_DIR}/test-dir" }
  let(:test_file) { "#{TEMP_DIR}/test-file" }
  let(:test_missing_file) { "#{test_dir}/test-file" }
  let(:test_cont) { 'VScripts Test Content.' }
end

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

def stub_cli_with(args)
  allow(VScripts).to receive(:cli)
    .and_return(VScripts::CommandLine.new(args.split))
end

shared_context 'VScripts' do
  let(:cmd) { VScripts::Commands.list.first.to_s.downcase }
end

shared_context 'Not an EC2 Instance' do
  before(:each) do
   allow(Net::HTTP).to receive(:get_response).and_return(false)
  end
end

shared_context 'Amazon Web Services' do |subject|
  # Preload AWS library
  AWS.eager_autoload! AWS::Core     # Make sure to load Core first.
  AWS.eager_autoload! AWS::EC2      # Load the EC2 class

  ::AWS.config({
    :access_key_id => '1234',
    :secret_access_key => '5678',
    :logger => nil,
    :stub_requests => true
  })

  let(:region) {'us-east-1'}

  let(:fake_instances) {::AWS::Core::Data.new([
    {id: 'i-abcdefg1', status: :running, tags: tags},
    {id: 'i-abcdefg2', status: :terminated, tags: tags},
    {id: 'i-abcdefg3', status: :running, tags: {}},
    {id: 'i-abcdefg4', status: :terminated, tags: {}},
  ])}

  let(:tags) {{
    'Name' => 'TestName-1.TestDomain.tld',
    'Domain' => 'TestDomainValue.tld',
    'TestTagKey' => 'TestTagValue',
  }}

  before(:each) do
    allow_any_instance_of(subject)
      .to receive_message_chain('ec2.instances.tagged')
      .and_return(fake_instances[0..1])
    allow_any_instance_of(subject)
      .to receive_message_chain(:named_instances)
      .and_return(fake_instances[0..1])
  end
end

shared_context 'EC2 Instance' do |subject|
  include_context 'Amazon Web Services', subject

  before(:each) do
    allow(Net::HTTP).to receive(:get_response).and_return(true)
    allow(subject).to receive_message_chain('open.read')
      .and_return('Remote server response')
    allow_any_instance_of(subject).to receive(:zone)
    allow_any_instance_of(subject).to receive(:region)
      .and_return('us-east-1')
    allow_any_instance_of(subject).to receive(:instance_id)
      .and_return(fake_instances[1].id)
    allow_any_instance_of(subject)
      .to receive_message_chain('ec2.tags.create')
  end
end

shared_context 'EC2 Instance without tags' do |subject|
  include_context 'EC2 Instance', subject

  before(:each) do
    allow_any_instance_of(subject)
      .to receive_message_chain('instance.tags')
      .and_return({})
  end
end

shared_context 'EC2 Instance with tags' do |subject|
  include_context 'EC2 Instance', subject

  before(:each) do
     allow_any_instance_of(subject)
      .to receive_message_chain('instance.tags')
      .and_return(tags)
  end
end
