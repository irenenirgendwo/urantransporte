# encoding: utf-8
class Transport < ActiveRecord::Base

  # Transportabschnitte und -umschlaege mit loeschen, beim Loeschen des Transports
  has_many :transportabschnitte, :dependent => :delete_all
  has_many :umschlaege, :dependent => :delete_all
  belongs_to :transportgenehmigung
  has_many :versandstuecke

  belongs_to :start_anlage, :class_name => 'Anlage'
  belongs_to :ziel_anlage, :class_name => 'Anlage'
  belongs_to :stoff

  # Validations, eindeutige Identifizierung des Transports durch Datum, Start- und Zielanlage
  validates :datum, presence: true
  validates :start_anlage, presence: true
  validates :ziel_anlage, presence: true
  validates :datum, :uniqueness => {:scope => [:start_anlage, :ziel_anlage]}
  
  # Gibt passende Transporte rund um ein gegebenes Datum aus
  #
  def self.get_transporte_around(datum,plus_minus_tage)
    Transport.where("datum >= ? and datum <= ?", datum.to_date - plus_minus_tage.days, datum.to_date + plus_minus_tage.days)
  end

  def self.get_transporte_around_options(datum,plus_minus_tage, start, ziel)
    transporte = get_transporte_around(datum,plus_minus_tage)
    transporte = transporte.where(start_anlage: start) if start 
    transporte = transporte.where(ziel_anlage: ziel) if ziel
    transporte
  end
  
  def get_umschlag date
    self.umschlaege.where("start_datum <= ? and end_datum >= ?", date, date).first
  end
  
  def get_abschnitt date
    self.transportabschnitte.where("start_datum <= ? and end_datum >= ?", date, date).first
  end
  
  # Integriert in diesen Transport den übergebenen Transport.
  # Dabei werden alle Transportabschnitte und Umschlaege in diesen Transport uebernommen.
  # Transport wird in der Datenbank gespeichert.
  #
  def add(other_transport)
    # Attribute die nur im neuen Transport sind, im jetzigen setzen.
    self.attributes.each do |attribute_name, attribute_value|
      self.send("#{attribute_name}=", other_transport.send(attribute_name)) if attribute_value.nil?
    end
    # Transportabschnitte erstmal alle hinzufügen, gleiches mit Umschlaegen.
    # Frage: Wie Transportabschnitte identifiziert?
    other_transport.transportabschnitte.each do |abschnitt|
	  abschnitt.transport = self
	  return nil unless abschnitt.save 
    end
    other_transport.umschlaege.each do |umschlag|
	  umschlag.transport = self
	  return nil unless umschlag.save 
    end
    #return nil unless self.save
    # TODO: Bei gleichem Umschlag / Fahrtabschnitt 
    # evtl. was anderes machen als einfach hinzufuegen.
    return true
  end
  

  # Sucht das Gesamtstart- und Enddatum aus den Transportabschnitten raus.
  #
  def get_start_and_end_datum abschnitt_umschlag_list
    start_datum = self.datum
    end_datum = self.datum
    abschnitt_umschlag_list.each do |abschnitt|
      if abschnitt.start_datum && abschnitt.start_datum < start_datum
        start_datum = abschnitt.start_datum
      end
      if abschnitt.end_datum && abschnitt.end_datum > end_datum
        end_datum = abschnitt.end_datum
      end
    end 
    return start_datum.to_date, end_datum.to_date
  end
  
  # Sortiert Transportabschnitte und Umschlaege (Logik in den Controller).
  # Funktioniert auch bei unvollstaendigen Umschlaegen oder Transportabschnitten.
  #
  def sort_abschnitte_and_umschlaege
    abschnitt_umschlag_list = []
    abschnitte = self.transportabschnitte.order(:end_datum)
    
    listed_umschlaege = []
    listed_abschnitte = []
    
    # Prioritaer: Ortssortierung, sonst Zeit, beginnend mit Start-Ort der Anlage.
    if self.start_anlage.ort
      ort_aktuell = self.start_anlage.ort.id
      abschnitt_aktuell = abschnitte.where(start_ort_id: self.start_anlage.ort.id)
      i = 0 
      last_umschlag = nil
      while ort_aktuell && i < 1000
        #File.open("log/transport.log","a"){|f| f.puts "Aktueller Ort #{ort_aktuell}" }
        i += 1
        # erst umschlaege mit ort suchen, wenn zuletzt kein Umschlag war
        unless last_umschlag
          umschlaege = self.umschlaege.where(ort_id: ort_aktuell)
          umschlaege.each do |umschlag|
            abschnitt_umschlag_list << umschlag
            listed_umschlaege << umschlag
            last_umschlag = true
            File.open("log/transport.log","a"){|f| f.puts "Umschlag  #{umschlag.attributes}" }
          end
        end
        # dann abschnitte hinzufuegen
        abschnitte = self.transportabschnitte.where(start_ort_id: ort_aktuell)
        abschnitte.each do |abschnitt|
          abschnitt_umschlag_list << abschnitt
          listed_abschnitte << abschnitt
          ort_aktuell = abschnitt.end_ort ? abschnitt.end_ort.id : nil
          last_umschlag = false
          # Chaos gibt es wenn mehrere Abschnitte an einem Ort beginnen, 
          #sollte aber ja nicht der Normalfall sein.
        end
        
        
        # Abbruchbedingung
        if abschnitte.empty? && umschlaege.empty?
          ort_aktuell = false
        end
        
      end 
    
    end
    
    

    #umschlaege = self.umschlaege
    
    # ortsweise sortieren so moeglich
    #if abschnitte_mit_ende
    #  abschnitt_first = abschnitte_mit_ende.first 
    #  if abschnitt_first
   # 
    #listed_umschlaege = []
    #abschnitte_mit_ende.each do |abschnitt|
    #  abschnitt_umschlag_list << abschnitt
    #  umschlag = self.umschlaege.find_by ort_id: abschnitt.end_ort_id
    #  unless umschlag.nil?
    #    abschnitt_umschlag_list << umschlag
    #    listed_umschlaege << umschlag
    #  end
    #end 
    
    # Restliche Abschnitte
    if listed_abschnitte.size < self.transportabschnitte.size
      self.transportabschnitte.where.not(end_datum: nil).order(:end_datum).each do |abschnitt|
        unless listed_abschnitte.include? abschnitt
          abschnitt_umschlag_list << abschnitt
        end
      end 
      self.transportabschnitte.where(end_datum: nil).order(:end_datum).each do |abschnitt|
        unless listed_abschnitte.include? abschnitt
          abschnitt_umschlag_list << abschnitt
        end
      end 
    end
    
    # Restliche Umchlaege
    if listed_umschlaege.size < self.umschlaege.size
      self.umschlaege.each do |umschlag|
        unless listed_umschlaege.include? umschlag
          abschnitt_umschlag_list << umschlag
        end
      end 
    end
    
    
   
    abschnitt_umschlag_list 
  end
  
  # Sammelt alle Durchfahrtsorte zusammen, aus Anlagenorten, Umschlagsorten, Abschnitten
  # und zugeordneten Beobachtungen
  #
  def get_known_orte
    orte = []
    check_ort_ll(orte, start_anlage.ort)
    check_ort_ll(orte, ziel_anlage.ort)
    transportabschnitte.each do |abschnitt|
      check_ort_ll(orte, abschnitt.start_ort)
      check_ort_ll(orte, abschnitt.end_ort)
      abschnitt.beobachtungen.each do |beob|
        check_ort_ll(orte, beob.ort)
      end
      abschnitt.orte.each do |durchfahrt|
        check_ort_ll(orte, durchfahrt)
      end
    end
    umschlaege.each do |umschlag|
      check_ort_ll(orte, umschlag.ort)
    end
    orte
  end
  
  # Sammelt alle Durchfahrtsorte zusammen, aus Anlagenorten, Umschlagsorten, Abschnitten
  # und zugeordneten Beobachtungen
  #
  def get_known_orte_with_props
    orte = {}
    strecken = []
    transportabschnitte.each do |abschnitt|
      if abschnitt.route && abschnitt.route.name != "Unbekannt"
        strecken.concat(abschnitt.route.get_strecken)
      else
        if abschnitt.start_ort && abschnitt.end_ort && abschnitt.start_ort.lat && abschnitt.end_ort.lat
          strecken << [abschnitt.start_ort, abschnitt.end_ort] 
        end
      end
      check_ort_p(orte, abschnitt.start_ort, "Abschnitt")
      check_ort_p(orte, abschnitt.end_ort, "Abschnitt")
      abschnitt.beobachtungen.each do |beob|
        check_ort_p(orte, beob.ort, "Beobachtung")
      end
      #abschnitt.orte.each do |durchfahrt|
      #  check_ort_p(orte, durchfahrt)
      #end
    end
    umschlaege.each do |umschlag|
      check_ort_p(orte, umschlag.ort, "Umschlag")
    end
    check_ort_p(orte, start_anlage.ort, "Start-Anlage")
    check_ort_p(orte, ziel_anlage.ort, "Ziel-Anlage")
    if strecken.empty? && start_anlage.ort && ziel_anlage.ort && start_anlage.ort.lat && ziel_anlage.ort.lat
      strecken << [start_anlage.ort, ziel_anlage.ort] 
    end
    return orte, strecken
  end
  
  
  # Hilfsmethode für get_known_orte
  def check_ort_ll(ort_array, ort)
    unless ort_array.include? ort
      ort_array << ort if ort and ort.lon and ort.lat
    end
  end
  
  def check_ort_p(ort_hash,ort,prop)
    if ort and ort.lon and ort.lat
      #ort_hash[ort] ||=[]
      #ort_hash[ort] << prop
      ort_hash[ort] = prop
    end
  end 
  
  # Gibt die Ids aller Orte zurück
  #
  def orte_ids
    orte = get_known_orte
    orte_ids = []
    orte.each do |ort|
      orte_ids << ort.id
    end
    orte_ids
  end
  
  def to_html
    "<strong>#{self.stoff.bezeichnung}</strong><br>von <strong>#{self.start_anlage}</strong><br>nach <strong>#{self.ziel_anlage}</strong>"
  end
  
  
  # Wozu ist das da?
  def union_scope(*scopes)
      id_column = "#{table_name}.id"
      sub_query = scopes.map { |s| s.select(id_column).to_sql }.join(" UNION ")
      where "#{id_column} IN (#{sub_query})"
  end
  

end
