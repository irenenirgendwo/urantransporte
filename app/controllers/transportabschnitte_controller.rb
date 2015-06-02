# encoding: utf-8
class TransportabschnitteController < ApplicationController
  before_action :set_transportabschnitt, only: [:edit, :update, :destroy]
  before_action :init_ort_and_firma, only: [:new, :edit]
  before_action :editor_user, only: [:new, :edit, :create, :update, :destroy]
  

  # GET /transportabschnitte/new
  # Es ist sicher zu stellen (vor Aufruf), dass ein Transport mit in Parametern uebergebenen transport_id existiert.
  #
  def new
    @transport = Transport.find(params[:transport_id].to_i) if params[:transport_id]
    throw ArgumentError.new("Must give an transport id which exists}") unless @transport
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
      @transportabschnitt.start_datum = umschlag.end_datum
      @transportabschnitt.start_ort = umschlag.ort
    end
    if params[:umschlag_danach]
      umschlag = Umschlag.find(params[:umschlag_danach].to_i)
      @transportabschnitt.end_datum = umschlag.start_datum
      @transportabschnitt.end_ort = umschlag.ort
    end 
     @redirect_params = new_transportabschnitt_path(transport_id: @transport.id) 
  end

  # GET /transportabschnitte/1/edit
  def edit
    @redirect_params = edit_transportabschnitt_path(transport_id: @transport.id) 
  end

  # POST /transportabschnitte
  # POST /transportabschnitte.json
  def create
    File.open("log/abschnitt.log","w"){|f| f.puts "starte create transportabschnitt"}
    File.open("log/abschnitt.log","a"){|f| f.puts "params #{params}"}
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
    if params[:start_ort_ident]
      @transportabschnitt.start_ort = Ort.find(params[:start_ort_ident].to_i)
    end
    if params[:end_ort_ident]
      @transportabschnitt.end_ort = Ort.find(params[:end_ort_ident].to_i)
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
    File.open("log/abschnitt.log","w"){|f| f.puts "starte create transportabschnitt"}
    File.open("log/abschnitt.log","a"){|f| f.puts "params #{params}"}
    File.open("log/abschnitt.log","a"){|f| f.puts "alter ort #{params[:start_ort_ident] != ""}"}
    # Wenn Ort sich geandert hat
    unless params[:start_ort_ident] == ""
      if @transportabschnitt.start_ort.nil? || (params[:start_ort_ident].to_i != @transportabschnitt.start_ort.id ) 
        @transportabschnitt.start_ort = Ort.find(params[:start_ort_ident].to_i)
      end
    end
    unless params[:end_ort_ident] == ""
      if @transportabschnitt.end_ort.nil? || params[:end_ort_ident] != @transportabschnitt.end_ort.id
         @transportabschnitt.end_ort = Ort.find(params[:end_ort_ident].to_i)
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
  
  # Grundgerüst der Ortsauswahl bei Mehrfachtreffern - vielleicht funktionsfähig
  # Testweise eingebunden nur beim Erstellen neuer Anlagen und Update.
  #
  # Idee: Alle passenden Orte werden in einem Auswahlfenster angezeigt.
  # Die passenden Orte werden mittels ort_waehlen (orte_mit_namen bzw. lege_passende_orte_an)
  # im Ort-Modell gesucht bzw. angelegt.
  # Dann werden die angelegten Orte zum Aufruf einer ortsauswahl-Funktion aus dem OrteController verwendnet.
  #
  # TODO: Wenn kein Ort gefunden wurde, anderes Ortswahlfenster anlegen mit Ort neu suchen koennen,
  # über Orte-Controller, vermutlich ähnlich.
  #
  def evtl_ortswahl_weiterleitung_und_anzeige(ortsname, aktion, ortstyp)
    eindeutig = true
    unless ortsname=="" || ortsname.nil? || (aktion=="update" && ortsname == @transportabschnitt.ort.to_s)
      eindeutig, ort_e = Ort.ort_waehlen(ortsname)
      case ortstyp
        when "start" then
          @transportabschnitt.start_ort = eindeutig ? ort_e : nil
        when "ende" then
          @transportabschnitt.end_ort = eindeutig ? ort_e : nil
        when "durchfahrt" then
          @transportabschnitte.orte << ort_e if eindeutig
      end
    end
    return eindeutig, ort_e
  end
  
  # Ort zum Umschlag speichern und Umschlag anzeigen.
  # Nötig nach Umschlag anlegen/updaten mit Ortsauswahl.
  #
  def save_ort 
    if params[:ort] && params[:ortstyp]
      case ortstyp
        when "start" then
          @transportabschnitt.start_ort = Ort.find(params[:ort].to_i)
        when "ende" then
          @transportabschnitt.end_ort = Ort.find(params[:ort].to_i)
        when "durchfahrt" then
          @transportabschnitte.orte << Ort.find(params[:ort].to_i)
      end
      if @transportabschnitt.save
        redirect_to @transportabschnitt, notice: 'Umschlag aktualisiert.' 
      else
        redirect_to edit_transportabschnitt_path(@transportabschnitt), "Umschlagsort nicht korrekt gespeichert."
      end
    else 
      redirect_to @transportabschnitt, notice: "Kein Ort übermittelt." 
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
    
    def init_ort_and_firma
      @firma = Firma.new
      @ort = Ort.new
      @ort.lat = "52.2152"
      @ort.lon = "7.0793"
    end
end
