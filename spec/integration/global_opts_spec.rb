require 'spec_helper'
require 'vscripts'

describe 'Global Options' do
  include_context 'VScripts'
  include_context 'Suppressed output'

  subject { VScripts.run }

  describe 'Help' do
    context 'when \'-h\'' do
      it 'returns help and exits' do
        expect{stub_cli_with('-h')}.to raise_error(SystemExit)
        expect($stdout.string).to match(/Available commands/)
      end
    end

    context 'when \'--help\'' do
      it 'returns help and exits' do
        expect{stub_cli_with('--help')}.to raise_error(SystemExit)
        expect($stdout.string).to match(/Available commands/)
      end
    end
  end

  describe 'Version' do
    context 'when \'-v\'' do
      it 'returns version and exits' do
        expect{stub_cli_with('-v')}.to raise_error(SystemExit)
        expect($stdout.string).to match(/VScripts.*(c)/)
      end
    end

    context 'when \'--version\'' do
      it 'returns version and exits' do
        expect{stub_cli_with('--version')}.to raise_error(SystemExit)
        expect($stdout.string).to match(/VScripts.*(c)/)
      end
    end
  end
  describe 'Unknown argument' do
    context 'when short' do
      it 'returns error with message' do
        expect{stub_cli_with('-z')}.to raise_error(SystemExit)
        expect($stderr.string).to match(/Error: unknown argument/)
      end
    end

    context 'when long' do
      it 'returns error with message' do
        expect{stub_cli_with('--xyz')}.to raise_error(SystemExit)
        expect($stderr.string).to match(/Error: unknown argument/)
      end
    end
  end
end
