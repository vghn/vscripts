require 'aws_spec_helper'
require 'vscripts'

def stub_cli_with(args)
  allow(subject).to receive(:cli).and_return(cli.new(args.split))
end

def stub_any_cli_with(args)
  allow_any_instance_of(cli).to receive(:arguments).and_return(args.split)
end

shared_context 'VScripts' do
  subject          { VScripts }
  let(:cli)        { VScripts::CommandLine }
  let(:cfg)        { VScripts::Config }
  let(:identify)   { VScripts::Commands::Identify }
  let(:tags2facts) { VScripts::Commands::Tags2facts }
end
