module AbfragenHelper

  def calendar(date = Date.today.date, &block)
    Calendar.new(self, date, block).table date.year
  end
end
