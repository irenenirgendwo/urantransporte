class BeobachtungenController < ApplicationController
  before_action :set_beobachtung, only: [:show, :edit, :update, :destroy]

  # GET /beobachtungen
  # GET /beobachtungen.json
  def index
    @beobachtungen = Beobachtung.paginate(page: params[:page], per_page: 20)
  end

  # GET /beobachtungen/1
  # GET /beobachtungen/1.json
  def show
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

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_beobachtung
      @beobachtung = Beobachtung.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beobachtung_params
      params.require(:beobachtung).permit(:ankunft_zeit, :abfahrt_zeit, :start_datum, :end_datum, :ort, :lat, :lon, :fahrtrichtung, :verkehrstraeger, :kennzeichen_radioaktiv, :kennzeichen_aetzend, :kennzeichen_spaltbar, :kennzeichen_umweltgefaehrend, :gefahr_nummer, :un_nummer, :firma_id, :firma_beschreibung, :lok_farbe, :container_beschreibung, :anzahl_container, :zug_beschreibung, :anzahl_lkw, :kennzeichen_lkw, :lkw_beschreibung, :schiff_name, :schiff_beschreibung, :polizei, :hubschrauber, :foto, :quelle, :email)
    end
end
