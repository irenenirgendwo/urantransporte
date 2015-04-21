# encoding: utf-8
module AbfragenHelper

  def calendar(date = Date.today.date, &block)
    Calendar.new(self, date, block).table date.year
  end
  
  def stringToColor(text)
    require 'digest/md5'
    color = '#' + Digest::MD5.hexdigest(text)[0..5]
  end
  
end
