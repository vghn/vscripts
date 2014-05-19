require 'vscripts/version'

describe 'VScripts::VERSION' do
  it 'Should be a string' do
    VScripts::VERSION.should be_an_instance_of String
  end
end
