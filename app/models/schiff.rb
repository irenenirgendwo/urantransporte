class Schiff < ActiveRecord::Base
  def storePosition
    require 'nokogiri'
    require 'open-uri'
  
    if self.vesselfinder_url
      begin
        doc = Nokogiri::HTML(open(self.vesselfinder_url.to_s))
        lattext = doc.at_css("span[itemprop='latitude']").text
        lontext = doc.at_css("span[itemprop='longitude']").text
        lat = lattext.split(' ')
        lon = lontext.split(' ')
        
        if lat[1] == "S"
          self.update(current_lat: lat[0].to_f*(-1))
        else
          self.update(current_lat: lat[0].to_f)
        end
        
        if lon[1] == "W"
          self.update(current_lon: lon[0].to_f*(-1))
        else
          self.update(current_lon: lon[0].to_f)
        end
      rescue
      end
    end
  end
  
  def self.storeAllPositions
    schiffe = Schiff.all
    
    schiffe.each do |schiff|
      schiff.storePosition
    end
  end
end
