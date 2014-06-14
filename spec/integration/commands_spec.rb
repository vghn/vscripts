require 'spec_helper'
require 'vscripts'

describe 'Command: Unknown' do
  include_context 'VScripts'
  include_context 'Suppressed output'

  it 'returns error with message' do
    expect{stub_cli_with('xyz')}.to raise_error(SystemExit)
    expect($stderr.string).to match(/Error: unknown subcommand/)
  end
end
