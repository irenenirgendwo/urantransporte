class TransporteController < ApplicationController
  before_action :set_transport, only: [:show, :edit, :update, :destroy]

  # GET /transporte
  # GET /transporte.json
  def index
    if params[:stoff]
      @transporte = Transport.where(:stoff_id => params[:stoff]).paginate(page: params[:page], per_page: 20)
    else
      @transporte = Transport.paginate(page: params[:page], per_page: 20)
    end
    @stoffe = Stoff.get_stoffe_for_selection_field
  end

  # GET /transporte/1
  # GET /transporte/1.json
  def show
  end

  # GET /transporte/new
  def new
    @transport = Transport.new
    @beobachtung_id = params[:beobachtung_id].to_i if params[:beobachtung_id]
    @beobachtung = Beobachtung.find(@beobachtung_id) if params[:beobachtung_id]
  end

  # GET /transporte/1/edit
  def edit
  end

  # legt einen neuen Transport, erstmal ohne Transportabschnitte an.
  # POST /transporte
  # POST /transporte.json
  def create
    @transport = Transport.new(transport_params)
    redirection = @transport
    if params[:beobachtung_id]
      @beobachtung = Beobachtung.find(params[:beobachtung_id].to_i)
      redirection = beobachtung_path(@beobachtung)
    end

    respond_to do |format|
      if @transport.save
        format.html { redirect_to redirection, notice: 'Transport was successfully created.' }
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
  
  # Macht alle Abschnittsdaten bearbeitbar.
  #
  #def edit_abschnitte
  #  @transport = Transport.find(params[:id])
  #end 
  
  
  # TODO: unfertig, wie soll das eigentlich am besten aussehen?
  #def update_abschnitte
  #  @transport = Transport.find(params[:id])
  #  
  #  respond_to do |format|
  #    redirect_to @transport, notice: 'Transportabschnitte wurden aktualisiert (tut noch nicht).' 
  #  end
  #end 
  
  def union_transport
    # oder zieltransport schon @transport und route zu ressourcen hinzufuegen?
    ziel_transport = Transport.find(params[:ziel_transport].to_i)
    add_transport = ziel_transport.add(Transport.find(params[:add_transport].to_i))
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transport
      @transport = Transport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transport_params
      params.require(:transport).permit(:menge, :stoff, :stoff_id, :behaelter, :anzahl,
                                 :start_anlage_id, :ziel_anlage_id, :datum, :quelle)
    end
end
