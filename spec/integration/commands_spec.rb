require 'integration/spec_helper'

describe 'Command: Unknown' do
  include_context 'Suppressed output'
  include_context 'VScripts'

  it 'returns error with message' do
    stub_any_cli_with('xyz')
    expect{subject.run}.to raise_error(SystemExit)
    expect($stderr.string).to match(/Error: unknown subcommand/)
  end
end
