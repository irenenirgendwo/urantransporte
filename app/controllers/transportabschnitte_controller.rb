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
  end

  # GET /transportabschnitte/new
  def new
    @transport = Transport.find(params[:transport_id].to_i) if params[:transport_id]
    if params[:beobachtung_id]
      @beobachtung_id = params[:beobachtung_id].to_i if params[:beobachtung_id]
      @beobachtung = Beobachtung.find(@beobachtung_id)
    end
    @transportabschnitt = Transportabschnitt.new
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
    # Evtl. in extra Funktion auslagern, war mir für den Moment zu aufwendig.
    if params[:transportabschnitt][:start_ort]
      @transportabschnitt.start_ort = Ort.find_by(:name => params[:transportabschnitt][:start_ort])
      if @transportabschnitt.start_ort == nil
        a = Geokit::Geocoders::GoogleGeocoder.geocode params[:transportabschnitt][:start_ort].to_s
        a = Geokit::Geocoders::GoogleGeocoder.geocode a.ll
        @transportabschnitt.start_ort = Ort.create(:name => params[:transportabschnitt][:start_ort], :lat => a.lat, :lon => a.lng, :plz => a.zip)
      end
    end
    if params[:transportabschnitt][:end_ort]
      @transportabschnitt.end_ort = Ort.find_by(:name => params[:transportabschnitt][:end_ort])
      if @transportabschnitt.end_ort == nil
        a = Geokit::Geocoders::GoogleGeocoder.geocode params[:transportabschnitt][:end_ort].to_s
        a = Geokit::Geocoders::GoogleGeocoder.geocode a.ll
        @transportabschnitt.end_ort = Ort.create(:name => params[:transportabschnitt][:end_ort], :lat => a.lat, :lon => a.lng, :plz => a.zip)
      end
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
      @transportabschnitt.start_ort = Ort.find_by(:name => params[:transportabschnitt][:start_ort])
      if @transportabschnitt.start_ort == nil
        a = Geokit::Geocoders::GoogleGeocoder.geocode params[:transportabschnitt][:start_ort].to_s
        a = Geokit::Geocoders::GoogleGeocoder.geocode a.ll
        @transportabschnitt.start_ort = Ort.create(:name => params[:transportabschnitt][:start_ort], :lat => a.lat, :lon => a.lng, :plz => a.zip)
      end
    end
    if params[:transportabschnitt][:end_ort] != @transportabschnitt.end_ort
      @transportabschnitt.end_ort = Ort.find_by(:name => params[:transportabschnitt][:end_ort])
      if @transportabschnitt.end_ort == nil
        a = Geokit::Geocoders::GoogleGeocoder.geocode params[:transportabschnitt][:end_ort].to_s
        a = Geokit::Geocoders::GoogleGeocoder.geocode a.ll
        @transportabschnitt.end_ort = Ort.create(:name => params[:transportabschnitt][:end_ort], :lat => a.lat, :lon => a.lng, :plz => a.zip)
      end
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
      params.require(:transportabschnitt).permit(:start_ort, :end_ort)
    end
end
