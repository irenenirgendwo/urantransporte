# encoding: utf-8
class TransportabschnitteController < ApplicationController
  before_action :set_transportabschnitt, only: [:show, :edit, :update, :destroy]
  before_action :editor_user, only: [:new, :edit, :create, :update, :destroy]
  
  # GET /transportabschnitte
  # GET /transportabschnitte.json
  def index
    @transport = Transport.find(params["transport_id"].to_i) if params["transport_id"]
    @transportabschnitte = @transport.nil? ? Transportabschnitt.all : @transport.transportabschnitte
  end

  # GET /transportabschnitte/1
  # GET /transportabschnitte/1.json
  def show
    if params[:durch_ort]
      neuort = Ort.find_or_create_ort(params[:durch_ort])
      @transportabschnitt.orte << neuort
    end
  end

  # GET /transportabschnitte/new
  def new
    @transport = Transport.find(params[:transport_id].to_i) if params[:transport_id]
    if params[:beobachtung_id]
      @beobachtung_id = params[:beobachtung_id].to_i if params[:beobachtung_id]
      @beobachtung = Beobachtung.find(@beobachtung_id)
    end
    @transportabschnitt = Transportabschnitt.new
    # Wenn Abschnitt oder Umschlag davor oder danach schon existiert, 
    # dann nimm daher die entsprechenden Anfangs- und Enddaten
    if params[:abschnitt_davor]
      abschnitt_davor = Transportabschnitt.find(params[:abschnitt_davor].to_i)
      @transportabschnitt.start_datum = abschnitt_davor.end_datum
      @transportabschnitt.start_ort = abschnitt_davor.end_ort
    end
    if params[:abschnitt_danach]
      abschnitt_danach = Transportabschnitt.find(params[:abschnitt_danach].to_i)
      @transportabschnitt.end_datum = abschnitt_danach.start_datum
      @transportabschnitt.end_ort = abschnitt_danach.start_ort
    end
    if params[:umschlag_davor]
      umschlag = Umschlag.find(params[:umschlag_davor].to_i)
      @transportabschnitt.start_datum = umschlag_davor.end_datum
      @transportabschnitt.start_ort = umschlag.ort
    end
    if params[:umschlag_danach]
      umschlag = Umschlag.find(params[:umschlag_danach].to_i)
      @transportabschnitt.end_datum = umschlag.start_datum
      @transportabschnitt.end_ort = umschlag.ort
    end 
  end

  # GET /transportabschnitte/1/edit
  def edit
  end

  # POST /transportabschnitte
  # POST /transportabschnitte.json
  def create
    @transportabschnitt = Transportabschnitt.new(transportabschnitt_params)
    redirection_path = @transportabschnitt
    if params[:transport_id]
      transport = Transport.find(params[:transport_id].to_i)
      @transportabschnitt.transport = transport
      redirection_path = transport if transport 
    end
    if params[:beobachtung_id]
      @beobachtung = Beobachtung.find(params[:beobachtung_id].to_i)
      @beobachtung.transportabschnitt = @transportabschnitt if @beobachtung 
      redirection_path = @beobachtung if @beobachtung
    end

  # Orte finden, zuordnen oder falls nötig, neu erstellen.
    # TODO: Auswahlmöglichkeit bei Mehrfachtreffern. Aktuell wird einfach der letzte genommen.
    # ausgelagert in Funktion conerns/OrteVerwalten/find_or_create_ort.
    if params[:transportabschnitt][:start_ort]
      @transportabschnitt.start_ort = Ort.find_or_create_ort(params[:transportabschnitt][:start_ort])
    end
    if params[:transportabschnitt][:end_ort]
      @transportabschnitt.end_ort = Ort.find_or_create_ort(params[:transportabschnitt][:end_ort])
    end

    respond_to do |format|
      if @transportabschnitt.save
        @beobachtung.save if @beobachtung
        format.html { redirect_to redirection_path, notice: 'Transportabschnitt was successfully created.' }
        format.json { render :show, status: :created, location: @transportabschnitt }
      else
        format.html { render :new }
        format.json { render json: @transportabschnitt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transportabschnitte/1
  # PATCH/PUT /transportabschnitte/1.json
  def update
    if params[:transportabschnitt][:start_ort] != @transportabschnitt.start_ort
      @transportabschnitt.start_ort = Ort.find_or_create_ort(params[:transportabschnitt][:start_ort])
    end
    if params[:transportabschnitt][:end_ort] != @transportabschnitt.end_ort
       @transportabschnitt.end_ort = Ort.find_or_create_ort(params[:transportabschnitt][:end_ort])
    end

    @transport = @transportabschnitt.transport 
    redirection_path = @transport.nil? ? @transportabschnitt : @transport
    respond_to do |format|
      if @transportabschnitt.update(transportabschnitt_params)
        format.html { redirect_to redirection_path, notice: 'Transportabschnitt was successfully updated.' }
        format.json { render :show, status: :ok, location: @transport }
      else
        format.html { render :edit }
        format.json { render json: @transportabschnitt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transportabschnitte/1
  # DELETE /transportabschnitte/1.json
  def destroy
    transport = @transportabschnitt.transport
    @transportabschnitt.destroy
    respond_to do |format|
      format.html { redirect_to transport, notice: 'Transportabschnitt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transportabschnitt
      @transportabschnitt = Transportabschnitt.find(params[:id])
      @transport = @transportabschnitt.transport
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transportabschnitt_params
      params.require(:transportabschnitt).permit(:transport, :transport_id,
                                 :start_datum, :end_datum, :firma_id, :verkehrstraeger)
    end
    def orte_params
      params.require(:transportabschnitt).permit(:start_ort, :end_ort, :durch_ort)
    end
end
