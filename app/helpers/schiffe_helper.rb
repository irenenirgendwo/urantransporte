module SchiffeHelper
  def storePosition(schiff)
    require 'nokogiri'
    require 'open-uri'
  
    begin
      doc = Nokogiri::HTML(open(schiff.vesselfinder_url.to_s))
      lattext = doc.at_css("span[itemprop='latitude']").text
      lontext = doc.at_css("span[itemprop='longitude']").text
      lat = lattext.split(' ')
      lon = lontext.split(' ')
      
      if lat[1] == "S"
        schiff.update(current_lat: lat[0].to_f*(-1))
      else
        schiff.update(current_lat: lat[0].to_f)
      end
      
      if lon[1] == "W"
        schiff.update(current_lon: lon[0].to_f*(-1))
      else
        schiff.update(current_lon: lon[0].to_f)
      end
    rescue
    end
  end
  
  def storeAllPositions
    schiffe = Schiff.all
    
    schiffe.each do |schiff|
      if schiff.vesselfinder_url
        storePosition(schiff)
      end
    end
  end
end
