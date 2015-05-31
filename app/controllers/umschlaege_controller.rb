# encoding: utf-8
class UmschlaegeController < ApplicationController
  before_action :set_umschlag, only: [:show, :edit, :update, :destroy, :save_ort]
  before_action :editor_user, only: [:new, :edit, :create, :update, :destroy]
  
  include OrteAuswahl

  # GET /umschlaege
  # GET /umschlaege.json
  def index
    @umschlaege = Umschlag.all
  end

  # GET /umschlaege/1
  # GET /umschlaege/1.json
  def show
  end

  # GET /umschlaege/new
  def new
    @umschlag = Umschlag.new
    if params[:transport_id]
      @transport = Transport.find(params[:transport_id].to_i)
    end
    if params[:abschnitt_davor]
      abschnitt_davor = Transportabschnitt.find(params[:abschnitt_davor].to_i)
      @umschlag.start_datum = abschnitt_davor.end_datum
      @umschlag.ort = abschnitt_davor.end_ort
    end
    if params[:abschnitt_danach]
      abschnitt_danach = Transportabschnitt.find(params[:abschnitt_danach].to_i)
      @umschlag.end_datum = abschnitt_danach.start_datum
      @umschlag.ort = abschnitt_danach.start_ort
    end
  end

  # GET /umschlaege/1/edit
  def edit
  end

  # POST /umschlaege
  # POST /umschlaege.json
  def create
    @umschlag = Umschlag.new(umschlag_params)
    transport = params[:transport_id] ? Transport.find(params[:transport_id].to_i) : nil
    @umschlag.transport = transport
    @redirection = params[:transport_id] ? transport : @umschlag
    File.open("log/transport.log","w"){|f| f.puts "umschlag_ort #{params[:umschlag_ort]}"}

    # Wenn Ort mit gleichem Namen schon vorhanden, den benutzen
    ort = Ort.find_by(name: params[:ortname].to_s)
    if params[:umschlag_ort] && ort && params[:umschlag_ort].to_i == ort.id 
      eindeutig = true
      @umschlag.ort = ort
    else
      # TODO da ist etwas falsch?
      # Orte finden, zuordnen oder falls nötig, neu erstellen.
      eindeutig, ort_e = evtl_ortswahl_weiterleitung_und_anzeige(@umschlag, params[:ortname].to_s, params[:plz], params[:lat], params[:lon], "create")
    end
    
    
    if eindeutig
      if @umschlag.save
        redirect_to @redirection, notice: "Umschlag erfolgreich angelegt." 
      else  
        render :new 
      end
    else 
      if @umschlag.save
        if ort_e.nil?
          flash[:notice] = 'Kein passender Ort gefunden'
          # TODO: anderes Ortswahlfenster anlegen mit Ort neu suchen koennen
          redirect_to new_umschlag_path
        else
          redirect_to orte_ortswahl_path(umschlag: @umschlag.id, orte: ort_e)
        end
      else
        render :new 
      end
    end
    
  end

  # PATCH/PUT /umschlaege/1
  # PATCH/PUT /umschlaege/1.json
  def update
    # Orte finden, zuordnen oder falls nötig, neu erstellen.
    eindeutig, ort_e = update_ort(@umschlag, @umschlag.ort, params[:ortname].to_s, params[:plz], params[:lat], params[:lon], "update")
    
    @redirection = @umschlag.transport ? @umschlag.transport : @umschlag
    if eindeutig
      if @umschlag.update(umschlag_params)
          redirect_to @redirection, notice: 'Umschlag was successfully updated.' 
      else
        render :edit 
      end
    else 
      respond_to do |format|
        if @umschlag.update(umschlag_params)
            if ort_e.nil?
              flash[:notice] = 'Kein passender Ort gefunden'
              # TODO: anderes Ortswahlfenster anlegen mit Ort neu suchen koennen
              redirect_to edit_umschlag_path(@umschlag)
            else
              redirect_to orte_ortswahl_path(umschlag: @umschlag.id, orte: ort_e)
            end
        else
          format.html { render :edit }
          format.json { render json: @umschlag.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /umschlaege/1
  # DELETE /umschlaege/1.json
  def destroy
    transport = @umschlag.transport
    @umschlag.destroy
    respond_to do |format|
      format.html { redirect_to transport, notice: 'Umschlag geloescht.' }
      format.json { head :no_content }
    end
  end

  
  # Ort zum Umschlag speichern und Umschlag anzeigen.
  # Nötig nach Umschlag anlegen/updaten mit Ortsauswahl.
  #
  def save_ort 
    if params[:ort]
      @umschlag.ort = Ort.find(params[:ort].to_i)
      if @umschlag.save
        redirect_to @umschlag.transport, notice: 'Umschlag aktualisiert.' 
      else
        redirect_to edit_umschlag_path(@umschlag), "Umschlagsort nicht korrekt gespeichert."
      end
    else 
      redirect_to @umschlag, notice: "Kein Ort übermittelt." 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_umschlag
      @umschlag = Umschlag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def umschlag_params
      params.require(:umschlag).permit(:terminal, :transport, :transport_id,
                                 :start_datum, :end_datum, :firma_id)
    end

    def ort_params
      params.require(:umschlag).permit(:ort)
    end
end
