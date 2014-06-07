require 'spec_helper'
require 'vscripts/commands'

describe VScripts::Commands do
  describe '#list' do
    it 'returns a list of available commands' do
      expect(VScripts::Commands.list).to be_an_instance_of Array
    end
  end
end
