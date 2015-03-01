module AnimeCharacterDB
  class BaseData
    attr_reader :extra

    def initialize()
      @extra = {}
    end

    def filter_to_array(val)
      if val.is_a? String
        val.split ', '
      else
        val
      end
    end

    def set_extra(key, value)
      @extra[key] = value
    end

    def self.integer_attr_accessor(name)
      define_method(name) do
        instance_variable_get("@#{name}")
      end

      define_method("#{name}=") do |value|
        instance_variable_set("@#{name}", value.to_i)
      end
    end

    def self.tags_attr_accessor(name)
      define_method(name) do
        instance_variable_get("@#{name}")
      end

      define_method("#{name}=") do |value|
        instance_variable_set("@#{name}", filter_to_array(value))
      end
    end
  end
end
