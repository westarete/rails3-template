require File.dirname(__FILE__) + '/spec_helper'

describe "model" do
  
  it "should respond to method foreign_keys" do
    Top.should respond_to(:foreign_keys)
  end
  
  it "should respond to method indexes" do
    Top.should respond_to(:indexes)
  end
  
end

describe "migration" do
  include SpecHelperModule::Core
  
  #next 5 tests are inter dependant so be careful when modyfying
  it "should create table with foreign key" do
    create_child_table_with_top_id_and { |t| t.foreign_key :top_id, :tops, :id, :name => :top_id_foreign_key }
    foreign_key_expectations
  end
  
  it "should drop foreign key with remove_foreign_key" do
    lambda {
      ActiveRecord::Migration.remove_foreign_key :children, :top_id_foreign_key
    }.should_not raise_error
  end
  
  it "should add foreign key with add_foreign_key" do
    lambda {
      ActiveRecord::Migration.add_foreign_key :children, :top_id, :tops, :id, :name => :top_id_foreign_key
    }.should_not raise_error
    foreign_key_expectations
  end
  
  it "should remove table without errors" do
    drop_child_table
  end
  #end of interdependant test
  
  describe "when using t.foreign_key" do
    
    it "should create foreign key with referential action ON DELETE CASCADE when using :on_delete => :cascade option" do
      create_child_table_with_top_id_and { |t| t.foreign_key :top_id, :tops, :id, :on_delete => :cascade }
      
      top = Top.create
      
      child = Child.create :top_id => top.id
      
      Top.delete(top.id)
      lambda {Child.find(child.id)}.should raise_error(ActiveRecord::RecordNotFound)
      
      drop_child_table
    end
    
    it "should create foreign key with referential action ON DELETE RESTRICT when using :on_delete => :restrict option" do
      create_child_table_with_top_id_and { |t| t.foreign_key :top_id, :tops, :id, :on_delete => :restrict }
      
      top = Top.create
      
      child = Child.create :top_id => top.id
      
      lambda {top.delete}.should raise_error(ActiveRecord::StatementInvalid)
      
      drop_child_table
    end
    
    it "should create foreign key with referential action ON DELETE SET NULL when using :on_delete => :set_null option" do
      create_child_table_with_top_id_and { |t| t.foreign_key :top_id, :tops, :id, :on_delete => :set_null }

      top = Top.create
      
      child = Child.create :top_id => top.id
      
      top.delete
      child.reload
      child.top_id.should == nil
      
      drop_child_table
    end
    
    it "should create foreign key with referential action ON UPDATE CASCADE when using :on_update => :cascade option" do
      create_child_table_with_top_id_and { |t| t.foreign_key :top_id, :tops, :id, :on_update => :cascade }
      # cannot change AR object id with rails so functionality cannot be used inside rails
      # could be only tested by parsing raw sql but its database dependant and not worth time
      drop_child_table
    end
    
    it "should create foreign key with referential action ON UPDATE RESTRICT when using :on_update => :restrict option" do
      create_child_table_with_top_id_and { |t| t.foreign_key :top_id, :tops, :id, :on_update => :restrict }
      # cannot change AR object id with rails so functionality cannot be used inside rails
      # could be only tested by parsing raw sql but its database dependant and not worth time
      drop_child_table
    end
    
    it "should create foreign key with referential action ON UPDATE SET NULL when using :on_update => :set_null option" do
      create_child_table_with_top_id_and { |t| t.foreign_key :top_id, :tops, :id, :on_update => :set_null }
      # cannot change AR object id with rails so functionality cannot be used inside rails
      # could be only tested by parsing raw sql but its database dependant and not worth time
      drop_child_table
    end
    
  end
  
end