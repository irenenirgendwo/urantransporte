# encoding: utf-8
module UploadHelper

  # Setzt entsprechend des Typs die Werte für das anzuzeigende Partial.
  #
  def render_zuordnen_partial(typ, synonym, all_werte)
    case typ
    when "anlage"
      modal = "#anlagenModal"
      neu = "Neue Anlage"
      action = :save_zuordnung
    when "stoff"
      modal = "#stoffModal"
      neu = "Neuer Stoff"
      action = :save_stoffe_zuordnung
    end
    render 'wert_zuordnen', typ: typ, modal_string: modal, neu_string: neu, 
                            action: action, synonym: synonym, all_werte: all_werte 
  end   
end
