# encoding: utf-8

# Ermoeglicht verschiedene Abfragen zur Suche und Auswertung von Transporten.
# Ausgewaehlte Transporte koennen in Kalenderdarstellung dargestellt werden.
#
class AbfragenController < ApplicationController
  
  # Auswahlmoeglichkeiten
  #
  def index
    @stoff_auswahl = Stoff.get_stoffe_for_selection_field
    @start_anlagen = Anlage.get_anlagen_for_list_field(params[:start_kategorie])
    @ziel_anlagen = Anlage.get_anlagen_for_list_field(params[:ziel_kategorie])
    @anlagen_kategorien = AnlagenKategorie.all
  end

  # zeigt Ergebnisse
  #
  def show
    @transporte = calculate_transporte
    # aktuellstes Transportjahr berechnen
    @year = 1990
    @transporte.each {|t| @year = t.datum.year if t.datum.year > @year }
  end

  # Kalenderdarstellung
  #
  def calendar
    @logger = File.new("log/abfrage.log","w")
    @year = params["year"] ? params["year"].to_i : 2014
    @date = Date.new(@year,1,1)
    # erst mal uebergebene Transporte raussuchen
    @transporte = []
    params.each do |key, value|
      if key =~ /transport/
        trans = Transport.find(value)
        @transporte << trans if trans
      end
    end
    # fuer die Darstellung nach Tag und Slot sortierte Transporte
    @transporte_per_day = calculate_transporte_per_day(@transporte)
    @logger.close
  end
  
  
  private
  
    # sollen eigentlich noch nach transportabschnitten ueber mehrere tage 
    # einsortiert werden.
    def calculate_transporte_per_day transporte 
      @max_key = 1
      transporte_per_day = Hash.new
      free_keys = Hash.new
      transporte.each do |transport|
        @logger.puts "Transport: #{transport.datum}"
        #transporte_per_day[transport.datum] ||= Hash.new 
        #transporte_per_day[transport.datum] << transport
        
        abschnitte_and_umschlaege = transport.sort_abschnitte_and_umschlaege
        start_datum, end_datum = transport.get_start_and_end_datum(abschnitte_and_umschlaege)
        @logger.puts " start: #{start_datum} ende: #{end_datum}"
        
        # in allen Feldern ersten freien Slot suchen und Transport da eintragen.
        # muss sein, damit erstrecken ueber mehrere Felder konsistent bleibt.
        key = get_min_free_key(free_keys, start_datum, end_datum)
        aktueller_abschnitt = 0
        @logger.puts " free key #{key}"
        (start_datum .. end_datum).each do |date|
          @logger.puts " #{date}"
          transporte_per_day[date] ||= Hash.new
          transporte_per_day[date][key] = {"transport" => transport}
          @logger.puts " Umschlag #{transport.get_umschlag(date)}"
          transporte_per_day[date][key]["umschlag"] = transport.get_umschlag(date)
          transporte_per_day[date][key]["abschnitt"] = transport.get_abschnitt(date)
          
          free_keys[date] = free_keys[date] - [key]
        end
        @max_key = key if key > @max_key
        
      end
      transporte_per_day
    end 
    
    def get_min_free_key(free_keys_per_date, start_datum, end_datum)
      actual_free_keys = (1..10).to_a
      start_datum.upto(end_datum) do |date|
        #@logger.puts "  #{date}"
        free_keys_per_date[date] = (1..10).to_a if free_keys_per_date[date].nil?
        #@logger.puts "  free_keys date #{free_keys_per_date[date]}"
        #@logger.puts "  free_keys actual #{actual_free_keys}"
        actual_free_keys = free_keys_per_date[date] & actual_free_keys
        #@logger.puts "  free_keys #{actual_free_keys}"
      end
      min_free_key = actual_free_keys.min
    end
    
  
    # berechnet Arrays mit Ids von Stoffen, Start-Anlagen und Zielanlagen
    # aus den übergebenen Parametern.
    #
    def extract_params 
      stoffe = []
      verkehrstraeger = []
      start_anlagen = []
      ziel_anlagen = []
      params.each do |param_key, param_value|
        splitted_key = param_key.split("-")
        case splitted_key[0] 
        when "Verkehrsträger" then
          unless splitted_key[1]=="alle" || params.keys.include?("Verkehrsträger-alle")
            verkehrstraeger << splitted_key[1]
          end
        when "Stoff" then
          puts "stoff"
          unless splitted_key[1]=="alle" || params.keys.include?("Stoff-alle")
            stoffe << splitted_key[1].to_i
          end
        when "Start" then # Startanlage
          unless splitted_key[1]=="alle" || params.keys.include?("Start-alle")
            param_value.each do |anlage|
              start_anlagen << anlage.to_i
            end
          end
        when "Ziel" then # Zielanlage
          unless splitted_key[1]=="alle" || params.keys.include?("Ziel-alle")
            param_value.each do |anlage|
              ziel_anlagen << anlage.to_i
            end
          end
        end
      end
      return stoffe, verkehrstraeger, start_anlagen, ziel_anlagen
    end
    
    # fragt alle Transporte mit den übergebenen Parametern ab.
    #
    def calculate_transporte 
      start_datum = params["start_datum"].to_date
      end_datum = params["end_datum"].to_date
      stoffe, verkehrstraeger, start_anlagen, ziel_anlagen = extract_params
      
      @transporte = Transport.where(:datum => start_datum..end_datum)
      @transporte = @transporte.where(:stoff_id => stoffe) unless stoffe.empty?
      @transporte = @transporte.where(:start_anlage_id => start_anlagen) unless start_anlagen.empty?
      @transporte = @transporte.where(:ziel_anlage_id => ziel_anlagen) unless ziel_anlagen.empty?
      # TODO: Verkehrsmittel, aber das ist komplizierter wegen Transportabschnitten
      
      @zeitraum = "Vom #{start_datum} bis zum #{end_datum}"
      @stoffe = stoffe.map { |stoff_id| Stoff.find(stoff_id).bezeichnung }.join(",") unless stoffe.empty?
      @start_anlagen = start_anlagen.map { |id| Anlage.find(id).name }.join(",") unless start_anlagen.empty?
      @ziel_anlagen = start_anlagen.map { |id| Anlage.find(id).name }.join(",") unless ziel_anlagen.empty?
      
      @transporte
    end
end
