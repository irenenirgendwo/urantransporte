class UmschlaegeController < ApplicationController
  before_action :set_umschlag, only: [:show, :edit, :update, :destroy]
  before_action :editor_user, only: [:new, :edit, :create, :update, :destroy]

  # GET /umschlaege
  # GET /umschlaege.json
  def index
    @umschlaege = Umschlag.all
  end

  # GET /umschlaege/1
  # GET /umschlaege/1.json
  def show
  end

  # GET /umschlaege/new
  def new
    @umschlag = Umschlag.new
    if params[:transport_id]
      @transport = Transport.find(params[:transport_id].to_i)
    end
  end

  # GET /umschlaege/1/edit
  def edit
  end

  # POST /umschlaege
  # POST /umschlaege.json
  def create
    @umschlag = Umschlag.new(umschlag_params)
    transport = params[:transport_id] ? Transport.find(params[:transport_id].to_i) : nil
    @umschlag.transport = transport
    @redirection = params[:transport_id] ? transport : @umschlag
    respond_to do |format|
      if @umschlag.save
        format.html { redirect_to @redirection, notice: "Umschlag was successfully created #{umschlag_params}." }
        format.json { render :show, status: :created, location: @umschlag }
      else
        format.html { render :new }
        format.json { render json: @umschlag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /umschlaege/1
  # PATCH/PUT /umschlaege/1.json
  def update
    respond_to do |format|
      if @umschlag.update(umschlag_params)
        format.html { redirect_to @umschlag, notice: 'Umschlag was successfully updated.' }
        format.json { render :show, status: :ok, location: @umschlag }
      else
        format.html { render :edit }
        format.json { render json: @umschlag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /umschlaege/1
  # DELETE /umschlaege/1.json
  def destroy
    @umschlag.destroy
    respond_to do |format|
      format.html { redirect_to umschlaege_url, notice: 'Umschlag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_umschlag
      @umschlag = Umschlag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def umschlag_params
      params.require(:umschlag).permit(:terminal, :ort, :transport, :transport_id,
                                 :start_datum, :end_datum, :firma_id)
    
    end
end
