# encoding: UTF-8
class UploadController < ApplicationController

  require 'csv'
  require 'date'

  # Startseite zum Einlesen (Schritt 1)
  def index
  end

  # Datei auf Server (Schritt 2)
  def upload_file
    if params[:upload].nil?
      flash[:notice] = "Bitte eine Datei auswählen"
    else 
      uploaded_io = params[:upload]
      @file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
      File.open(@file_path, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      csv_text =  File.read(@file_path) 
      csv = CSV.parse(csv_text, :headers => true, :col_sep => ",")
      @headers = csv.headers
    end
  end

  # Datei einlesen.
  # 1. Schritt: Anlagen einlesen
  # Wo die Datei liegt, wird gespeichert in der session, um bei weiteren Schritten
  # darauf zugreifen zu koennen.
  # 
  def read_anlagen
      # Logger ist für Debugging-Zwecke im log-Verzeichnis
      @logger = File.new(Rails.root.join("log","upload.log"), "w")
      file_path = params[:file_path]
      session[:file_path] = file_path
      @spalte_nr1 = params[:start]
      @spalte_nr2 = params[:ziel]
      @logger.puts "Anlagen sind in #{@spalte_nr1} und #{@spalte_nr2}"
      # Erstelle @anlagen_liste als Liste von Namen, die in den Spalten auftauchen.
      @anlagen_liste = []
      csv_text =  File.read(file_path) 
      csv = CSV.parse(csv_text, :headers => true, :col_sep => ",")
      csv.each do |row|
        row_as_hash = row.to_hash
        @anlagen_liste << row_as_hash[@spalte_nr1]
        @anlagen_liste << row_as_hash[@spalte_nr2]
        @logger.puts "Anlage Start #{row_as_hash[@spalte_nr1]}"
      end 
      # Duplikate rauswerfen
      @anlagen_liste.uniq!
      @logger.puts "Anlagenliste #{@anlagenliste}"
      # Für jeden Anlagennamen ein Synonym erstellen und speichern.
      @synonym_liste = []
      synonym_ids = []
      @anlagen_liste.each do |anlage_name|
        # Synonym
        synonym = AnlagenSynonym.find_by synonym: anlage_name
        synonym ||= AnlagenSynonym.new({:synonym => anlage_name})
        if synonym.save 
          @synonym_liste << synonym
          synonym_ids << synonym.id
        else 
          # TODO: Fehlerbehandlung
        end
      end
      session[:synonym_liste] = synonym_ids # wird momentan nicht gebraucht, vielleicht aber bei Umstellung
      @logger.puts "Synonym ids #{synonym_ids}"
    @all_anlagen = Anlage.get_anlagen_for_selection_field
    @logger.puts "all Anlagen #{@all_anlagen}"
    # Für das neue-Anlage-Formular
    @anlage = Anlage.new
    @redirect_params = upload_anlagen_zuordnung_path
    # Zu jedem dieser Synonyme muss manuell eine Anlage zugeordnet werden,
    # alternativ eine neue angelegt werden, die dann mit dem Synonym verbunden wird. 
    # Hierzu wird weiter geleitet, da die Zuordnung iterativ passiert
    # zur Vermeidung von Code-Doppelungen.
    @logger.close
    redirect_to upload_anlagen_zuordnung_path
  end

  # Weitere Anlagen zuordnen, 
  # GET-Methode, damit darauf weiter geleitet werden kann
  # zeigt alle nicht zugeordneten Synonyme.
  #
  def anlagen_zuordnung
    all_synonym_liste = AnlagenSynonym.all
    @synonym_liste = []
    all_synonym_liste.each do |synonym|
      @synonym_liste << synonym if synonym.anlage.nil?
    end
    @all_anlagen = Anlage.get_anlagen_for_selection_field
    @anlage = Anlage.new
    @redirect_params = upload_anlagen_zuordnung_path
    if @synonym_liste.empty?
      render "anlagen_fertig_auswahl"
    end
  end

  # Zuordnung synonym zu Anlage speichern.
  #
  def save_zuordnung
    @logger = File.new("log/upload.log","w")
    @logger.puts params
    @logger.puts "synonym id #{params[:synonym].to_i}"
    synonym = AnlagenSynonym.find(params[:synonym].to_i)
    @logger.puts synonym.attributes
    synonym.anlage = Anlage.find(params[:anlage].to_i)
    @logger.puts synonym.anlage.attributes
    @logger.puts synonym.anlage.nil?
    if synonym.save
      @logger.close
      flash[:notice] = "Zuordnung erfolgreich"
      redirect_to upload_anlagen_zuordnung_path
    else
      # TODO: Fehlerbehandlung
    end 
  end


  # Formular zum einlesen der Transporte mit Spaltenzuordnungen.
  #
  def read_transporte
  end

  # Post-Methode zum Einlesen der Transporte mit den vorgenommenen
  # Spaltenzuordnungen.
  #
  def save_transporte
    start_anlage_spalten_name = params[:start_anlage]
    ziel_anlage_spalten_name = params[:ziel_anlage]
    datum_spalten_name = params[:datum]
    stoff_spalten_name = params[:stoff]
    anzahl_spalten_name = params[:anzahl]
    menge_spalten_name = params[:menge]
    menge_umrechnungsfaktor_spalten_name = params[:menge_umrechnungsfaktor]
    behaelter_spalten_name = params[:behaelter]
    # TODO: das irgendwie in erweiterbarem Hash speichern sodass einlesen mit Schleife geht...
    # Mindestens bei den Daten, die nicht mit einer Tabelle verbunden sind.
    @transporte_liste = []
    @transporte_anzahl = 0
    file_path = session[:file_path]
    csv_text =  File.read(file_path) 
    csv = CSV.parse(csv_text, :headers => true, :col_sep => ",")
    csv.each do |row|
        row_as_hash = row.to_hash
        start_anlage =  AnlagenSynonym.find_anlage_to_synonym(row_as_hash[start_anlage_spalten_name])
        ziel_anlage =  AnlagenSynonym.find_anlage_to_synonym(row_as_hash[ziel_anlage_spalten_name])
        datum_werte = row_as_hash[datum_spalten_name].split(".") # Nehmen mal Format dd.mm.yyyy an.
        datum = Date.new(datum_werte[2].to_i, datum_werte[1].to_i,datum_werte[0].to_i)
        transport_params = { :start_anlage => start_anlage, :ziel_anlage => ziel_anlage, :datum => datum }
        transport_params[:stoff] = row_as_hash[stoff_spalten_name] if stoff_spalten_name
        transport_params[:anzahl] = row_as_hash[anzahl_spalten_name] if anzahl_spalten_name
        transport_params[:menge] = menge_spalten_name.nil? ? nil : row_as_hash[menge_spalten_name].to_f *
                                   row_as_hash[menge_umrechnungsfaktor_spalten_name].to_f
        transport_params[:behaelter] = row_as_hash[behaelter_spalten_name] if behaelter_spalten_name
        transport = Transport.new(transport_params)
        if transport.save 
          @transporte_anzahl += 1
        else 
          @transporte_liste << transport.attributes # TODO: Fehlerbehandlung
        end
        #@transporte_liste << transport
    end 
    @transporte_anzahl 

    render "fertig"
  end




  private



end
