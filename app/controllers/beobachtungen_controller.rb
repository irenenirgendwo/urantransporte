class BeobachtungenController < ApplicationController
  before_action :set_beobachtung, only: [:show, :edit, :update, :destroy, :abschnitt_zuordnen]

  # GET /beobachtungen
  # GET /beobachtungen.json
  def index
    @beobachtungen = 
      case params[:zugeordnet]
      when "a" then
        Beobachtung.paginate(page: params[:page], per_page: 20)
      when "j" then
        Beobachtung.where.not(transportabschnitt_id: nil).paginate(page: params[:page], per_page: 20)
      else
        Beobachtung.where(transportabschnitt_id: nil).paginate(page: params[:page], per_page: 20)
      end 
  end

  # GET /beobachtungen/1
  # GET /beobachtungen/1.json
  def show
    @transportabschnitte = Transportabschnitt.get_abschnitte_from_time(@beobachtung.ankunft_zeit)
    @transporte = Transport.get_transporte_around(@beobachtung.ankunft_zeit,4)
  end

  # GET /beobachtungen/new
  def new
    @beobachtung = Beobachtung.new
  end

  # GET /beobachtungen/1/edit
  def edit
  end

  # POST /beobachtungen
  # POST /beobachtungen.json
  def create
    @beobachtung = Beobachtung.new(beobachtung_params)

    respond_to do |format|
      if @beobachtung.save
        format.html { redirect_to @beobachtung, notice: 'Beobachtung was successfully created.' }
        format.json { render :show, status: :created, location: @beobachtung }
      else
        format.html { render :new }
        format.json { render json: @beobachtung.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beobachtungen/1
  # PATCH/PUT /beobachtungen/1.json
  def update
    respond_to do |format|
      if @beobachtung.update(beobachtung_params)
        format.html { redirect_to @beobachtung, notice: 'Beobachtung was successfully updated.' }
        format.json { render :show, status: :ok, location: @beobachtung }
      else
        format.html { render :edit }
        format.json { render json: @beobachtung.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beobachtungen/1
  # DELETE /beobachtungen/1.json
  def destroy
    @beobachtung.destroy
    respond_to do |format|
      format.html { redirect_to beobachtungen_url, notice: 'Beobachtung was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def abschnitt_zuordnen
    if params[:abschnitt].to_i
      @beobachtung.transportabschnitt = Transportabschnitt.find(params[:abschnitt].to_i)
      if @beobachtung.save
        redirect_to @beobachtung, notice: "Transportabschnitt wurde erfolgreich zugeordnet." and return
      end
   end
   redirect_to @beobachtung, notice: "Fehler: Transportabschnitt wurde nicht zugeordnet."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_beobachtung
      @beobachtung = Beobachtung.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beobachtung_params
      params.require(:beobachtung).permit(:ankunft_zeit, :abfahrt_zeit, :start_datum, :end_datum, :ort, :lat, :lon, 
                  :fahrtrichtung, :verkehrstraeger, 
                  :kennzeichen_radioaktiv, :kennzeichen_aetzend, :kennzeichen_spaltbar, :kennzeichen_umweltgefaehrend, 
                  :gefahr_nummer, :un_nummer, 
                  :firma_id, :firma_beschreibung, :lok_farbe, :container_beschreibung, :anzahl_container, 
                  :zug_beschreibung, :anzahl_lkw, :kennzeichen_lkw, :lkw_beschreibung, 
                  :schiff_name, :schiff_beschreibung, :polizei, :hubschrauber, :foto, :quelle, :email,
                  :transportabschnitt_id)
    end
end
