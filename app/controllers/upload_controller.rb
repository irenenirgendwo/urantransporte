# encoding: UTF-8
class UploadController < ApplicationController
  before_action :editor_user

  require 'csv'
  require 'date'


  # Startseite zum Einlesen (Schritt 1)
  def index
    @trennzeichen_liste = [",",";"]
  end

  # Datei auf Server (Schritt 2)
  def upload_file
    if params[:upload].nil?
      upload_fehler("Bitte eine Datei auswählen.")
    else 
      uploaded_io = params[:upload]
      @file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
      File.open(@file_path, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      session[:csv_trennzeichen] = params[:trennzeichen]
      begin 
        @headers = read_headers_from_csv(@file_path)
        @headers_with_nil = ["Nicht vorhanden"]
        @headers_with_nil.concat(@headers)
        if @headers.nil? || @headers.empty?
          upload_fehler("Dateiformat nicht korrekt, konnte keine Überschriften finden.")
        elsif @headers.count == 1
          upload_fehler("Nur eine Spalte - falsches Trennzeichen?")
        else
          render "upload_file"
        end
      rescue 
        upload_fehler("Dateiformat nicht korrekt.")
      end
    end
  end

  # Datei einlesen.
  # 2. Schritt: Anlagen einlesen
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
      @spalte_stoff = params[:stoff]
      session[:spalte_start] = @spalte_nr1
      session[:spalte_ziel] = @spalte_nr2
      session[:spalte_stoff] = @spalte_stoff
      unless params[:schiff] == "Nicht vorhanden"
        session[:spalte_schiff] = params[:schiff]
      end
      unless params[:reederei] == "Nicht vorhanden"
        session[:spalte_reederei] = params[:reederei]
      end
      @logger.puts "Anlagen sind in #{@spalte_nr1} und #{@spalte_nr2}"
      # Erstelle @anlagen_liste als Liste von Namen, die in den Spalten auftauchen.
      @anlagen_liste = []
      @stoff_liste = []
      csv_text =  File.read(file_path) 
      csv = CSV.parse(csv_text, :headers => true, :col_sep => session[:csv_trennzeichen])
      csv.each do |row|
        row_as_hash = row.to_hash
        @anlagen_liste << row_as_hash[@spalte_nr1]
        @anlagen_liste << row_as_hash[@spalte_nr2]
        @stoff_liste << row_as_hash[@spalte_stoff]
        @logger.puts "Anlage Start #{row_as_hash[@spalte_nr1]}"
      end 
      # Duplikate rauswerfen
      @anlagen_liste.uniq!
      @stoff_liste.uniq!
      @logger.puts "Stoffliste #{@stoff_liste}"
      # Für jeden Anlagennamen ein Synonym erstellen und speichern.
      create_anlagen_synonyme(@anlagen_liste) 
      create_stoff_synonyme(@stoff_liste)
      
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

  # 3. Schritt
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
    @all_werte = Anlage.get_anlagen_for_selection_field
    @anlage = Anlage.new( anlagen_kategorie: AnlagenKategorie.find_by( name: "Unbekannt" ) )
    @redirect_params = upload_anlagen_zuordnung_path
    if @synonym_liste.empty?
      redirect_to upload_stoffe_zuordnung_path #upload_read_transporte_path
    else
      @typ = "anlage"   
      @wert_modal = 'anlagen/form_modal'
      render "werte_zuordnung"
    end
  end

  # 3. Schritt jeweils speichern 
  # Zuordnung synonym zu Anlage speichern.
  #
  def save_zuordnung
    synonym = AnlagenSynonym.find(params[:synonym].to_i)
    synonym.anlage = Anlage.find(params[:anlage].to_i)
    if synonym.save
      flash[:success] = "Zuordnung erfolgreich"
      redirect_to upload_anlagen_zuordnung_path
    else
      # TODO: Fehlerbehandlung
    end 
  end
  
   # 4. Schritt
  # Stoffzuordnung
  # GET-Methode, damit darauf weiter geleitet werden kann
  # zeigt alle nicht zugeordneten Synonyme.
  #
  def stoffe_zuordnung
    @synonym_liste = StoffSynonym.get_all_unused_synonyms
    @all_werte = Stoff.get_stoffe_for_selection_field
    @stoff = Stoff.new
    @redirect_params = upload_stoffe_zuordnung_path
    if @synonym_liste.empty?
      redirect_to upload_read_transporte_path
    else 
      @typ = "stoff"   
      @wert_modal = 'stoffe/form_modal'
      render "werte_zuordnung"
    end
  end

  # 2. Schritt jeweils speichern 
  # Zuordnung synonym zu Stoff speichern.
  #
  def save_stoffe_zuordnung
    #@logger = File.new("log/upload.log","w")
    #@logger.puts params
    #@logger.puts "synonym id #{params[:synonym].to_i}"
    synonym = StoffSynonym.find(params[:synonym].to_i)
    #@logger.puts synonym.attributes
    synonym.stoff = Stoff.find(params[:stoff].to_i)
    #@logger.puts synonym.anlage.attributes
    #@logger.puts synonym.anlage.nil?
    if synonym.save
      #@logger.close
      flash[:success] = "Zuordnung erfolgreich"
      redirect_to upload_stoffe_zuordnung_path
    else
      # TODO: Fehlerbehandlung
    end 
  end
  
  
  
  


  # 4. Schritt
  # Formular zum einlesen der Transporte mit Spaltenzuordnungen.
  #
  def read_transporte
    @headers = read_headers_from_csv(session[:file_path])
    @headers_with_nil = ["Nicht vorhanden"]
    @headers_with_nil.concat(@headers)
    @einstellungen_vorhandene_transporte = {"Nicht einlesen" => "N", "Verschmelzen" => "J"}
  end

  # 4. Schritt Speichern, eigentliches Einlesen der Datei.
  # Post-Methode zum Einlesen der Transporte mit den vorgenommenen
  # Spaltenzuordnungen.
  #
  def save_transporte
    @logger = File.new("log/upload.log","wb")
    @logger.puts params
    start_anlage_spalten_name = session[:spalte_start]
    ziel_anlage_spalten_name = session[:spalte_ziel]
    stoff_spalten_name = session[:spalte_stoff]
    datum_spalten_name = params[:datum]  
    # Weitere optionale Spaltennamen
    anzahl_spalten_name = params[:anzahl] == "Nicht vorhanden" ? nil : params[:anzahl] 
    menge_brutto_spalten_name = params[:menge_brutto] == "Nicht vorhanden" ? nil : params[:menge_brutto] 
    menge_brutto_umrechnungsfaktor = params[:menge_brutto_umrechnungsfaktor].gsub(",",".").to_f
    menge_netto_spalten_name = params[:menge_netto] == "Nicht vorhanden" ? nil : params[:menge_netto] 
    menge_netto_umrechnungsfaktor = params[:menge_netto_umrechnungsfaktor].gsub(",",".").to_f
    behaelter_spalten_name = params[:behaelter] == "Nicht vorhanden" ? nil : params[:behaelter] 
    firmen_spalten_name = params[:firmen] == "Nicht vorhanden" ? nil : params[:firmen] 
    firma_trennzeichen = params[:firma_trennzeichen] 
    # Genehmigungen werden nur eingelesen, wenn eine Genehmigungsnummer existiert.
    genehmigungen = params[:lfd_nr] == "Nicht vorhanden" ? nil : params[:lfd_nr] 
    genehmigungs_params = genehmigungen.nil? ? nil : read_genehmigungs_params(params)
    umschlag_params = params[:umschlag_ort] == "Nicht vorhanden" ? nil : read_umschlag_params(params)
    @logger.puts "umschlag: #{umschlag_params}"
    quelle = params[:quelle]
    
    @transporte_liste = {}
    @transporte_anzahl = 0
    @anzahl_verschmolzene = 0

    # Datei einlesen
    file_path = session[:file_path]
    csv_text =  File.read(file_path) 
    csv = CSV.parse(csv_text, :headers => true, :col_sep => session[:csv_trennzeichen])
    # TODO: Fehlerbehandlung
    row_count = 2 # Start bei Zeile 2 wegen Überschriften
    csv.each do |row|
        row_as_hash = row.to_hash
        start_anlage =  AnlagenSynonym.find_anlage_to_synonym(row_as_hash[start_anlage_spalten_name])
        ziel_anlage =  AnlagenSynonym.find_anlage_to_synonym(row_as_hash[ziel_anlage_spalten_name])
        # Nehmen mal Format dd.mm.yyyy an.
        #datum_werte = row_as_hash[datum_spalten_name].split(".") 
        @logger.puts "Datum: #{row_as_hash[datum_spalten_name]}"
        datum = Date.strptime(row_as_hash[datum_spalten_name],"%d.%m.%y")
        transport_params = { :start_anlage => start_anlage, :ziel_anlage => ziel_anlage, :datum => datum }
        #@logger.puts "row #{row_as_hash}"
        transport_params[:stoff] = StoffSynonym.find_stoff_to_synonym(row_as_hash[stoff_spalten_name]) 
        
        # Optionale Parameter
        transport_params[:anzahl] = row_as_hash[anzahl_spalten_name] if anzahl_spalten_name
        transport_params[:menge_netto] = menge_netto_spalten_name.nil? ? nil : row_as_hash[menge_netto_spalten_name].to_f *
                                   menge_netto_umrechnungsfaktor
        transport_params[:menge_brutto] = menge_brutto_spalten_name.nil? ? nil : row_as_hash[menge_brutto_spalten_name].to_f *
                                   menge_brutto_umrechnungsfaktor
        transport_params[:behaelter] = row_as_hash[behaelter_spalten_name] if behaelter_spalten_name
        transport_params[:quelle] = quelle
        # TODO: Genehmigung erstellen!
        #genehmigung = create_or_find_genehmigung(row_as_hash, genehmigungs_params)
        #transport_params[:transportgenehmigung] = genehmigung if genehmigung

        transport = Transport.new(transport_params)
        @logger.puts "Transport eingelesen #{transport.attributes}"
        if transport.save 
          @transporte_anzahl += 1
          @logger.puts "Transport gespeichert."
          # Transportabschnitte zu Transportfirmen erstellen, wenn vorhanden
          if firmen_spalten_name
            create_transportabschnitte_to_firmen(row_as_hash[firmen_spalten_name], firma_trennzeichen, transport)
          end
          # Umschlaege erstellen 
          unless umschlag_params.nil?
            create_umschlag_data(row_as_hash, umschlag_params, transport)
          end
        else 
          # Je nach Einstellung Transporte verschmelzen
          if params[:einstellung_vorhandene_transporte] == "J"
            @logger.puts "Verschmelze_Transporte"
            join_to_old_transport(row_count, transport) 
          else 
            @transporte_liste[row_count] = transport 
          end
        end
        row_count += 1
    end 
    @logger.close
    session.clear if @transporte_liste.empty?
    render "fertig"
  end

 
  # verschmilzt den Transport mit einem vorhandenen.
  def join_to_old_transport(row_count, new_transport)
    old_transport = Transport.find_by(datum: new_transport.datum, start_anlage: new_transport.start_anlage, ziel_anlage: new_transport.ziel_anlage)
    if old_transport
      if old_transport.add(new_transport)
        if old_transport.save
          @anzahl_verschmolzene += 1
        else 
          @transporte_liste[row_count] = old_transport.errors.full_messages
        end
      else
        @transporte_liste[row_count] = new_transport
      end
    else
      # Zu Fehlerliste hinzufuegen 
      @transporte_liste[row_count] = new_transport 
    end
  end 
  


  private
    
    def read_headers_from_csv(file_path)
      csv_text =  File.read(file_path) 
      csv = CSV.parse(csv_text, :headers => true, :col_sep => session[:csv_trennzeichen])
      csv.headers
    end


    # Legt fuer jede im firmen_name_string vorkommenden Firmennamen einen Transportabschnitt zum transport an.
    # Getrennt wird dabei der String durch das übergebene Trennzeichen.
    #
    def create_transportabschnitte_to_firmen(firmen_name_string, firma_trennzeichen, transport)
      if firmen_name_string
        firmen_namen = firmen_name_string.split(firma_trennzeichen)
        firmen_namen.each do |firma_name|
          firma = Firma.find_or_create_firma(firma_name)
          create_abschnitt_to_firma(firma, transport)
        end
         
      end
    end
    
   
    
    def create_abschnitt_to_firma(firma, transport, is_reederei = false)
      # Transportabschnitt fuer die Firma anlegen
      transportabschnitt = Transportabschnitt.new(firma: firma, transport: transport) 
      unless transportabschnitt.save
        # Fehlerbehandlung
      end
      return transportabschnitt
    end

    # Macht die Parameter mit den Spaltennamen für die Genehmigung
    #
    def read_genehmigungs_params params
      genehmigungs_params = Hash.new
      genehmigungs_params[:lfd_nr] = params[:lfd_nr]
      genehmigungs_params[:antragssteller] = params[:antragssteller]
      genehmigungs_params[:antragsdatum] = params[:antragsdatum]
      genehmigungs_params[:max_anzahl] = params[:max_anzahl]
      genehmigungs_params[:schiene] = params[:schiene]
      genehmigungs_params[:strasse] = params[:strasse]
      genehmigungs_params[:see] = params[:see]
      genehmigungs_params[:luft] = params[:luft]
      genehmigungs_params[:umschlag] = params[:umschlag]
      genehmigungs_params[:erstellungsdatum] = params[:erstellungsdatum]
      genehmigungs_params[:gueltigkeit] = params[:gueltigkeit]
      genehmigungs_params[:stoff] = params[:stoff]
      genehmigungs_params
    end
    
    # Macht die Parameter mit den Spaltennamen für die Genehmigung
    #
    def read_umschlag_params params
      umschlag_params = Hash.new
      umschlag_params[:ort] = params[:umschlag_ort]
      umschlag_params[:terminal] = params[:umschlag_terminal]
      umschlag_params[:ankunft_datum] = params[:umschlag_ankunft_datum]
      umschlag_params[:ankunft_zeit] = params[:umschlag_ankunft_zeit]
      umschlag_params[:abfahrt_datum] = params[:umschlag_abfahrt_datum]
      umschlag_params[:abfahrt_zeit] = params[:umschlag_abfahrt_zeit]
      umschlag_params[:abtransport] = params[:abtransport]
      umschlag_params[:lkw] = params[:lkw]
      umschlag_params[:bahn] = params[:bahn]
      umschlag_params[:schiff] = params[:schiff]
      umschlag_params[:reederei] = params[:reederei]
      umschlag_params
    end

    # Liest aus der gegebenen Zeile die Daten für die Erstellung einer Genehmigung ein.
    # Voraussetzung ist, dass die laufende Nummer der Genehmigung angegeben ist.
    #
    def create_or_find_genehmigung(row_as_hash, genehmigungs_params)
      if genehmigungs_params
        genehmigungs_hash = Hash.new
        genehmigungs_params.each do |merkmal, spalten_name|
          # Konvertierung der boolschen Felder
          if [:schiene, :strasse, :see, :luft, :umschlag].include? merkmal
            genehmigungs_hash[merkmal] = row_as_hash[spalten_name] == "ja"
          # Konvertierung der Datumsfelder
          elsif [:erstellungsdatum, :gueltigkeit, :antragsdatum].include? merkmal
            datum_werte = row_as_hash[datum_spalten_name].split(".") 
            genehmigungs_hash[merkmal] = Date.new(datum_werte[2].to_i,datum_werte[1].to_i,datum_werte[0].to_i)
          elsif merkmal == :max_anzahl
            genehmigungs_hash[merkmal] = row_as_hash[spalten_name].to_i
          # String-Felder werden übernommen
          elsif [:lfd_nr, :antragssteller, :gueltigkeit, :stoff].include? merkmal
            genehmigungs_hash[merkmal] = row_as_hash[spalten_name]
          end
        end
        genehmigungs_hash
      else 
        nil
      end
    end
    
    def create_umschlag_data(row_as_hash, umschlag_params, transport)
      umschlag = Umschlag.new
      umschlag.transport = transport
      unless umschlag_params[:ort]=="Nicht vorhanden" 
        umschlag.ort = Ort.find_or_create_ort(row_as_hash[umschlag_params[:ort]]) 
      end
      unless umschlag_params[:terminal]=="Nicht vorhanden"
        umschlag.terminal = row_as_hash[umschlag_params[:terminal]] 
      end
      unless params[:abtransport] == "Nicht vorhanden"
        # Wenn Transport von Umschlagort weg mit Schiff
        if row_as_hash[params[:abtransport]]=="ja"
          # Umschlag endet mit Abfahrt Schiff
          abfahrt_datum = create_datetime(row_as_hash, umschlag_params[:abfahrt_datum], umschlag_params[:abfahrt_zeit])
          umschlag.end_datum = abfahrt_datum
          umschlag.save
          # Transportabschnitt davor anlegen
          abschnitt = Transportabschnitt.new 
          abschnitt.transport = transport
          abschnitt.end_ort = umschlag.ort 
          if umschlag_params[:lkw] && umschlag_params[:bahn]
            abschnitt.verkehrstraeger = get_verkehrsmittel(row_as_hash[umschlag_params[:lkw]], row_as_hash[umschlag_params[:bahn]])
          end
          unless abschnitt.save 
            # Fehlerbehandlung
          end
          # Transportabschnitt danach anlegen
          abschnitt = lege_abschnitt_zu_schiff_an(row_as_hash, umschlag_params, transport)
          abschnitt.start_datum = abfahrt_datum
          abschnitt.start_ort = umschlag.ort
          unless abschnitt.save 
            # Fehlerbehandlung
          end
        else
          # Umschlag beginnt mit Ankunft Schiff
          ankunft_datum = create_datetime(row_as_hash, umschlag_params[:ankunft_datum], umschlag_params[:ankunft_zeit])
          umschlag.start_datum = ankunft_datum
          unless umschlag.save
            @logger.puts umschlag.errors
          end
          # Transportabschnitt danach anlegen
          abschnitt = Transportabschnitt.new 
          abschnitt.transport = transport
          abschnitt.start_ort = umschlag.ort 
          if umschlag_params[:lkw] && umschlag_params[:bahn]
            #@logger.puts "weiteren abschnitt verkehrstraeger waehlen"
            abschnitt.verkehrstraeger = get_verkehrsmittel(row_as_hash[umschlag_params[:lkw]], row_as_hash[umschlag_params[:bahn]])
          end
          unless abschnitt.save 
            # Fehlerbehandlung
            @logger.puts abschnitt.errors
          end
          # Transportabschnitt davor anlegen
          abschnitt = lege_abschnitt_zu_schiff_an(row_as_hash, umschlag_params, transport)
          abschnitt.end_datum = ankunft_datum
          abschnitt.end_ort = umschlag.ort
          unless abschnitt.save 
            # Fehlerbehandlung
            @logger.puts abschnitt.errors
          end
        end
      end
    end 
    
    def lege_abschnitt_zu_schiff_an(row_as_hash, umschlag_params, transport)
      firma = nil
      if umschlag_params[:reederei] == "Nicht vorhanden"
        abschnitt = Transportabschnitt.new 
      else 
        firma = Firma.find_or_create_firma(row_as_hash[umschlag_params[:reederei]])
        @logger.puts firma.attributes
        abschnitt = create_abschnitt_to_firma(firma, transport, true)
      end
      abschnitt.verkehrstraeger = "Schiff"
      unless umschlag_params[:schiff] == "Nicht vorhanden"
        schiff = Schiff.find_or_create_schiff(row_as_hash[umschlag_params[:schiff]],firma)
        abschnitt.schiff = schiff
      end
      abschnitt
    end
    

    
    def create_datetime(row_as_hash, date_or_datetime, time)
      if date_or_datetime =="Nicht vorhanden"
        nil
      else
        if time =="Nicht vorhanden"
          row_as_hash[date_or_datetime]
        else
          date = Date.strptime(row_as_hash[date_or_datetime],"%d.%m.%y")
          @logger.puts "#{date} #{row_as_hash[time]}"
          "#{date} #{row_as_hash[time]}"
        end
      end 
    end 
    
    def get_verkehrsmittel(lkw_wert, bahn_wert)
      if lkw_wert == "ja"
        "LKW"
      elsif bahn_wert == "ja"
        "Zug"
      end
    end 
    
    # Zum Anzeigen unterschiedlicher Fehlermeldungen.
    #
    def upload_fehler(notice_string)
      flash[:danger] = notice_string
      redirect_to upload_index_path
    end
    
    def create_anlagen_synonyme(anlagen_strings)
      @synonym_liste = []
      synonym_ids = []
      anlagen_strings.each do |anlage_name|
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
      synonym_ids
    end
    
    def create_stoff_synonyme(stoff_strings)
      synonym_ids = []
      stoff_strings.each do |stoff_name|
        # Synonym
        synonym = StoffSynonym.find_by synonym: stoff_name
        synonym ||= StoffSynonym.new({:synonym => stoff_name})
        if synonym.save 
          synonym_ids << synonym.id
        else 
          # TODO: Fehlerbehandlung
        end
      end
      synonym_ids
    end


end
