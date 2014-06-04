# Track your code coverage
require 'coveralls'
Coveralls.wear!

# Development code coverage
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  Coveralls::SimpleCov::Formatter,
  SimpleCov::Formatter::HTMLFormatter
]

class DummyClass
end
