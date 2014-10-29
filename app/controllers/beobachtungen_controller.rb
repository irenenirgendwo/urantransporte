class BeobachtungenController < ApplicationController
  before_action :set_beobachtung, only: [:show, :edit, :update, :destroy, :load_foto, :update_foto, :abschnitt_zuordnen, :set_toleranz_tage]
  before_action :editor_user, only: [:edit, :update, :destroy]
  
  # Zeigt alle noch nicht zu Transportabschnitten zugeordneten Beobachtungen an. (zugeordnet="n"
  # Es ist auch möglich, alle Beobachtungen anzeigen zu lassen (zugeordnet="a").
  # GET /beobachtungen
  #
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

  # Zeigt eine Beobachtung mit allen Daten und zugeordnetem Transportabschnitt an.
  # Ist kein Transportabschnitt zugeordnet, kann einer ausgewaehlt werden.
  # GET /beobachtungen/1
  #
  def show
    @toleranz_tage = params[:tage] ? params[:tage].to_i : 4
    unless @beobachtung.transportabschnitt
      @transportabschnitte = Transportabschnitt.get_abschnitte_from_time(@beobachtung.ankunft_zeit)
      @transporte = Transport.get_transporte_around(@beobachtung.ankunft_zeit,4)
    end
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
        format.html { redirect_to load_foto_beobachtung_path(@beobachtung), notice: 'Beobachtung wurde angelegt.' }
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
        format.html { redirect_to load_foto_beobachtung_path(@beobachtung), notice: 'Beobachtung wurde aktualisiert.' }
        format.json { render :show, status: :ok, location: @beobachtung }
      else
        format.html { render :edit }
        format.json { render json: @beobachtung.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beobachtungen/1
  # DELETE /beobachtungen/1.json
  #
  def destroy
    @beobachtung.destroy
    respond_to do |format|
      format.html { redirect_to beobachtungen_url, notice: 'Beobachtung was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # Ordnet einen Transportabschnitt dieser Beobachtung zu.
  # Danach wird wieder die Beobachtung angezeigt (show-Methode).
  # POST
  #
  def abschnitt_zuordnen
    if params[:abschnitt].to_i
      @beobachtung.transportabschnitt = Transportabschnitt.find(params[:abschnitt].to_i)
      if @beobachtung.save
        redirect_to @beobachtung, notice: "Transportabschnitt wurde erfolgreich zugeordnet." and return
      end
   end
   redirect_to @beobachtung, notice: "Fehler: Transportabschnitt wurde nicht zugeordnet."
  end
  
  # laedt das Partial zu der Transporabschnittszuordnung neu, mit einer neuen Toleranzschwelle 
  # fuer das Transportdatum der angezeigten passenden Transporte.
  # Wird mittels Javascript beim Setzen des neuen Schwellenwertes aufgerufen.
  # GET beobachtung/set_toleranz_tage/1/5
  #
  def set_toleranz_tage
    @transportabschnitte = Transportabschnitt.get_abschnitte_from_time(@beobachtung.ankunft_zeit)
    @toleranz_tage = params[:tage].to_i
    @transporte = Transport.get_transporte_around(@beobachtung.ankunft_zeit,@toleranz_tage)
    render :partial => "show_transportabschnitt", :locals => {:beobachtung => @beobachtung}
  end
  
  # Zum Danke sagen und Foto hochladen
  def load_foto
    
  end 
  
  def update_foto
    uploaded_io = params[:upload_foto]
    file_path = Rails.root.join('public', 'fotos', uploaded_io.original_filename)
    File.open(file_path, 'wb') do |file|
      file.write(uploaded_io.read)
    end
    respond_to do |format|
      if @beobachtung.update(:foto_path => uploaded_io.original_filename)
        format.html { redirect_to @beobachtung, notice: 'Foto zur Beobachtung hochgeladen.' }
        format.json { render :show, status: :created, location: @beobachtung }
      else
        format.html { render :new }
        format.json { render json: @beobachtung.errors, status: :unprocessable_entity }
      end
    end
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
