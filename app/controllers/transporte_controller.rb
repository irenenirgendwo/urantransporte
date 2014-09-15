class TransporteController < ApplicationController
  before_action :set_transport, only: [:show, :edit, :update, :destroy]

  # GET /transporte
  # GET /transporte.json
  def index
    @transporte = Transport.all
  end

  # GET /transporte/1
  # GET /transporte/1.json
  def show
  end

  # GET /transporte/new
  def new
    @transport = Transport.new
  end

  # GET /transporte/1/edit
  def edit
  end

  # POST /transporte
  # POST /transporte.json
  def create
    @transport = Transport.new(transport_params)

    respond_to do |format|
      if @transport.save
        format.html { redirect_to @transport, notice: 'Transport was successfully created.' }
        format.json { render :show, status: :created, location: @transport }
      else
        format.html { render :new }
        format.json { render json: @transport.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transporte/1
  # PATCH/PUT /transporte/1.json
  def update
    respond_to do |format|
      if @transport.update(transport_params)
        format.html { redirect_to @transport, notice: 'Transport was successfully updated.' }
        format.json { render :show, status: :ok, location: @transport }
      else
        format.html { render :edit }
        format.json { render json: @transport.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transporte/1
  # DELETE /transporte/1.json
  def destroy
    @transport.destroy
    respond_to do |format|
      format.html { redirect_to transporte_url, notice: 'Transport was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def edit_abschnitte
    @transport = Transport.find(params[:id])
  end 
  
  def update_abschnitte
    @transport = Transport.find(params[:id])
    
    respond_to do |format|
      redirect_to @transport, notice: 'Transportabschnitte wurden aktualisiert (tut noch nicht).' 
    end
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transport
      @transport = Transport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transport_params
      params.require(:transport).permit(:menge, :stoff, :behaelter, :anzahl,
                                 :start_anlage_id, :ziel_anlage_id, :datum)
    end
end
