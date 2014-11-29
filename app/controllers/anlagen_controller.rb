# encoding: utf-8
class AnlagenController < ApplicationController
  before_action :set_anlage, only: [:show, :edit, :update, :destroy]
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
    session[:redirect_params] = params[:redirect_params]
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
    @redirect_params = params[:redirect_params] ? params[:redirect_params] : (session[:redirect_params]  ? session[:redirect_params] : @anlage)
    
    File.open("log/anlagen.log","w"){|f| f.puts @redirect_params }
    File.open("log/anlagen.log","a"){|f| f.puts "flash #{flash[:redirect_params]}" }
    session[:redirect_params] = nil
    
  # Orte finden, zuordnen oder falls nötig, neu erstellen.
    # TODO: Auswahlmöglichkeit bei Mehrfachtreffern. Aktuell wird einfach der letzte genommen.
    # Evtl. in extra Funktion auslagern, war mir für den Moment zu aufwendig.
    if params[:anlage][:ort]
      @anlage.ort = Ort.find_by(:name => params[:anlage][:ort])
      if @anlage.ort == nil
        a = Geokit::Geocoders::GoogleGeocoder.geocode params[:anlage][:ort].to_s
        a = Geokit::Geocoders::GoogleGeocoder.geocode a.ll
        @anlage.ort = Ort.create(:name => params[:anlage][:ort], :lat => a.lat, :lon => a.lng, :plz => a.zip)
      end
    end

    if params[:synonym]
      synonym = AnlagenSynonym.find_by(synonym: params[:synonym])
      if synonym 
        synonym.anlage = @anlage
        synonym.save 
      end
    end

    respond_to do |format|
      if @anlage.save
        flash[:notice] = "Anlage neu angelegt"
        format.html { redirect_to @redirect_params, notice: 'Anlage was successfully created.' }
        format.json { render :show, status: :created, location: @anlage }
      else
        format.html { render :new }
        format.json { render json: @anlage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /anlagen/1
  # PATCH/PUT /anlagen/1.json
  def update
  # Orte finden, zuordnen oder falls nötig, neu erstellen.
    # TODO: Auswahlmöglichkeit bei Mehrfachtreffern. Aktuell wird einfach der letzte genommen.
    # Evtl. in extra Funktion auslagern, war mir für den Moment zu aufwendig.
    if params[:anlage][:ort] != @anlage.ort.to_s
      @anlage.ort = Ort.find_by(:name => params[:anlage][:ort])
      if @anlage.ort == nil
        a = Geokit::Geocoders::GoogleGeocoder.geocode params[:anlage][:ort].to_s
        a = Geokit::Geocoders::GoogleGeocoder.geocode a.ll
        @anlage.ort = Ort.create(:name => params[:anlage][:ort], :lat => a.lat, :lon => a.lng, :plz => a.zip)
      end
    end

    respond_to do |format|
      if @anlage.update(anlage_params)
        format.html { redirect_to @anlage, notice: 'Anlage was successfully updated.' }
        format.json { render :show, status: :ok, location: @anlage }
      else
        format.html { render :edit }
        format.json { render json: @anlage.errors, status: :unprocessable_entity }
      end
    end
  end

# Grundgerüst der Ortsauswahl bei Mehrfachtreffern - vermutlich noch nicht funktionsfähig
  # definitiv noch nicht eingebunden in den Programmablauf 
  # Idee: nach dem Anlagen-speichern (Nach Erstellen oder Bearbeiten) wird der Ortsparameter erst abgefragt.
  # Als erstes wird in den vorhandenen Datensätzen gesucht.
  # Falls nichts gefunden wurde, wird mit Geokit nach Daten gesucht
  # Hier werden oft mehrere Treffer gefunden. Wenn das der Fall ist (oder mehrere vorhandene Datensätze gefunden wurden)
  # wird eine Auswahlseite aufgerufen. Um die zu vereinfachen, wird für jeden Geokit-Treffer ein Datensatz angelegt, 
  # damit aus den Ortsdatensätzen gewählt werden kann.
  # Anschließend wird die Auswahl nach @anlage.ort gespeichert.
  # Muss mensch die gewünschte @anlage extra übergeben?
  # Wie übergibt mensch den Ortsparameter (Name aus Formular) am dümmsten?
  def ort_waehlen(ort)
    File.open("log/anlagen.log","w"){|f| f.puts @redirect_params }
    File.open("log/anlagen.log","a"){|f| f.puts "flash #{flash[:redirect_params]}" }
    @orte = Ort.where(:name => ort)
    if @orte.all.size > 1
      render ort_waehlen
    elsif @orte.all.size == 1
      @anlage.ort = @orte.first
    end
    @orte =  Geokit::Geocoders::GoogleGeocoder.geocode ort
    @orte.all.each do |o|
      o =  Geokit::Geocoders::GoogleGeocoder.geocode o.ll
      o = Ort.create(:name => o.city, :plz => o.zip, :lat => o.lat, :lon => o.lng)
    end
    if @orte.all.size > 1
      render ort_waehlen
    elsif @orte.all.size == 1
      @anlage.ort = @orte.first
    elsif @orte.empty?
      flash[:notice] = 'Kein Ort gefunden'
      redirect_to @anlage
    end
  end

  def save_ortwahl
    File.open("log/anlagen.log","w"){|f| f.puts @redirect_params }
    File.open("log/anlagen.log","a"){|f| f.puts "flash #{flash[:redirect_params]}" }
    if params[:ort]
      @anlage.ort = params[:ort]
    else
      flash[:notice] = 'Kein Ort übermittelt'
    end
    if @anlage.save
      format.html { redirect_to @anlage, notice: 'Anlage was successfully updated.' }
      format.json { render :show, status: :ok, location: @anlage }
    else
      format.html { render :edit }
      format.json { render json: @anlage.errors, status: :unprocessable_entity }
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
                                  :bild_url, :bild_urheber, :anlagen_kategorie, :anlagen_kategorie_id)
    end

    def more_params
      params.require(:anlage).permit(:ort)
    end

   # Never trust parameters from the scary internet, only allow the white list through.
    def synonym_params
      params.permit(:anlage_id, :synonym)
    end
end
