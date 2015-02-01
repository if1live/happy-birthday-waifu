module CharactersHelper
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def date_to_s(month, day)
      return nil if month > 12
      return nil if month < 1
      return nil if day > 31
      return nil if day < 1

      Kernel::sprintf("%02d/%02d", month, day)
    end
  end

  def str_to_date(val)
    {month: extract_month_from_str(val), day: extract_day_from_str(val)}
  end

  def extract_month_from_str(val)
    month = val[0...2].to_i
  end

  def extract_day_from_str(val)
    return nil if val.length != 5
    day = val[3...5].to_i
  end
end
