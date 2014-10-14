class StoffeController < ApplicationController
  before_action :set_stoff, only: [:show, :edit, :update, :destroy]
  before_action :editor_user, only: [:new, :edit, :create, :update, :destroy]
  # GET /stoffe
  # GET /stoffe.json
  def index
    @stoffe = Stoff.paginate(page: params[:page], per_page: 20)
  end

  # GET /stoffe/1
  # GET /stoffe/1.json
  def show
    @synonyme = @stoff.stoff_synonyms.pluck(:synonym)
    @transporte = Transport.where("stoff_id = ?", @stoff).paginate(page: params[:page], per_page: 20)
  end

  # GET /stoffe/new
  def new
    @stoff = Stoff.new
  end

  # GET /stoffe/1/edit
  def edit
    @synonyme = @stoff.stoff_synonyms.pluck(:synonym)
  end

  # POST /stoffe
  # POST /stoffe.json
  def create
    @stoff = Stoff.new(stoff_params)
    @redirect_params = params[:redirect_params] ? params[:redirect_params] : @stoff

    respond_to do |format|
      if @stoff.save
        format.html { redirect_to  @redirect_params, notice: 'Stoff was successfully created.' }
        format.json { render :show, status: :created, location: @stoff }
      else
        format.html { render :new }
        format.json { render json: @stoff.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stoffe/1
  # PATCH/PUT /stoffe/1.json
  def update
    respond_to do |format|
      if @stoff.update(stoff_params)
        format.html { redirect_to @stoff, notice: 'Stoff was successfully updated.' }
        format.json { render :show, status: :ok, location: @stoff }
      else
        format.html { render :edit }
        format.json { render json: @stoff.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stoffe/1
  # DELETE /stoffe/1.json
  def destroy
    @stoff.destroy
    respond_to do |format|
      format.html { redirect_to stoffe_url, notice: 'Stoff was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stoff
      @stoff = Stoff.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stoff_params
      params.require(:stoff).permit(:bezeichnung, :beschreibung, :un_nummer, :gefahr_nummer)
    end
end
