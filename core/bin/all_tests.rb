test_directory = File.expand_path('../test', __dir__)

Dir[test_directory + '/**/*_test.rb'].each do |file|
  require file
end
