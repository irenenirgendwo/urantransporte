class UmschlagorteController < ApplicationController
  before_action :set_umschlagort, only: [:show, :edit, :update, :destroy]

  # GET /umschlagorte
  # GET /umschlagorte.json
  def index
    @umschlagorte = Umschlagort.all
  end

  # GET /umschlagorte/1
  # GET /umschlagorte/1.json
  def show
  end

  # GET /umschlagorte/new
  def new
    @umschlagort = Umschlagort.new
  end

  # GET /umschlagorte/1/edit
  def edit
  end

  # POST /umschlagorte
  # POST /umschlagorte.json
  def create
    @umschlagort = Umschlagort.new(umschlagort_params)

    respond_to do |format|
      if @umschlagort.save
        format.html { redirect_to @umschlagort, notice: 'Umschlagort was successfully created.' }
        format.json { render :show, status: :created, location: @umschlagort }
      else
        format.html { render :new }
        format.json { render json: @umschlagort.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /umschlagorte/1
  # PATCH/PUT /umschlagorte/1.json
  def update
    respond_to do |format|
      if @umschlagort.update(umschlagort_params)
        format.html { redirect_to @umschlagort, notice: 'Umschlagort was successfully updated.' }
        format.json { render :show, status: :ok, location: @umschlagort }
      else
        format.html { render :edit }
        format.json { render json: @umschlagort.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /umschlagorte/1
  # DELETE /umschlagorte/1.json
  def destroy
    @umschlagort.destroy
    respond_to do |format|
      format.html { redirect_to umschlagorte_url, notice: 'Umschlagort was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_umschlagort
      @umschlagort = Umschlagort.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def umschlagort_params
      params.require(:umschlagort).permit(:ortsname)
    end
end
