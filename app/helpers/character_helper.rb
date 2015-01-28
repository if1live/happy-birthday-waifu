module CharacterHelper
  def self.date_to_s(month, day)
    return nil if month > 12
    return nil if month < 1
    return nil if day > 31
    return nil if day < 1

    Kernel::sprintf("%02d/%02d", month, day)
  end

  def self.str_to_date(val)
    return {} unless val.length == 5
    month = val[0...2].to_i
    day = val[3...5].to_i
    {month: month, day: day}
  end
end
