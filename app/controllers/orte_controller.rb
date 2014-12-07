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
        if params[:anlage]
          auswahl_link = save_ort_anlage_path(Anlage.find(params[:anlage].to_i), ort: ort_id.to_i, )
        end
        @orte << { "ort" => Ort.find(ort_id.to_i), "link" => auswahl_link }
      end
    end
  end
  
end
