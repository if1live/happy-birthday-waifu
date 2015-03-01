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

    def to_hash_core attr_name_list
      data = {}
      attr_name_list.each do |attr_name|
        data[attr_name] = instance_variable_get("@#{attr_name}")
      end

      data[:extra] = extra
      data
    end

    def from_hash_core hash, attr_name_list
      attr_name_list.each do |attr_name|
        val = hash[attr_name]
        next if val.nil?
        instance_variable_set("@#{attr_name}", val)
      end
      @extra = hash[:extra]
      self
    end

    def ==(o)
      o.to_hash == o.to_hash
    end

    def convert_slug(val)
      slug = val.downcase
      # remove special char
      invalid_char_list = ['!', '?', '/']
      invalid_char_list.each do |x|
        slug = slug.gsub x, ''
      end
      invalid_word_list = ['(series)', '(franchise)']
      invalid_word_list.each do |x|
        slug = slug.gsub x, ''
      end

      slug = slug.strip
      # "a   b"의 공백을 1개로 취급하는 편법
      slug = slug.split(' ').join('-')
      raise ArgumentError.new "fix this method" if slug.include? '('

      slug
    end
  end
end
