class OrteController < ApplicationController
  def show
    @ort = Ort.find(params[:id])
  end
  
  def ortswahl
    File.open("log/anlagen.log","a"){|f| f.puts "flash #{flash[:redirect_params]}" }
    @orte = []
    @links = []
    if params[:orte].kind_of? Array
      params[:orte].each do |ort_id|
        auswahl_link = 
          if params[:anlage]
            save_ort_anlage_path(Anlage.find(params[:anlage].to_i), ort: ort_id.to_i)
          elsif params[:umschlag]
            save_ort_umschlag_path(Umschlag.find(params[:umschlag].to_i), ort: ort_id.to_i)
          elsif params[:transportabschnitt]
            save_ort_transportabschnitt_path(Transportabschnitt.find(params[:transportabschnitt].to_i), ort: ort_id.to_i, ortstyp: params[:ortstyp])
          end
        @orte << { "ort" => Ort.find(ort_id.to_i), "link" => auswahl_link }
      end
    end
  end
  
end
