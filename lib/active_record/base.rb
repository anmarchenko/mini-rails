module ActiveRecord
  class Base
    def self.primary_abstract_class
    end

    def initialize(attributes = {})
      @attributes = attributes
    end

    # the real active record dynamically generates methods for each column
    def method_missing(method, *args)
      columns = self.class.connection.columns(self.class.table_name)

      if columns.include?(method)
        @attributes[method]
      else
        super
      end
    end

    def self.find(id)
      find_by_sql("SELECT * FROM #{table_name} WHERE id = #{id.to_s}").first
    end

    def self.all
      Relation.new(self)
    end

    def self.where(*args)
      all.where(*args)
    end

    def self.find_by_sql(sql)
      connection.execute(sql).map { |attributes| new(attributes) }
    end

    def self.establish_connection(options)
      @@connection = ConnectionAdapter::SqliteAdapter.new(options[:database])
    end

    def self.connection
      @@connection
    end

    def self.table_name
      name.downcase + "s"
    end
  end
end
