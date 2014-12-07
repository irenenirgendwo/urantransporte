# encoding: utf-8
class AnlagenController < ApplicationController
  before_action :set_anlage, only: [:show, :edit, :update, :destroy, :save_ort]
  before_action :editor_user, only: [:new, :edit, :create, :update, :destroy]
  
  # GET /anlagen
  # GET /anlagen.json
  def index
    @anlagen = Anlage.all
    if params[:search]
      @anlagen = @anlagen.where("name LIKE ?", "%#{params[:search]}%")
    end
    if params[:kategorie]
      @anlagen = @anlagen.where(:anlagen_kategorie_id => params[:kategorie])
    end
    @kategorien = AnlagenKategorie.get_kategorien_for_selection_field;
    @anlagen = @anlagen.order(:name).paginate(page: params[:page], per_page: 12)
    
    respond_to do |format|
      format.html  # index.html.erb
      format.json  { render :json => @anlagen }
    end
  end

  # GET /anlagen/1
  # GET /anlagen/1.json
  def show
    @synonyme = @anlage.anlagen_synonyms.pluck(:synonym)
    @transporte_ab = Transport.where("start_anlage_id = ?", @anlage).paginate(page: params[:page_ab], per_page: 20)
    @transporte_an = Transport.where("ziel_anlage_id = ?", @anlage).paginate(page: params[:page_an], per_page: 20)
  end

  # GET /anlagen/new
  def new
    @anlage = Anlage.new
    @synonym = params[:synonym]
    @redirect_params = params[:redirect_params]
  end

  # GET /anlagen/1/edit
  def edit
    @redirect_params = @anlage
    @bisherige_synonyme = @anlage.anlagen_synonyms.pluck(:synonym)
    @synonym = AnlagenSynonym.new(:anlage_id => @anlage.id)
  end
  

  # POST /anlagen
  # POST /anlagen.json
  def create
    @anlage = Anlage.new(anlage_params)
    
    File.open("log/anlagen.log","w"){|f| f.puts @anlage.attributes}
    session[:redirect_params] = nil
    
    if params[:synonym]
      synonym = AnlagenSynonym.find_by(synonym: params[:synonym])
      if synonym 
        synonym.anlage = @anlage
        synonym.save 
      end
    end
    
    @redirect_params =  params[:redirect_params].nil? ? @anlage : params[:redirect_params] 
    
    evtl_ortswahl_weiterleitung_und_anzeige(params[:anlage][:ort].to_s, params[:lat], params[:lon], "create", @redirect_params)
    
  end

  # PATCH/PUT /anlagen/1
  # PATCH/PUT /anlagen/1.json
  def update
  # Orte finden, zuordnen oder falls nötig, neu erstellen.
    # TODO: Auswahlmöglichkeit bei Mehrfachtreffern. Aktuell wird einfach der letzte genommen.
    # Evtl. in extra Funktion auslagern, war mir für den Moment zu aufwendig.
    evtl_ortswahl_weiterleitung_und_anzeige(params[:anlage][:ort].to_s, params[:lat], params[:lon], "update", @anlage)

  end

# 

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
  def evtl_ortswahl_weiterleitung_und_anzeige(ortsname, lat, lon, aktion, redirection = @anlage)
    # Log-File für Feller finden
    File.open("log/ort.log","w"){|f| f.puts "ortsname im anlagenKontroller #{ortsname} #{ortsname.nil?} #{ortsname==""}" }
    File.open("log/ort.log","a"){|f| f.puts "anlage.ort #{@anlage.ort.to_s}" }
    eindeutig = true
    unless ortsname=="" || ortsname.nil? || (aktion=="update" && ortsname == @anlage.ort.to_s)
      eindeutig, ort_e = Ort.ort_waehlen(ortsname)
      File.open("log/anlagen.log","a"){|f| f.puts "ort_e #{ort_e}" }
      if eindeutig
        @anlage.ort = ort_e
      else 
        # wird nach dem Anlagen speichern gesetzt.
        @anlage.ort = nil 
      end
    end
    # Wenn Koordinaten eingegeben sind, diese beim Ort ersetzen bzw. 
    # Ort danach finden falls Ortsname uneindeutig.
    if lat && lon && lat!="" && lon!=""
      File.open("log/ort.log","a"){|f| f.puts "lat und lon #{lat}, #{lon}" }
      File.open("log/ort.log","a"){|f| f.puts "@anlage.ort #{@anlage.ort}" }
      if @anlage.ort.nil?
        @anlage.ort = Ort.create_by_koordinates(lat,lon) 
        eindeutig = true
      else
        File.open("log/ort.log","a"){|f| f.puts "Ort gefunden #{@anlage.ort.attributes}" }
        # Ortskoordinaten umsetzen oder besser neuen Ort erzeugen?
        @anlage.ort.lat = lat 
        @anlage.ort.lon = lon
        @anlage.ort.save
      end
    end
    
    text = (aktion == "create") ? 'Anlage neu angelegt.' : "Anlage aktualisiert."
    # Wenn der Ort nicht eindeutig war, weiter leiten.
    if eindeutig
      respond_to do |format|
        if @anlage.save
            flash[:notice] = text
            format.html { redirect_to redirection, notice: text}
            format.json { render :show, status: :created, location: @anlage }
        else
          format.html do
            if aktion == "create"
              render :new 
            else 
              render :edit 
            end
          end
          format.json { render json: @anlage.errors, status: :unprocessable_entity }
        end
      end
    else 
      @anlage.save
      if ort_e.nil?
        flash[:notice] = 'Kein passender Ort gefunden'
        # TODO: anderes Ortswahlfenster anlegen mit Ort neu suchen koennen
        redirect_to new_anlage_path
      else
        redirect_to orte_ortswahl_path(anlage: @anlage.id, orte: ort_e)
      end
    end
  end


  # Ort zu der Anlage speichern und Anlage anzeigen.
  # Nötig nach Anlage anlegen/updaten mit Ortsauswahl.
  #
  def save_ort 
    if params[:ort]
      @anlage.ort = Ort.find(params[:ort].to_i)
      if @anlage.save
        redirect_to @anlage, notice: 'Anlage was successfully updated.' 
      else
        redirect_to edit_anlage_path(@anlage), "Anlagenort nicht korrekt gespeichert."
      end
    else 
      redirect_to @anlage, notice: "Kein Ort übermittelt." 
    end
  end


  # DELETE /anlagen/1
  # DELETE /anlagen/1.json
  def destroy
    begin
	  success = @anlage.destroy
	rescue
	  success = false
	end  
    respond_to do |format|
      if success 
        format.html { redirect_to anlagen_url, notice: 'Anlage was successfully destroyed.' }
        format.json { head :no_content }
      else 
        format.html { redirect_to @anlage, notice: 'Die Anlage ist noch Start- oder Zielanlage eines Transports. Deshalb ist das Löschen der Anlage nicht möglich.' }
        format.json { head :no_content }
      end
    end
  end

  # Ein Synonym hinzufuegen
  # POST
  def add_synonym
    @synonym = AnlagenSynonym.new(synonym_params)
    @anlage = Anlage.find(params[:anlage_id])
    respond_to do |format|
      if @synonym.save
        flash[:notice] = "Anlage neu angelegt"
        format.html { redirect_to edit_anlage_path(@anlage), notice: 'Synonym was successfully created.' }
        format.json { render :show, status: :created, location: @anlage }
      else
        format.html { render :new }
        format.json { render json: @anlage.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_synonym
    @synonym = AnlagenSynonym.find_by synonym: params[:synonym_text]
    @anlage = Anlage.find(params[:anlage_id])
    @synonym.destroy
    respond_to do |format|
      format.html { redirect_to edit_anlage_path(@anlage), notice: 'Synonym was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_anlage
      @anlage = Anlage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def anlage_params
      params.require(:anlage).permit(:name, :adresse, :plz, :lat, :lon, :beschreibung, 
                                  :bild_url, :bild_urheber, :anlagen_kategorie, :anlagen_kategorie_id, :ort_id)
    end

   # Never trust parameters from the scary internet, only allow the white list through.
    def synonym_params
      params.permit(:anlage_id, :synonym)
    end
end
