class AtomanlagesController < ApplicationController
  before_action :set_atomanlage, only: [:show, :edit, :update, :destroy]

  # GET /atomanlages
  # GET /atomanlages.json
  def index
    @atomanlages = Atomanlage.all
  end

  # GET /atomanlages/1
  # GET /atomanlages/1.json
  def show
  end

  # GET /atomanlages/new
  def new
    @atomanlage = Atomanlage.new
  end

  # GET /atomanlages/1/edit
  def edit
  end

  # POST /atomanlages
  # POST /atomanlages.json
  def create
    @atomanlage = Atomanlage.new(atomanlage_params)

    respond_to do |format|
      if @atomanlage.save
        format.html { redirect_to @atomanlage, notice: 'Atomanlage was successfully created.' }
        format.json { render :show, status: :created, location: @atomanlage }
      else
        format.html { render :new }
        format.json { render json: @atomanlage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /atomanlages/1
  # PATCH/PUT /atomanlages/1.json
  def update
    respond_to do |format|
      if @atomanlage.update(atomanlage_params)
        format.html { redirect_to @atomanlage, notice: 'Atomanlage was successfully updated.' }
        format.json { render :show, status: :ok, location: @atomanlage }
      else
        format.html { render :edit }
        format.json { render json: @atomanlage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /atomanlages/1
  # DELETE /atomanlages/1.json
  def destroy
    @atomanlage.destroy
    respond_to do |format|
      format.html { redirect_to atomanlages_url, notice: 'Atomanlage was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_atomanlage
      @atomanlage = Atomanlage.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def atomanlage_params
      params.require(:atomanlage).permit(:name, :description, :ort)
    end
end
