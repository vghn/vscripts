require 'spec_helper'
require 'vscripts/version'

describe 'VScripts::VERSION' do
  it 'Should be a string' do
    expect(VScripts::VERSION).to be_an_instance_of String
  end
end
