require 'spec_helper'
require 'vscripts'

describe VScripts do
  include_context 'Suppressed output'
  include_context 'VScripts'

  describe '.run' do
    context 'when no command line arguments' do
      it 'returns help' do
        expect{stub_cli_with('')}.to raise_error(SystemExit)
        expect($stdout.string).to match(/Available commands/)
      end
    end

    context 'when \'-h\'' do
      it 'returns help' do
        expect{stub_cli_with('-h')}.to raise_error(SystemExit)
        expect($stdout.string).to match(/Available commands/)
      end
    end

    context 'when \'-v\'' do
      it 'returns version' do
        expect{stub_cli_with('-v')}.to raise_error(SystemExit)
        expect($stdout.string).to match(/VScripts.*(c)/)
      end
    end

    context 'when \'command\' and \'-h\'' do
      it 'returns command help' do
        stub_cli_with("#{cmd} -h")
        expect{subject.run}.to raise_error(SystemExit)
        expect($stdout.string).to match(/USAGE:/)
        expect($stdout.string).to match(/OPTIONS:/)
      end
    end
  end
end
