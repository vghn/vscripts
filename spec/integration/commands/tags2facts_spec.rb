require 'integration/spec_helper'

describe 'Command: Tags2Facts' do
  include_context 'Suppressed output'
  include_context 'Temporary'
  include_context 'VScripts'

  before(:each) do
    stub_cli_with('tags2facts')
  end

  context 'when \'--help\'' do
    it 'returns command specific help' do
      stub_cli_with('tags2facts --help')
      expect{subject.run}.to raise_error(SystemExit)
      expect($stdout.string).to match(/USAGE:/)
      expect($stdout.string).to match(/OPTIONS:/)
    end
  end

  context 'when unknown argument' do
    it 'returns error with message' do
      stub_cli_with('tags2facts --xyz')
      expect{subject.run}.to raise_error(SystemExit)
      expect($stderr.string).to match(/Error: unknown argument/)
    end
  end

  context 'when not an EC2 instance' do
    include_context 'Not an EC2 Instance'
    it 'returns error with message' do
      expect{subject.run}.to raise_error(SystemExit)
      expect($stderr.string)
        .to match('FATAL: NOT an EC2 instance or could not connect to Metadata')
    end
  end

  context 'when EC2 instance' do
    context 'without tags' do
      include_context 'EC2 Instance without tags'
      it 'returns error with message' do
        expect{subject.run}.to raise_error(SystemExit)
        expect($stderr.string).to match(/No tags were found/)
      end
    end

    context 'with tags' do
      before(:each) do
        allow_any_instance_of(VScripts::Commands::Tags2facts)
          .to receive_message_chain('cli.file')
          .and_return(test_file)
        allow_any_instance_of(VScripts::Commands::Tags2facts)
          .to receive_message_chain('cli.all').and_return(false)
      end

      context '--all specified' do
        include_context 'EC2 Instance with tags'
        it 'creates file' do
          stub_cli_with('tags2facts --all')
          allow_any_instance_of(VScripts::Commands::Tags2facts)
            .to receive_message_chain('cli.all').and_return(true)
          subject.run
          expect(IO.read(test_file)).to match(tags['Name'])
        end
      end

      context '--all not specified' do
        include_context 'EC2 Instance with tags'
        it 'creates file' do
          subject.run
          expect(IO.read(test_file)).to match(tags.keys.last)
        end
      end

      context '--file specified' do
        include_context 'EC2 Instance with tags'
        it 'creates file' do
          stub_cli_with("tags2facts --file #{test_file}")
          subject.run
          expect(IO.read(test_file)).to match(tags.keys.last)
        end
      end

      context '--file not specified' do
        include_context 'EC2 Instance with tags'
        it 'creates file' do
          subject.run
          expect(IO.read(test_file)).to match(tags.keys.last)
        end
      end
    end
  end
end
