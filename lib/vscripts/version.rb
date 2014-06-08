module VScripts
  # @return [String] the version number
  VERSION = File.read(File.expand_path('../../../VERSION', __FILE__)).strip
  # @return [String] the semantic version number
  VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH = VERSION.split('.')
  # @return [String] the copyrighted version number
  VERSION_C = "VScripts #{VERSION} (c) #{Time.new.year} Vlad Ghinea"
end
