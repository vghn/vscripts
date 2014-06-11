require 'integration/spec_helper'

describe 'Global Options' do
  subject { VScripts }

  before(:all) do
    $stdout = StringIO.new
    $stderr = StringIO.new
  end

  after(:all) do
    $stdout = STDOUT
    $stderr = STDERR
  end

  describe 'Help' do
    context 'when \'-h\'' do
      it 'returns help and exits' do
        expect{subject.run(['-h'])}.to raise_error(SystemExit)
        expect($stdout.string).to match(/Available commands/)
      end
    end

    context 'when \'--help\'' do
      it 'returns help and exits' do
        expect{subject.run(['--help'])}.to raise_error(SystemExit)
        expect($stdout.string).to match(/Available commands/)
      end
    end
  end

  describe 'Version' do
    context 'when \'-v\'' do
      it 'returns version and exits' do
        expect{subject.run(['-v'])}.to raise_error(SystemExit)
        expect($stdout.string).to match(/VScripts.*(c)/)
      end
    end

    context 'when \'--version\'' do
      it 'returns version and exits' do
        expect{subject.run(['--version'])}.to raise_error(SystemExit)
        expect($stdout.string).to match(/VScripts.*(c)/)
      end
    end
  end
  describe 'Unknown argument' do
    context 'when short' do
      it 'returns error with message' do
        expect{subject.run(['-z'])}.to raise_error(SystemExit)
        expect($stderr.string).to match(/Error: unknown argument/)
      end
    end

    context 'when long' do
      it 'returns error with message' do
        expect{subject.run(['--xyz'])}.to raise_error(SystemExit)
        expect($stderr.string).to match(/Error: unknown argument/)
      end
    end
  end
end
