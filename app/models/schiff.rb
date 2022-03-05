# encoding: utf-8
class Schiff < ApplicationRecord
  serialize :next_ports
  belongs_to :firma
  has_many :beobachtungen
  has_many :transportabschnitte
  
  validates :name, presence: true, uniqueness: true
  
  def self.find_or_create_schiff(schiff_name, firma)
    schiff = Schiff.find_by(name: schiff_name)
    if schiff.nil?
      schiff = Schiff.create(name: schiff_name)
    end
    unless firma.nil? #schiff.firma.nil? && !firma.nil?
      schiff.firma = firma 
      schiff.save
    end
    schiff
  end
  
  def storePosition
    require 'nokogiri'
    require 'open-uri'
  
    if self.vesselfinder_url
      begin
        doc = Nokogiri::HTML(open(self.vesselfinder_url.to_s))
        lattext = doc.at_css("span[itemprop='latitude']").text
        lontext = doc.at_css("span[itemprop='longitude']").text
        File.open("log/ort.log","a"){|f| f.puts "===Schiff #{self.name}" }
        
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
        
        # Erst im nächsten Schritt Ziel und Ankunftszeit parsen, weil woanders stehen (css Aenderung moeglich)
        doc.at_css("div[id='ais-data']").css("div[class='row param']").each do |property|
          propname =  property.at_css("span[itemprop='name']") 
          if propname
            if propname.text =="Destination"
              #File.open("log/ort.log","a"){|f| f.puts "--DEST #{property.at_css("span[itemprop='value']")}"}
              destext = property.at_css("span[itemprop='value']").text
              self.update(current_destination: destext)
            elsif propname.text =="ETA"
              etatext = property.at_css("span[itemprop='value']").text
              #File.open("log/ort.log","a"){|f| f.puts "--ETA #{etatext}"}
              self.update(current_eta: etatext)
            end
          end
        end
      rescue
        Rails.logger.warn("Fehler beim Parsen von #{self.vesselfinder_url}")
      end
    end
  end
  
  def self.storeAllPositions
    schiffe = Schiff.all
    
    schiffe.each do |schiff|
      schiff.storePosition
    end
  end
  
  def self.parseTable(text)
    master_column_position_list = []
          
    text.each_with_index do |line, line_number|
      current_line_pos = 0
      columns = line.strip.split(%r{ {2,}}).map{|col| col.strip}
           
      columns.each_with_index do | column, col_index |
        col_start = line.index(column, current_line_pos)
        current_line_pos = col_start + column.length
        this_col_pos = [col_start, current_line_pos]
           
        if master_column_position_list.length == 0
          master_column_position_list.push(this_col_pos)
        else
          master_column_position_list.each_with_index do | master_col_pos, m_index |
            if master_col_pos[0] > this_col_pos[1]
              master_column_position_list.insert(m_index, this_col_pos)
              break
            elsif master_col_pos[1] < this_col_pos[0]
              if m_index == master_column_position_list.length-1
                master_column_position_list.push(this_col_pos)
                break
              end # if m_index
            elsif master_col_pos[0] <= this_col_pos[1] && master_col_pos[1] >= this_col_pos[0]
              master_col_pos[0] = [master_col_pos[0], this_col_pos[0]].min 
              master_col_pos[1] = [master_col_pos[1], this_col_pos[1]].max
              break
            end # of if master_col_pos[0] >
          end # of iterating master_column_position_list
        end # of if master_column_position_list.length ==
              
      end # of iterating columns
          
    end #of iterating temptext
    p master_column_position_list

    endtext = Array.new
         
    text.each_with_index do |line, line_number|
      unless line.strip.blank?
        endtext << master_column_position_list.map{|pos| line[(pos[0])..(pos[1])].to_s.strip}
      end # of unless line.strip.blank?
    end # of iterating temptext
        
    return endtext
  end
  
  def self.getMacsSchedule
    require 'open-uri'
    open("http://www.macship.com/macs-schedules/northcon.pdf", "rb") do |io|
      reader = PDF::Reader.new(io)
      reader.pages.each do |page|
           
        # Spalten erkennen und mehrdimensionales Array der Ankunftstabelle erzeugen
        temptext = page.text.split("\n")
        deletetext = ["ETD", "ETA", "Schedule", "subject to change", "Please note"]
        deletetext.each do |text|
          temptext.delete_if {|item| item.include? text }
        end
        
        table = parseTable temptext
        
        # Alte Ankunftsdaten löschen
        table[0].each_with_index do |search1,i|
          search2 = table[1][i]
          unless search1.empty? || search2.empty?
            schiff = self.where('name LIKE ? AND name LIKE ?', "%#{search1}%", "%#{search2}%").first
            if schiff
              self.update(schiff, next_ports: {})
            end
          end
        end
         
        # Neue Ankunftsdaten schreiben
        ports = ["Hamburg", "Rotterdam", "Vigo", "Walvis Bay", "Richardsbay", "Durban", "Cape Town", "Antwerp"]
        
        #Alle Spalten durchgehen und Schiffe zuordnen
        table[0].each_with_index do |search1,index|
          search2 = table[1][index]
          unless search1.empty? || search2.empty?
            schiff = self.where('name LIKE ? AND name LIKE ?', "%#{search1}%", "%#{search2}%").first
            if schiff
              hash = schiff.next_ports
              #Alle Zeilen durchgehen und Häfen zuordnen
              table.each do |line|
                ports.each do |port|
                  if line[0].to_s.include?(port) && !line[index].to_s.empty?
                    hash[Date.parse line[index]] = port
                  end
                end
              end
              self.update(schiff, next_ports: hash)
            end
          end
        end
        
      end #pages
    end #Fileopen
  end #getMacsSchedule
  
end #Class
