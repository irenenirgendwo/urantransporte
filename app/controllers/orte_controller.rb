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
  
  def new
    @name = params[:name]
  end
  
  def create_from_name
    @ort = Ort.new(:name => params[:name])
    respond_to do |format|
      if @ort.save
        format.html { redirect_to @ort, notice: 'Ort was successfully created.' }
        format.json { render :show, status: :created, location: @ort }
      else
        format.html { render :ortseingabe }
        format.json { render json: @ort.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def create_from_coordinates
    @ort = Ort.create_by_koordinates(params[:lat],params[:lon])
    respond_to do |format|
      if @ort.save
        format.html { redirect_to @ort, notice: 'Ort was successfully created.' }
        format.json { render :show, status: :created, location: @ort }
      else
        format.html { render :ortseingabe }
        format.json { render json: @ort.errors, status: :unprocessable_entity }
      end
    end
  end
  
end
