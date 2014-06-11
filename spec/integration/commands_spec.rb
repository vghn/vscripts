require 'integration/spec_helper'

describe 'Command: Unknown' do
  include_context 'Suppressed output'

  subject { VScripts }

  it 'returns error with message' do
    expect{subject.run(['xyz'])}.to raise_error(SystemExit)
    expect($stderr.string).to match(/Error: unknown subcommand/)
  end
end
