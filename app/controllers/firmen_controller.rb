# encoding: utf-8
class FirmenController < ApplicationController
  before_action :set_firma, only: [:show, :edit, :update, :destroy]
  before_action :editor_user, only: [:new, :edit, :create, :update, :destroy]
   
  # GET /firmen
  # GET /firmen.json
  def index
    @firmen = Firma.paginate(page: params[:page], per_page: 20)
  end

  # GET /firmen/1
  # GET /firmen/1.json
  def show
    @transporte = Transport.joins(:transportabschnitte).where(:transportabschnitte => {firma_id: @firma}).paginate(page: params[:page], per_page: 20)
  end
  
  # GET /firmen/new
  def new
    @firma = Firma.new
  end

  # GET /firmen/1/edit
  def edit
  end

  # POST /firmen
  # POST /firmen.json
  def create
    @firma = Firma.new(firma_params)
    @redirect_params = params[:redirect_params] ? params[:redirect_params] : (flash[:redirect_params]  ? flash[:redirect_params] : @firma)

    respond_to do |format|
      if @firma.save
        flash[:success] = "Firma angelegt"
        format.html { redirect_to @redirect_params }
        format.json { render :show, status: :created, location: @firma }
      else
        format.html { render :new }
        format.json { render json: @firma.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /firmen/1
  # PATCH/PUT /firmen/1.json
  def update
    respond_to do |format|
      if @firma.update(firma_params)
        flash[:success] = "Firma aktualisiert"
        format.html { redirect_to @firma }
        format.json { render :show, status: :ok, location: @firma }
      else
        format.html { render :edit }
        format.json { render json: @firma.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /firmen/1
  # DELETE /firmen/1.json
  def destroy
    @firma.destroy
    respond_to do |format|
      flash[:success] = "Firma gelöscht."
      format.html { redirect_to firmen_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_firma
      @firma = Firma.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def firma_params
      params.require(:firma).permit(:name, :beschreibung, :reederei)
    end
end
