require 'vscripts/command'

describe VScripts::Command do
  describe '#list' do
    it 'returns a list of available commands' do
      expect(VScripts::Command.list).to be_an_instance_of Array
    end
  end
end
