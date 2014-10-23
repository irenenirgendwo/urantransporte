class Schiff < ActiveRecord::Base
  serialize :next_ports
  
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
  
  def self.getMacsSchedule
    require 'open-uri'
    open("http://www.macship.com/macs-schedules/northcon.pdf", "rb") do |io|
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
        
        # Mehrdimensionales Array der Ankunftstabelle erzeugen
        temptext = page.text.split("\n")
        textend = temptext.map do |a1|
          a1.split(%r{\s{2,}}) # Aufsplitten, wenn mindestens zwei Leerzeichen dazwischen sind.
        end
        
        # Alte Ankunftsdaten löschen
        textend[3].each_with_index do |search1,i|
          search2 = textend[5][i]
          unless search1.empty? || search2.empty?
            schiff = self.where('name LIKE ? AND name LIKE ?', "%#{search1}%", "%#{search2}%").first
            self.update(schiff, next_ports: {})
          end
        end
        
        # Neue Ankunftsdaten schreiben
        # Alle Zeilen durchgehen
        textend.each do |line|
          hash = Hash.new
          # Alle Häfen durchgehen
          ports = ["Hamburg", "Rotterdam", "Vigo"]
          ports.each do |port|
            if line[0].to_s.include? port
              # Alle Spalten durchgehen
              textend[3].each_with_index do |search1,i|
                search2 = textend[5][i]
                unless search1.empty? || search2.empty?
                  schiff = self.where('name LIKE ? AND name LIKE ?', "%#{search1}%", "%#{search2}%").first
                  hash = schiff.next_ports
                  hash[Date.parse line[i]] = port
                  self.update(schiff, next_ports: hash)
                end
              end
            end
          end
        end
        
      end
    end
  end
  
end
