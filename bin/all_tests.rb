tests_directory = File.expand_path('../../tests', __FILE__)

Dir[tests_directory + '/**/*_test.rb'].each do |file|
  require file
end
