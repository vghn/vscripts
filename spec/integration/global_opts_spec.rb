require 'integration/spec_helper'

describe 'Global Options' do
  subject { VScripts }

  include_context 'Suppressed output'
  include_context 'VScripts'

  describe 'Help' do
    context 'when \'-h\'' do
      it 'returns help and exits' do
        stub_any_cli_with('-h')
        expect{subject.run}.to raise_error(SystemExit)
        expect($stdout.string).to match(/Available commands/)
      end
    end

    context 'when \'--help\'' do
      it 'returns help and exits' do
        stub_any_cli_with('--help')
        expect{subject.run}.to raise_error(SystemExit)
        expect($stdout.string).to match(/Available commands/)
      end
    end
  end

  describe 'Version' do
    context 'when \'-v\'' do
      it 'returns version and exits' do
        stub_any_cli_with('-v')
        expect{subject.run}.to raise_error(SystemExit)
        expect($stdout.string).to match(/VScripts.*(c)/)
      end
    end

    context 'when \'--version\'' do
      it 'returns version and exits' do
        stub_any_cli_with('--version')
        expect{subject.run}.to raise_error(SystemExit)
        expect($stdout.string).to match(/VScripts.*(c)/)
      end
    end
  end
  describe 'Unknown argument' do
    context 'when short' do
      it 'returns error with message' do
        stub_any_cli_with('-z')
        expect{subject.run}.to raise_error(SystemExit)
        expect($stderr.string).to match(/Error: unknown argument/)
      end
    end

    context 'when long' do
      it 'returns error with message' do
        stub_any_cli_with('--xyz')
        expect{subject.run}.to raise_error(SystemExit)
        expect($stderr.string).to match(/Error: unknown argument/)
      end
    end
  end
end
