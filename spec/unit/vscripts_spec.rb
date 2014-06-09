require 'spec_helper'
require 'vscripts'

describe VScripts do
  before(:all) do
    $stdout = StringIO.new
    @cmd = VScripts::Commands.list.first.to_s.downcase
  end

  after(:all) do
    $stdout = STDOUT
  end

  describe '.run' do
    context 'when \'-h\'' do
      it 'returns help' do
        expect{subject.run(['-h'])}.to raise_error(SystemExit)
      end
    end

    context 'when \'-v\'' do
      it 'returns version' do
        expect{subject.run(['-v'])}.to raise_error(SystemExit)
      end
    end

    context 'when \'command\' and \'-h\'' do
      it 'returns command help' do
        expect{subject.run([@cmd, '-h'])}.to raise_error(SystemExit)
      end
    end
  end
end
