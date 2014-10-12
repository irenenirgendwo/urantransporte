class TransportabschnitteController < ApplicationController
  before_action :set_transportabschnitt, only: [:show, :edit, :update, :destroy]
  

  # GET /transportabschnitte
  # GET /transportabschnitte.json
  def index
    @transport = Transport.find(params["transport_id"].to_i) if params["transport_id"]
    @transportabschnitte = @transport.nil? ? Transportabschnitt.all : @transport.transportabschnitte
  end

  # GET /transportabschnitte/1
  # GET /transportabschnitte/1.json
  def show
  end

  # GET /transportabschnitte/new
  def new
    @transport = Transport.find(params[:transport_id].to_i) if params[:transport_id]
    @beobachtung_id = params[:beobachtung_id].to_i if params[:beobachtung_id]
    @beobachtung = Beobachtung.find(@beobachtung_id)
    @transportabschnitt = Transportabschnitt.new
  end

  # GET /transportabschnitte/1/edit
  def edit
  end

  # POST /transportabschnitte
  # POST /transportabschnitte.json
  def create
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
    @transportabschnitt.destroy
    respond_to do |format|
      format.html { redirect_to transportabschnitte_url, notice: 'Transportabschnitt was successfully destroyed.' }
      format.json { head :no_content }
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
      params.require(:transportabschnitt).permit(:start_ort, :end_ort, :transport, :transport_id,
                                 :start_datum, :end_datum, :firma_id, :verkehrstraeger)
    end
end
