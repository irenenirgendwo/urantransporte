# encoding: utf-8
class Transport < ActiveRecord::Base

  has_many :transportabschnitte
  belongs_to :transportgenehmigung
  has_many :versandstuecke
  has_many :umschlaege

  belongs_to :start_anlage, :class_name => 'Anlage'
  belongs_to :ziel_anlage, :class_name => 'Anlage'	
  belongs_to :stoff

  # Validations, eindeutige Identifizierung des Transports durch Datum, Start- und Zielanlage
  validates :datum, presence: true
  validates :start_anlage, presence: true
  validates :ziel_anlage, presence: true
  validates :datum, :uniqueness => {:scope => [:start_anlage, :ziel_anlage]}
  
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

end
