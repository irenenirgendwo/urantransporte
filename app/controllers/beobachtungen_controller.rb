# encoding: utf-8
class BeobachtungenController < ApplicationController
  before_action :set_beobachtung, only: [:show, :edit, :update, :destroy, :load_foto, :update_foto, :abschnitt_zuordnen, :set_toleranz_tage, :save_ort]
  before_action :editor_user, only: [:edit, :update, :destroy, :index, :save_ort]
  before_action :set_schiffe, only: [:edit, :new, :update, :create, :save_ort]
  
  include OrteAuswahl
  
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
    @ort = @beobachtung.ort
  end

  # POST /beobachtungen
  # POST /beobachtungen.json
  def create
    @beobachtung = Beobachtung.new(beobachtung_params)

    unless params[:beobachtung][:quelle]
      quelle = 
        if logged_in? 
          current_user.name
        else
          "Formular"
        end
      @beobachtung.quelle = quelle
    end 

    # Gilt das nicht generell für Zeitfelder, vielleicht auslagern in ein Modul
    # und eine Methode korrigiere_datum(datum)?
    if @beobachtung.ankunft_zeit
      if @beobachtung.ankunft_zeit.year < 90
        @beobachtung.ankunft_zeit = @beobachtung.ankunft_zeit.advance(:days => 365.2425*2000)
      elsif @beobachtung.ankunft_zeit.year < 100
        @beobachtung.ankunft_zeit = @beobachtung.ankunft_zeit.advance(:days => 365.2425*1900)
      end
    end
    
    if @beobachtung.abfahrt_zeit != nil
      if @beobachtung.abfahrt_zeit.year < 90
        @beobachtung.abfahrt_zeit = @beobachtung.abfahrt_zeit.advance(:days => 365.2425*2000)
      elsif @beobachtung.abfahrt_zeit.year < 100
        @beobachtung.abfahrt_zeit = @beobachtung.abfahrt_zeit.advance(:days => 365.2425*1900)
      end
    end
    
    # Wenn eingeloggt, evtl. Ortsauswahl treffen
    if logged_in? 
      eindeutig, ort_e = evtl_ortswahl_weiterleitung_und_anzeige(@beobachtung, params[:ortname].to_s, params[:plz], params[:lat], params[:lon], "create")
      if eindeutig
        if @beobachtung.save
          respond_to do |format|
              format.html do
                flash[:success] = 'Beobachtung wurde angelegt.'
                if @beobachtung.foto 
                  redirect_to load_foto_beobachtung_path(@beobachtung)
                else logged_in?
                  redirect_to @beobachtung
                end 
              end
              format.json { render :show, status: :created, location: @anlage }
          end
        else 
          respond_to do |format|
            format.html { render :new }
            format.json { render json: @anlage.errors, status: :unprocessable_entity }
          end
        end
      else
        @beobachtung.ort = Ort.first
        @beobachtung.save
        if ort_e.nil?
          flash[:danger] = 'Kein passender Ort gefunden'
          # TODO: anderes Ortswahlfenster anlegen mit Ort neu suchen koennen
          redirect_to new_ort_path(beobachtung: @beobachtung.id)
        else
          redirect_to orte_ortswahl_path(beobachtung: @beobachtung.id, orte: ort_e)
        end
      end
    # Wenn nicht eingeloggt, Foto oder Danke.
    else 
      if params[:ortname]=="" && params[:lat]==""
        flash[:danger] = 'Bitte einen Ort eingeben über die Karte oder das Namensfeld.'
        respond_to do |format|
          format.html { render :new }
          format.json { render json: @anlage.errors, status: :unprocessable_entity }
        end
      else
        # Ort erstellen
        @ort = Ort.create_by_koordinates_and_name(params[:ortname], params[:lat], params[:lon])
        @beobachtung.ort = @ort
        if @beobachtung.save 
          respond_to do |format|
            format.html do
                flash[:success] =  'Beobachtung wurde angelegt.'
                if @beobachtung.foto 
                  redirect_to load_foto_beobachtung_path(@beobachtung)
                else
                  redirect_to danke_beobachtung_path(@beobachtung)
                end 
            end       
            format.json { render :show, status: :created, location: @beobachtung }
          end
        else 
          respond_to do |format|
            format.html { render :new }
            format.json { render json: @anlage.errors, status: :unprocessable_entity }
          end
        end
      end
    end
      
    
    
  end

  # PATCH/PUT /beobachtungen/1
  # PATCH/PUT /beobachtungen/1.json
  def update
    @beobachtung.ort = Ort.create_by_koordinates_and_name(params[:ort], params[:lat], params[:lon])
    respond_to do |format|
      if @beobachtung.save && @beobachtung.update(beobachtung_params)
        format.html { redirect_to beobachtung_path, notice: 'Beobachtung wurde aktualisiert.' }
       # format.html { redirect_to load_foto_beobachtung_path(@beobachtung), notice: 'Beobachtung wurde aktualisiert.' }
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
      flash[:success] = "Beobachtung gelöscht."
      format.html { redirect_to beobachtungen_url }
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
        flash[:success] = "Transportabschnitt wurde erfolgreich zugeordnet."
        redirect_to @beobachtung and return
      end
    end
    flash[:danger] = "Fehler: Transportabschnitt wurde nicht zugeordnet."
    redirect_to @beobachtung
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
    filename = uploaded_io.original_filename
    if uploaded_io.nil?
      flash[:danger] = "Keine Datei ausgewählt."
      respond_to do |format|
         format.html { render :load_foto }
      end 
    else
      file_path = Rails.root.join('public', 'fotos', filename)
      File.open(file_path, 'wb') do |file|
        file.write(uploaded_io.read)
      end
      respond_to do |format|
        #puts "file geladen #{filename} #{params[:foto_recht]} #{@beobachtung.id}"
        if @beobachtung.update(:foto_path => filename, :foto_recht => params[:foto_recht])
          flash[:success] = 'Foto zur Beobachtung hochgeladen. Danke.'
          if logged_in?
            format.html { redirect_to @beobachtung }
            format.json { render :show, status: :updated, location: @beobachtung }
          else 
            format.html { redirect_to danke_beobachtung_path(@beobachtung) }
          end
        else
          flash[:danger] = "Foto hochladen nicht erfolgreich. Vielleicht umbenennen?"
          #puts @beobachtung.attributes
          format.html { render :load_foto }
          format.json { render json: @beobachtung.errors, status: :unprocessable_entity }
        end
      end
    end
  end 
  
  # Ort zu der Anlage speichern und Anlage anzeigen.
  # Nötig nach Anlage anlegen/updaten mit Ortsauswahl.
  #
  def save_ort 
    if params[:ort]
      @beobachtung.ort = Ort.find(params[:ort].to_i)
      if @beobachtung.save
        flash[:success] = 'Beobachtung bearbeitet.' 
        redirect_to @beobachtung
      else
        flash[:danger] = "Ort nicht korrekt gespeichert."
        redirect_to edit_anlage_path(@beobachtung)
      end
    else 
      flash[:info] = "Kein Ort übermittelt." 
      redirect_to @beobachtung
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_beobachtung
      @beobachtung = Beobachtung.find(params[:id].to_i)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beobachtung_params
      params.require(:beobachtung).permit(:ankunft_zeit, :abfahrt_zeit, :start_datum, :end_datum, :ort_id,
                  :fahrtrichtung, :verkehrstraeger, 
                  :kennzeichen_radioaktiv, :kennzeichen_aetzend, :kennzeichen_spaltbar, :kennzeichen_umweltgefaehrdend, 
                  :gefahr_nummer, :un_nummer, 
                  :firma_id, :firma_beschreibung, :lok_beschreibung, :container_beschreibung, :anzahl_container, 
                  :zug_beschreibung, :anzahl_lkw, :kennzeichen_lkw, :lkw_beschreibung, 
                  :schiff_name, :schiff_beschreibung, :polizei, :hubschrauber, :begleitung_beschreibung, :foto, :quelle, :email,
                  :transportabschnitt_id, :schiff_id)
    end
    
    
    def set_schiffe 
      @schiffe = []
      Schiff.all.each do |schiff|
        @schiffe << [schiff.name, schiff.id]
      end
      @schiff_unbekannt = Schiff.find_by_name("Unbekannt").id
    end
    

end
