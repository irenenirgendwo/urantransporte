class OrteController < ApplicationController

  before_action :set_ort, only: [:show, :edit, :update, :destroy]
  
  
  def index
    @orte = Ort.order(:name)
  end

  def show
  end
  
  # Zeigt ein Formular an zur Auswahl von einem aus mehreren Orten 
  # zu einer Anlage, einem Umschlag oder einem Transportabschnitt.
  # Bei Eingabe eines Ortsnamens und mehreren gefunden Orten kommt mensch hierhin.
  # Nach der Wahl wird der Ort entsprechend abgespeichert mit dem Link zu der 
  # jeweiligen Controller-Methode.
  #
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
    @redirection = params[:redirection] unless params[:redirection].nil? or params[:redirection]==""
  end
  
  def edit
    @redirection = params[:redirection] unless params[:redirection].nil? or params[:redirection]==""
  end
  
  def update
    @redirection = (params[:redirection].nil? || params[:redirection]=="" ) ? @ort : params[:redirection]
    respond_to do |format|
        if @ort.update(:name => params[:name], :lat => params[:lat], :lon => params[:lon])
            flash[:notice] = "Ort aktualisiert."
            format.html { redirect_to @redirection, notice: "Ort aktualisiert."}
            format.json { render :show, status: :created, location: @ort }
        else
          format.html { render :new }
          format.json { render json: @ort.errors, status: :unprocessable_entity }
        end
    end
  end
  
  # Ort kann nur zerstört werden, wenn nicht benutzt.
  # Die Frage ist, ob das so sinnvoll ist?
  #
  def destroy 
    begin
      success = @ort.destroy
    rescue
      success = false
    end  
    respond_to do |format|
      if success 
        format.html { redirect_to orte_path, notice: 'Ort was successfully destroyed.' }
        format.json { head :no_content }
      else 
        format.html { redirect_to @ort, notice: 'Der Ort ist noch Start- oder Zielanlage eines Transports. Deshalb ist das Löschen der Anlage nicht möglich.' }
        format.json { head :no_content }
      end
    end
  end 
  
  # Speichert einen Ort ohne Koordinaten, nur mit Name.
  #
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
  
  # Erstellt einen Ort mit Koordinaten, sucht den Namen aus der Karte, falls er nicht angegeben wurde.
  #
  def create_from_coordinates
    @ort = Ort.create_by_koordinates(params[:lat],params[:lon])
    @ort.name = params[:ortname] unless params[:ortname] == "" or params[:ortname].nil?
    @ort.name = params[:plz] unless params[:plz] == "" or params[:plz].nil?
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
  
  def search
    name = params[:name]
    plz = params[:plz]
    @orte = Ort.order(:name)
    @orte = @orte.where("name LIKE ?", "%#{name}%") unless name.nil? or name==""
    @orte = @orte.where(plz: plz) unless plz.nil? or plz==""
    render "index"
  end
  
  private 
    def set_ort
      @ort = Ort.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ort_params
      params.require(:ort).permit(:name, :lat, :lon, :beschreibung)
    end

  
end
