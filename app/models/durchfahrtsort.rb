class Durchfahrtsort < ActiveRecord::Base

  belongs_to :ort
  belongs_to :route
  
  # Route und Ort müssen da sein, und pro Route gibt es jeden Index nur einmal
  validates :route, presence: true
  validates :reihung, presence: true, :uniqueness => {:scope => [:route]}
  validates :ort, presence: true
  
  validate do |durchfahrtsort| 
    if durchfahrtsort.route.durchfahrtsorte.size == 1 && reihung != 1
      durchfahrtsort.errors[:base] << "Der erste Durchfahrtsort muss den Index 1 haben."
    end
    if reihung > durchfahrtsort.route.durchfahrtsorte.size + 1
      durchfahrtsort.errors[:base] << "Die Durchfahrtsorte müssen aneinander anschließen."
    end
    # Wenn Transportabschnitte zugeordnet sind, darf Start- und Endort nicht verändert werden.
    unless durchfahrtsort.route.transportabschnitte.empty? 
      if durchfahrtsort.route.durchfahrtsorte.size > 1
        if reihung == 1
          durchfahrtsort.errors[:base] << "Der Startort darf nicht verändert werden, weil schon Transportabschnitte zugeordnet sind. Bitte einen anderen Index eingeben."
        elsif reihung == durchfahrtsort.route.durchfahrtsorte.size + 1
          # nur der Endort darf hochgeschoben werden
          unless durchfahrtsort.route.end_ort == durchfahrtsort.ort
            durchfahrtsort.errors[:base] << "Der Endort darf nicht verändert werden, weil schon Transportabschnitte zugeordnet sind. Bitte einen anderen Index eingeben."
          end
        end
      end
    end
  end
  
end
