require 'spec_helper'
require 'vscripts'

describe VScripts do
  include_context 'Suppressed output'

  let(:cli) { VScripts::CommandLine }

  before(:all) do
    @cmd = VScripts::Commands.list.first.to_s.downcase
  end

  describe '.run' do
    context 'when no command line arguments' do
      it 'returns help' do
        allow_any_instance_of(cli).to receive(:arguments).and_return([])
        expect{subject.run}.to raise_error(SystemExit)
        expect($stdout.string).to match(/Available commands/)
      end
    end

    context 'when \'-h\'' do
      it 'returns help' do
        allow_any_instance_of(cli).to receive(:arguments).and_return(['-h'])
        expect{subject.run}.to raise_error(SystemExit)
        expect($stdout.string).to match(/Available commands/)
      end
    end

    context 'when \'-v\'' do
      it 'returns version' do
        allow_any_instance_of(cli).to receive(:arguments).and_return(['-v'])
        expect{subject.run}.to raise_error(SystemExit)
        expect($stdout.string).to match(/VScripts.*(c)/)
      end
    end

    context 'when \'command\' and \'-h\'' do
      it 'returns command help' do
        allow(VScripts).to receive(:cli).and_return(cli.new(["#{@cmd}", '-h']))
        expect{subject.run}.to raise_error(SystemExit)
        expect($stdout.string).to match(/USAGE:/)
        expect($stdout.string).to match(/OPTIONS:/)
      end
    end
  end
end
