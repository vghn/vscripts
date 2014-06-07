# Track your code coverage
require 'coveralls'
Coveralls.wear!

# Development code coverage
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter
]

# RSpec Configuration
RSpec.configure {|config|
  # Abort the run on first failure.
  config.fail_fast = true

  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  # Clean up
  config.after(:suite) { `ls /tmp/vscripts-test-* &> /dev/null && rm -r /tmp/vscripts-test-*` }
}
