begin
  require File.dirname(__FILE__) + '/../../../../spec/spec_helper'
rescue LoadError
  puts "You need to install rspec in your base app"
  exit
end

require File.dirname(__FILE__) + '/models/top'
require File.dirname(__FILE__) + '/models/child'

require File.dirname(__FILE__) + '/spec_helper_module'
include SpecHelperModule

#silence migration output
ActiveRecord::Migration.verbose = false

#configuring rspec
Spec::Runner.configure do |config|
  #turn off transactions (drop table cannot be run inside transaction)
  config.use_transactional_fixtures = false
    
  #add example logging to facilitate debugging
  config.before :each do
    full_example_description = "Starting #{self.class.description} #{@method_name}"  
    ActiveRecord::Base.logger.info("\n\n#{full_example_description}\n#{'-' * (full_example_description.length)}")
    Child.reset_column_information
  end

  config.before :all do
    prepare_db_for_test
  end

  config.after :all do
    clear_db_after_test
  end
end