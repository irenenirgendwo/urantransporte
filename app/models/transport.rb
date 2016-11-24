# encoding: utf-8
# Kuemmert sich um alle Sachen, die konkret mit dem Transport zusammen haengen,
# also auch z.B. Sortierung der entsprechenden Abschnitte und Umschlaege.
#
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

  # Sucht Transporte rund um ein bestimmtes Datum mit gleichem Start bzw. Ziel
  #
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
  # wird für Kalenderdarstellung benötigt
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
  
  def start_datum
    start_datum, end_datum = get_start_and_end_datum self.sort_abschnitte_and_umschlaege
    start_datum
  end
  
  def end_datum
    start_datum, end_datum = get_start_and_end_datum self.sort_abschnitte_and_umschlaege
    end_datum
  end
  
  
 
  # Neue Methode zur Sortierung, geht erst nach Orten, auch wenn kein Startort drin.
  # Hilfsmethoden im Private-Teil.
  #
  def sort_abschnitte_and_umschlaege
    abschnitt_umschlag_list = []
    # Hilfsmethode, baut einen nach Orten sortierten Hash auf.
    ort_to_detail = sort_abschnitte_and_umschlaege_by_ort
    File.open("log/transport.log","w"){|f| f.puts "Ort to detail #{ort_to_detail}" }
    unless self.start_anlage.nil?
      if self.start_anlage.ort
        ort_aktuell = self.start_anlage.ort
        if ort_aktuell.nil? || ort_to_detail[ort_aktuell.id].nil?
          ort_aktuell = abschnitt_only_start_ort(ort_to_detail.keys) 
        end 
        counter = 0
        while not (ort_aktuell.nil? || ort_to_detail.empty? || counter > 100)
          counter += 1
          next_ort = nil
          ort_aktuell_id = ort_aktuell.nil? ? 0 : ort_aktuell.id 
          unless ort_to_detail[ort_aktuell_id].nil?
            ort_to_detail[ort_aktuell_id].each do |abschnitt_umschlag|
              File.open("log/transport.log","a"){|f| f.puts abschnitt_umschlag.attributes }
              abschnitt_umschlag_list << abschnitt_umschlag
              next_ort = abschnitt_umschlag.end_ort if abschnitt_umschlag.kind_of? Transportabschnitt  
            end
            ort_to_detail.delete(ort_aktuell_id) 
            ort_aktuell = next_ort
          end
        end 
        # Rest nach Datum sortieren
        unless ort_to_detail.empty?
          File.open("log/transport.log","a"){|f| f.puts "Rest nach Datum" }
          abschnitt_umschlag_list = abschnitt_umschlag_list.concat(sort_abschnitte_and_umschlaege_by_date(ort_to_detail.values.flatten))
        end
      else 
        #File.open("log/transport.log","a"){|f| f.puts "Alles nach Datum" }
        abschnitt_umschlag_list = abschnitt_umschlag_list.concat(sort_abschnitte_and_umschlaege_by_date(ort_to_detail.values.flatten))
      end 
    end
    #File.open("log/transport.log","a"){|f| f.puts "Transport #{id}: #{abschnitt_umschlag_list.to_s}" }
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
      abschnitt.orte.each do |ort|
        check_ort_ll(orte, ort)
      end
    end
    umschlaege.each do |umschlag|
      check_ort_ll(orte, umschlag.ort)
    end
    orte
  end
  
  def get_known_orte_without_routen
    orte = []
    check_ort_ll(orte, start_anlage.ort)
    check_ort_ll(orte, ziel_anlage.ort)
    transportabschnitte.each do |abschnitt|
      abschnitt.orte_without_routen.each do |ort|
        check_ort_ll(orte, ort)
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
    # Transportabschnitte inklusive Beobachtungsorte und Strecke der Route
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
    end
    # Umschlaege
    umschlaege.each do |umschlag|
      check_ort_p(orte, umschlag.ort, "Umschlag")
    end
    # Start und Zielanlage zuletzt, damit auf jeden Fall das aktuellste, andere werden ggf. ueberschrieben
    check_ort_p(orte, start_anlage.ort, "Start-Anlage")
    check_ort_p(orte, ziel_anlage.ort, "Ziel-Anlage")
    if strecken.empty? 
      if umschlaege.empty? && start_anlage.ort && ziel_anlage.ort && start_anlage.ort.lat && ziel_anlage.ort.lat
        strecken << [start_anlage.ort, ziel_anlage.ort] 
      elsif start_anlage.ort && start_anlage.ort.lat
        ort_aktuell = start_anlage.ort
        umschlaege.each do |umschlag|
          if umschlag.ort
            strecken << [ort_aktuell, umschlag.ort]
            ort_aktuell = umschlag.ort
          end
        end
        if ziel_anlage.ort && ziel_anlage.ort.lat
          strecken << [ort_aktuell, ziel_anlage.ort]
        end
      end
    end
    return orte, strecken
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


  private 
  
  
  ## Hilfsmethoden zur Sortierung von Umschlag- und Transportkette
  
  
    # Sortiert alle Umschlaege und Transportabschnitte in einen Hash,
    # der jeweils den (Start)Ort einer Liste aus Umschlaegen/Abschnitten zuordnet.
    # Umschlaege kommen dabei automatisch zuerst.
    #
    def sort_abschnitte_and_umschlaege_by_ort
      ort_to_detail = {}
      self.umschlaege.each do |umschlag|
        ort = umschlag.ort
        ort_id = ort.nil? ? 0 : ort.id
        ort_to_detail[ort_id] ||= []
        ort_to_detail[ort_id] << umschlag
      end 
      self.transportabschnitte.each do |abschnitt|
        ort = abschnitt.start_ort
        ort_id = ort.nil? ? 0 : ort.id
        ort_to_detail[ort_id] ||= []
        ort_to_detail[ort_id] << abschnitt
      end 
      ort_to_detail
    end 
    
    # Ermittelt den Ort aus dem uebergebenen Array, der kein End-Ort eines 
    # Transportabschnitts ist (also der Start der Eingabe)
    #
    def abschnitt_only_start_ort orte
      orte.each do |ort_id|
        if !ort_id==0 && self.transportabschnitte.where(end_ort_id: ort_id).empty?
          return ort 
        end 
      end 
      nil
    end 
    
    # Sortiert die uebergebene List mit Umschlaegen und Abschnitten nach dem End-Datum.
    # Eintraege ohne werden ans Ende gehaengt.
    #
    def sort_abschnitte_and_umschlaege_by_date start_liste
      abschnitt_umschlag_list = []
      mit_end_datum = start_liste.select{|element| element.end_datum }
      #File.open("log/transport.log","a"){|f| f.puts "Mit Ende #{mit_end_datum.to_s}" }
      abschnitt_umschlag_list.concat(mit_end_datum.sort_by{|element| element.end_datum} )
      ohne_end_datum = start_liste.select{|element| element.end_datum.nil? }
      #File.open("log/transport.log","a"){|f| f.puts "Ohne Ende: #{ohne_end_datum.to_s}" }
      abschnitt_umschlag_list.concat(ohne_end_datum)
      #File.open("log/transport.log","a"){|f| f.puts "Liste bei Date #{abschnitt_umschlag_list.to_s}" }
      abschnitt_umschlag_list
    end
    

  ## Hilsmethoden fuers Sammeln der Orte
  
    def check_ort_ll(ort_array, ort)
      unless ort_array.include? ort
        ort_array << ort if ort and ort.lon and ort.lat
      end
    end
    
    def check_ort_p(ort_hash,ort,prop)
      if ort and ort.lon and ort.lat
        ort_hash[ort] = prop
      end
    end 
  
  
  
  # Sortiert Transportabschnitte und Umschlaege (Logik in den Controller).
  # Funktioniert auch bei unvollstaendigen Umschlaegen oder Transportabschnitten.
  #
  # depricated
  #def sort_abschnitte_and_umschlaege_old
    #abschnitt_umschlag_list = []
    #abschnitte = self.transportabschnitte.order(:start_datum)
    
    #listed_umschlaege = []
    #listed_abschnitte = []
    
    ## Prioritaer: Ortssortierung, sonst Zeit, beginnend mit Start-Ort der Anlage.
    #if self.start_anlage.ort
      #ort_aktuell = self.start_anlage.ort.id
      #abschnitt_aktuell = abschnitte.where(start_ort_id: self.start_anlage.ort.id)
      #i = 0 
      #last_umschlag = nil
      #while ort_aktuell && i < 1000
        ##File.open("log/transport.log","a"){|f| f.puts "Aktueller Ort #{ort_aktuell}" }
        #i += 1
        ## erst umschlaege mit ort suchen, wenn zuletzt kein Umschlag war
        #unless last_umschlag
          #umschlaege = self.umschlaege.where(ort_id: ort_aktuell)
          #umschlaege.each do |umschlag|
            #abschnitt_umschlag_list << umschlag
            #listed_umschlaege << umschlag
            #last_umschlag = true
            #File.open("log/transport.log","a"){|f| f.puts "Umschlag  #{umschlag.attributes}" }
          #end
        #end
        ## dann abschnitte hinzufuegen
        #abschnitte = self.transportabschnitte.where(start_ort_id: ort_aktuell)
        #abschnitte.each do |abschnitt|
          #abschnitt_umschlag_list << abschnitt
          #listed_abschnitte << abschnitt
          #ort_aktuell = abschnitt.end_ort ? abschnitt.end_ort.id : nil
          #last_umschlag = false
          ## Chaos gibt es wenn mehrere Abschnitte an einem Ort beginnen, 
          ##sollte aber ja nicht der Normalfall sein.
        #end
        
        
        ## Abbruchbedingung
        #if abschnitte.empty? && umschlaege.empty?
          #ort_aktuell = false
        #end
        
      #end 
    
    #end
    
    
    

    ##umschlaege = self.umschlaege
    
    ## ortsweise sortieren so moeglich
    ##if abschnitte_mit_ende
    ##  abschnitt_first = abschnitte_mit_ende.first 
    ##  if abschnitt_first
   ## 
    ##listed_umschlaege = []
    ##abschnitte_mit_ende.each do |abschnitt|
    ##  abschnitt_umschlag_list << abschnitt
    ##  umschlag = self.umschlaege.find_by ort_id: abschnitt.end_ort_id
    ##  unless umschlag.nil?
    ##    abschnitt_umschlag_list << umschlag
    ##    listed_umschlaege << umschlag
    ##  end
    ##end 
    
    ## Restliche Abschnitte
    #if listed_abschnitte.size < self.transportabschnitte.size
      #self.transportabschnitte.where.not(end_datum: nil).order(:end_datum).each do |abschnitt|
        #unless listed_abschnitte.include? abschnitt
          #abschnitt_umschlag_list << abschnitt
        #end
      #end 
      #self.transportabschnitte.where(end_datum: nil).order(:end_datum).each do |abschnitt|
        #unless listed_abschnitte.include? abschnitt
          #abschnitt_umschlag_list << abschnitt
        #end
      #end 
    #end
    
    ## Restliche Umchlaege
    #if listed_umschlaege.size < self.umschlaege.size
      #self.umschlaege.each do |umschlag|
        #unless listed_umschlaege.include? umschlag
          #abschnitt_umschlag_list << umschlag
        #end
      #end 
    #end
    

   # abschnitt_umschlag_list 
  #end
      

end
