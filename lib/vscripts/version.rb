module VScripts
  # This module holds the version information.
  module VERSION
    # @return [String] the version number
    STRING = '0.1.3'

    # @return [String] the semantic version number
    MAJOR, MINOR, PATCH = STRING.split('.').map(&:to_i)

    # @return [String] the copyrighted version number
    COPYRIGHT = "VScripts #{STRING} (c) #{Time.new.year} Vlad Ghinea"
  end
end
