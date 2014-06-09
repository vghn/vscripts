require 'spec_helper'
require 'vscripts/version'

describe 'VScripts::VERSION' do
  it 'Should be a string' do
    expect(VScripts::VERSION::STRING).to be_a String
  end
  it 'Should have a major version' do
    expect(VScripts::VERSION::MAJOR).to be_an Integer
  end
  it 'Should have a minor version' do
    expect(VScripts::VERSION::MINOR).to be_an Integer
  end
  it 'Should have a patch version' do
    expect(VScripts::VERSION::PATCH).to be_an Integer
  end
  it 'Should have a copyright version' do
    expect(VScripts::VERSION::COPYRIGHT).to be_a String
  end
end
