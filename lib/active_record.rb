require "active_record/connection_adapter"

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
      attributes = connection.execute("SELECT * FROM #{table_name} WHERE id = #{id.to_s}").first
      new(attributes)
    end

    def self.all
      connection.execute("SELECT * FROM #{table_name}").map { |attributes| new(attributes) }
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
