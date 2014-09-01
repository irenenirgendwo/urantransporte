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
    @anlagen_liste = []
    csv_text =  File.read(file_path) 
    csv = CSV.parse(csv_text, :headers => true, :col_sep => ";")
    csv.each do |row|
      row_as_hash = row.to_hash
      @anlagen_liste << row_as_hash[@spalte_nr1]
      @anlagen_liste << row_as_hash[@spalte_nr2]
    end 
    @anlagen_liste.uniq!
    # Idee: Das ist eine Liste von Synonymen. Jedes Synonym wird gesucht, ist es nicht existent
    # (oder noch keine Anlage zugeordnet),
    # wird es angelegt und in eine Liste auszugebender Synonyme geschrieben. 
    # Zu jedem dieser ausgegebenen Synonyme muss manuell eine Anlage zugeordnet werden,
    # alternativ eine neue angelegt werden, die dann mit dem synonym verbunden wird. 
  end

end
