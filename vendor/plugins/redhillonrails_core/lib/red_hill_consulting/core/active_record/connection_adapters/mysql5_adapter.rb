module RedHillConsulting::Core::ActiveRecord::ConnectionAdapters
  # MySQL5-specific behaviors
  module Mysql5Adapter
    
    def reverse_foreign_keys(table_name, name = nil)
      ans = execute(<<-SQL, name)
      SELECT constraint_name, table_name, column_name, referenced_table_name, referenced_column_name
        FROM information_schema.key_column_usage
       WHERE table_schema = SCHEMA()
         AND referenced_table_schema = table_schema
       ORDER BY constraint_name, ordinal_position;
      SQL
      
      results = []
      ans.each do | row |
        results << [row[0], row[1], row[2], row[3], row[4]]
      end
      current_foreign_key = nil
      foreign_keys = []

      results.each do |row|
        next unless table_name.casecmp(row[3]) == 0
        if current_foreign_key != row[0]
          foreign_keys << ForeignKeyDefinition.new(row[0], row[1], [], row[3], [])
          current_foreign_key = row[0]
        end

        foreign_keys.last.column_names << row[2]
        foreign_keys.last.references_column_names << row[4]
      end

      foreign_keys
    end
  end
end