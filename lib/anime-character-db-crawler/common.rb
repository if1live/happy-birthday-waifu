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

    # TODO to_i + attr_accessor
    # TODo filter_to_array + attr_accesssor
  end
end
