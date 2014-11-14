# encoding: utf-8
class AbfragenController < ApplicationController
  def index
    @stoff_auswahl = Stoff.get_stoffe_for_selection_field
    @start_anlagen = Anlage.get_anlagen_for_list_field(params[:start_kategorie])
    @ziel_anlagen = Anlage.get_anlagen_for_list_field(params[:ziel_kategorie])
    @anlagen_kategorien = AnlagenKategorie.all
  end

  def show
    @transporte = calculate_transporte
    # aktuellstes Transportjahr berechnen
    @year = 1990
    @transporte.each {|t| @year = t.datum.year if t.datum.year > @year }
  end

  def calendar
    @year = params["year"] ? params["year"].to_i : 2014
    @date = Date.new(@year,1,1)
    @transporte = []
    params.each do |key, value|
      if key =~ /transport/
        trans =  Transport.find(value.to_i)
        @transporte << trans if trans
      end
    end
    @transporte_per_day = calculate_transporte_per_day(@transporte)
  end
  
  
  private
  
    # sollen eigentlich noch nach transportabschnitten ueber mehrere tage 
    # einsortiert werden.
    def calculate_transporte_per_day transporte 
      transporte_per_day = Hash.new
      transporte.each do |transport|
        transporte_per_day[transport.datum] ||= []
        transporte_per_day[transport.datum] << transport
      end
      transporte_per_day
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
