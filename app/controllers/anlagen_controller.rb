class AnlagenController < ApplicationController
  before_action :set_anlage, only: [:show, :edit, :update, :destroy]

  # GET /anlagen
  # GET /anlagen.json
  def index
    @anlagen = Anlage.all
  end

  # GET /anlagen/1
  # GET /anlagen/1.json
  def show
  end

  # GET /anlagen/new
  def new
    @anlage = Anlage.new
  end

  # GET /anlagen/1/edit
  def edit
  end

  # POST /anlagen
  # POST /anlagen.json
  def create
    @anlage = Anlage.new(anlage_params)

    respond_to do |format|
      if @anlage.save
        format.html { redirect_to @anlage, notice: 'Anlage was successfully created.' }
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
    @anlage.destroy
    respond_to do |format|
      format.html { redirect_to anlagen_url, notice: 'Anlage was successfully destroyed.' }
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
      params.require(:anlage).permit(:name, :adresse, :plz, :ort, :beschreibung)
    end
end
