class ErgaenzeBeobachtungen < ActiveRecord::Migration
  def change
    add_column :beobachtungen, :ankunft_zeit, :time
    add_column :beobachtungen, :abfahrt_zeit, :time
    add_column :beobachtungen, :lat, :float
    add_column :beobachtungen, :lon, :float
    remove_column :beobachtungen, :geo_koordinaten, :string  
    add_column :beobachtungen, :verkehrstraeger, :string
    add_column :beobachtungen, :kennzeichen_radioaktiv, :boolean
    add_column :beobachtungen, :kennzeichen_aetzend, :boolean
    add_column :beobachtungen, :kennzeichen_spaltbar, :boolean
    add_column :beobachtungen, :kennzeichen_umweltgefaehrdend, :boolean
    add_column :beobachtungen, :fahrtrichtung, :string
    add_column :beobachtungen, :gefahr_nummer, :string
    add_column :beobachtungen, :un_nummer, :string
    
    # Daten Zug/LKW/Schiff-spezifisch
    add_column :beobachtungen, :firma_beschreibung, :string
    add_column :beobachtungen, :lok_beschreibung, :text
    add_column :beobachtungen, :container_beschreibung, :text
    add_column :beobachtungen, :anzahl_container, :integer
    add_column :beobachtungen, :zug_beschreibung, :text
    # auch fuer waggon-Anzahl
    add_column :beobachtungen, :anzahl_lkw, :string 
    add_column :beobachtungen, :kennzeichen_lkw, :string
    add_column :beobachtungen, :lkw_beschreibung, :string
    add_column :beobachtungen, :schiff_name, :string
    add_column :beobachtungen, :schiff_beschreibung, :text
    
    add_column :beobachtungen, :polizei, :boolean
    add_column :beobachtungen, :hubschrauber, :boolean
    add_column :beobachtungen, :foto, :boolean
    add_column :beobachtungen, :email, :string
    add_column :beobachtungen, :quelle, :string
      
  end
end
