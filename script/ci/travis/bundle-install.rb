#!/usr/bin/env ruby
require 'luffa'

working_directory = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', 'CalSmokeApp'))

Dir.chdir working_directory do

  Luffa::unix_command('bundle install',
                      {:pass_msg => 'bundled',
                       :fail_msg => 'could not bundle'})
end
