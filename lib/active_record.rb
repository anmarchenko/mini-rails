require "active_record/connection_adapter"

module ActiveRecord
  class Base
    def self.primary_abstract_class
    end

    def initialize(attributes = {})
      @attributes = attributes
    end

    def id
      @attributes[:id]
    end

    def title
      @attributes[:title]
    end

    def self.find(id)
      attributes = connection.execute("SELECT * FROM posts WHERE id = #{id.to_s}").first
      new(attributes)
    end

    def self.establish_connection(options)
      @@connection = ConnectionAdapter::SqliteAdapter.new(options[:database])
    end

    def self.connection
      @@connection
    end

    def self.columns
      [
        { name: "id", type: :integer },
        { name: "title", type: :string },
      ]
    end
  end
end
