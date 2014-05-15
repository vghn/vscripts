# Version number
module VScripts
  VERSION = File.read(File.expand_path('../../../VERSION', __FILE__)).strip
  VERSION_MAJOR, VERSION_MINOR, VERSION_PATCH = VERSION.split('.')
  VERSION_C = "VScripts #{VERSION} (c) 2014 Vlad Ghinea"
end
