# encoding: UTF-8
class UploadController < ApplicationController

  require 'csv'

  # Startseite zum Einlesen
  def index
  end

  # Datei auf Server 
  def upload_file
    if params[:upload].nil?
      flash[:notice] = "Bitte eine Datei auswählen"
    else 
      uploaded_io = params[:upload]
      @file_path = Rails.root.join('public', 'uploads', uploaded_io.original_filename)
      File.open(@file_path, 'wb') do |file|
        file.write(uploaded_io.read)
      end
    end
  end

  # Anlagen einlesen
  def read_anlagen
      file_path = params[:file_path]
      @spalte_nr1 = params[:start]
      @spalte_nr2 = params[:ziel]
      # Erstelle @anlagen_liste als Liste von Namen, die in den Spalten auftauchen.
      @anlagen_liste = []
      csv_text =  File.read(file_path) 
      csv = CSV.parse(csv_text, :headers => true, :col_sep => ";")
      csv.each do |row|
        row_as_hash = row.to_hash
        @anlagen_liste << row_as_hash[@spalte_nr1]
        @anlagen_liste << row_as_hash[@spalte_nr2]
      end 
      # Duplikate rauswerfen
      @anlagen_liste.uniq!
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
          # Fehlerbehandlung
        end
      end
      session[:synonym_liste] = synonym_ids
    @all_anlagen = all_anlagen_for_selection
    @anlage = Anlage.new
    @redirect_params = upload_anlagen_zuordnung_path
    # wird es angelegt und in eine Liste auszugebender Synonyme geschrieben. 
    # Zu jedem dieser ausgegebenen Synonyme muss manuell eine Anlage zugeordnet werden,
    # alternativ eine neue angelegt werden, die dann mit dem synonym verbunden wird. 
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
    @all_anlagen = all_anlagen_for_selection
    @anlage = Anlage.new
    @redirect_params = upload_anlagen_zuordnung_path
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
      # Fehlerbehandlung
    end 
  end

  private
    def all_anlagen_for_selection
      all_anlagen = {}
      Anlage.all.each do |anlage|
        all_anlagen[anlage.name] = anlage.id
      end 
      all_anlagen
    end

end
