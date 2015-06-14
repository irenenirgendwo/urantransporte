# Modul zur Ortsauswahl wenn ein Ortseingabe- oder Aenderungsformular eingebunden ist.
# Kann eingebunden werden fuer alle Objekte die einen Ort ansteuerbar ueber "ort" haben, 
# also Anlagen, Umschlaege, Beobachtungen
#
module OrteAuswahl

  # Grundgerüst der Ortsauswahl bei Mehrfachtreffern - vielleicht funktionsfähig
  # Testweise eingebunden nur beim Erstellen neuer Anlagen und Update.
  #
  # Idee: Alle passenden Orte werden in einem Auswahlfenster angezeigt.
  # Die passenden Orte werden mittels ort_waehlen (orte_mit_namen bzw. lege_passende_orte_an)
  # im Ort-Modell gesucht bzw. angelegt.
  # Dann werden die angelegten Orte zum Aufruf einer ortsauswahl-Funktion aus dem OrteController verwendnet.
  #
  # TODO: Wenn kein Ort gefunden wurde, anderes Ortswahlfenster anlegen mit Ort neu suchen koennen,
  # über Orte-Controller, vermutlich ähnlich.
  #
  def evtl_ortswahl_weiterleitung_und_anzeige(objekt, ortsname, plz, lat, lon, aktion)
    # Log-File für Feller finden
    File.open("log/ort.log","a"){|f| f.puts "ortsname im anlagenKontroller #{ortsname} #{ortsname.nil?} #{ortsname==""}" }
    File.open("log/ort.log","a"){|f| f.puts "anlage.ort #{objekt.ort.to_s}" }
    eindeutig = true
    
    # Wenn Koordinaten eingegeben sind, diese beim Ort in der Nähe abspeichern 
    # (wenn es einen gibt) oder einen neuen Ort mit diesen Koordinaten anlegen.
    if lat && lon && lat!="" && lon!=""
      File.open("log/ort.log","a"){|f| f.puts "lat und lon #{lat}, #{lon}" }
      File.open("log/ort.log","a"){|f| f.puts "objekt.ort #{objekt.ort}" }
      if ortsname == "" || ortsname.nil?
        # Wenn kein Ortsname angegeben war, den alten verwenden (so vorhanden) und Koordinaten umsetzen
        # oder wenn kein alter Name da war, einen neuen Ort nach den Koordinaten anlegen.
        if objekt.ort.nil?
          objekt.ort = Ort.create_by_koordinates(lat,lon) 
          eindeutig = true
        else
          File.open("log/ort.log","a"){|f| f.puts "Ort gefunden #{objekt.ort.attributes}" }
          # Ortskoordinaten umsetzen oder besser neuen Ort erzeugen?
          # ich wär für neuen Ort - führt sonst zu Chaos bei Korrekturen über weite Strecken
          objekt.ort.lat = lat 
          objekt.ort.lon = lon
          objekt.ort.save
        end
      else
        File.open("log/ort.log","a"){|f| f.puts "Es gibt Ortsnamen und Koordinaten" }

        # Wenn Ortsname und Koordinaten gegeben sind, wird nach einem passenden Ort
        # in der Naehe gesucht und falls dieser existiert, dort die Koordinaten upgedated.
        # Sonst wird der Ort neu angelegt mit Koordinaten und Namen.
        temp_ort = Ort.create_by_koordinates_and_name(ortsname, lat, lon)
        ort_m = nil
        temp_ort.orte_im_umkreis(10).each do |moegl_ort|
          if moegl_ort.name == ortsname
            ort_m = moegl_ort
          end
        end
        if ort_m 
          File.open("log/ort.log","a"){|f| f.puts "Passenden Ort gefunden" }
          ort_m.lat = lat
          ort_m.lon = lon
          ort_m.plz = plz unless plz.nil? || plz==""
          ort_m.save
          objekt.ort = ort_m
          eindeutig = true
        else
          File.open("log/ort.log","a"){|f| f.puts "Temp-Ort behalten" }
          temp_ort.save
          objekt.ort = temp_ort
          eindeutig = true
        end
        ort_e = objekt.ort
      end
    else
      File.open("log/ort.log","a"){|f| f.puts "Es keine Koordinaten" }
      # Sind keine Koordinaten angegeben, nach dem Ortsnamen entsprechende Orte suchen / anlegen
      # und in ort_e bereit stellen.
      unless ortsname=="" || ortsname.nil? || (aktion=="update" && ortsname == objekt.ort.to_s)
        eindeutig, ort_e = Ort.ort_waehlen(ortsname)
        File.open("log/anlagen.log","a"){|f| f.puts "ort_e #{ort_e}" }
        if eindeutig
          objekt.ort = ort_e
        else 
          # wird nach dem Anlagen speichern gesetzt.
          objekt.ort = nil 
        end
      end
    end

    return eindeutig, ort_e
  end
  
  # Sorgt dafuer, dass beim Ort updaten nach dem Ort mit neuem Namen gesucht wird,
  # wenn die Koorinaten nicht geaendert wurden.
  # Reine Namensaenderungen von orten muessen also ueber die Orte-Aenderungsfunktion passieren.
  #
  def update_ort(objekt, alter_ort, new_name, plz, lat, lon, aktion)
    #File.open("log/ort.log","w"){|f| f.puts "lat old #{alter_ort.lat} lat new #{lat} #{alter_ort.lat.to_s == lat.to_s}" }
    if alter_ort && alter_ort.lat.to_s == lat.to_s && alter_ort.lon.to_s == lon.to_s
      #File.open("log/ort.log","a"){|f| f.puts "new: #{new_name} old: #{alter_ort.name}"}
      unless new_name == alter_ort.name
        lat = nil 
        lon = nil 
        plz = nil
      end
    end
    return evtl_ortswahl_weiterleitung_und_anzeige(objekt, new_name, plz, lat, lon, aktion)
  end

end
