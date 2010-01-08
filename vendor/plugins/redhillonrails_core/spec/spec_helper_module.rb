#remove tables after tests if they still exist
module SpecHelperModule
  def clear_db_after_test
    if ActiveRecord::Base.connection.table_exists? :children
      ActiveRecord::Migration.drop_table :children
    end
  
    if ActiveRecord::Base.connection.table_exists? :tops
      ActiveRecord::Migration.drop_table :tops
    end
  end

  #add top table common for all foreign key tests
  def prepare_db_for_test
    clear_db_after_test
    ActiveRecord::Migration.create_table :tops, {:force => true}
  end

  module Core
    def create_child_table_with_top_id_and &block
      lambda {
        ActiveRecord::Migration.create_table :children, :force => true do |t|
          # fix for tests when run with foreign_key_migration installed
          if defined?(RedHillConsulting::ForeignKeyMigrations)
            t.column_without_foreign_key_migrations :top_id, :integer
          else
            t.column :top_id, :integer
          end
          yield(t)
        end
      }.should_not raise_error
    end
  
    def drop_child_table
      lambda {
        ActiveRecord::Migration.drop_table :children
      }.should_not raise_error
    end
  
    def foreign_key_expectations
      (expected_key = Child.foreign_keys.first).should_not be_nil
      expected_key[:name] .should == "top_id_foreign_key"
      expected_key[:column_names].should == ["top_id"]
      expected_key[:references_column_names].should == ["id"]
      expected_key[:table_name].should == "children"
      expected_key[:references_table_name].should == "tops"
    
      #check if database sopports foreign keys
      child = Child.new
      lambda {child.save!}.should_not raise_error(ActiveRecord::StatementInvalid)
      child = Child.new :top_id => 5
      lambda {child.save!}.should raise_error(ActiveRecord::StatementInvalid)
    end
  end
end
