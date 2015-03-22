module AnimeCharacterDB
  class BirthdayHelper
    MONTH_TABLE = {
      january: 1,
      february: 2,
      march: 3,
      april: 4,
      may: 5,
      june: 6,
      july: 7,
      august: 8,
      september: 9,
      october: 10,
      november: 11,
      december: 12
    }

    def parse_mmdd_format(val)
      # 02/05
      return nil if val.nil?
      m = /\d\d\/\d\d/.match val
      if !m.nil?
        val
      else
        nil
      end
    end

    def parse_short_month_day_format(val)
      # short form (ex: Feb 5)
      return nil if val.nil?
      m = /^(\w{3}) (\d{1,2})$/.match val
      if !m.nil?
        month = nil
        MONTH_TABLE.each do |k, v|
          if k.downcase.to_s[0...3] == m.captures[0].downcase
            month = v
            break
          end
        end

        day = m.captures[1].to_i
        sprintf("%02d/%02d", month, day)
      else
        nil
      end
    end

    def parse_month_day_format(val)
      return nil if val.nil?

      # February 5 형태 인식
      token_list = val.split(' ')
      unless token_list.length == 2
        raise ArgumentError.new "unknown date format"
      end

      month_key = token_list[0].downcase.to_sym
      month = MONTH_TABLE[month_key]
      raise ArgumentError.new "unknwon month, #{month_key}" if month.nil?

      day = token_list[1].to_i

      sprintf("%02d/%02d", month, day)
    end

    def parse_date(val)
      return nil if val.nil?
      return nil unless val.is_a? String
      return nil if val.empty?

      birthday = parse_mmdd_format val
      if birthday.nil?
        birthday = parse_short_month_day_format val
      end
      if birthday.nil?
        birthday = parse_month_day_format val
      end
      birthday
    end
  end
end
