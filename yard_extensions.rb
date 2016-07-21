# Load all Ruby files inside of the YARD extensions directory.
Dir.glob('yard_extensions/**.rb') do |file|
  require_relative file
end
