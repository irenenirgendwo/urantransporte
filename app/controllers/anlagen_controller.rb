class AnlagenController < ApplicationController
  before_action :set_anlage, only: [:show, :edit, :update, :destroy]

  # GET /anlagen
  # GET /anlagen.json
  def index
    @anlagen = Anlage.paginate(page: params[:page], per_page: 20)
  end

  # GET /anlagen/1
  # GET /anlagen/1.json
  def show
    @synonyme = @anlage.anlagen_synonyms.pluck(:synonym)
    @transporte = Transport.where("start_anlage_id = ? OR ziel_anlage_id = ?", @anlage, @anlage)
  end

  # GET /anlagen/new
  def new
    @anlage = Anlage.new
    @synonym = params[:synonym]
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
    @redirect_params = params[:redirect_params]
    if params[:synonym]
	  synonym = AnlagenSynonym.find_by(synonym: params[:synonym])
	  synonym.anlage = @anlage if synonym
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
      params.require(:anlage).permit(:name, :adresse, :plz, :ort, :lat, :lon, :beschreibung, 
                                  :bild_url, :bild_urheber, :anlagen_kategorie, :anlagen_kategorie_id)
    end

   # Never trust parameters from the scary internet, only allow the white list through.
    def synonym_params
      params.permit(:anlage_id, :synonym)
    end
end
