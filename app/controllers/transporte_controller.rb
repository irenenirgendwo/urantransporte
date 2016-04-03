#encoding: UTF-8
class TransporteController < ApplicationController
  before_action :set_transport, only: [:show, :edit, :update, :destroy, :union, :set_aehnliche_transporte_options, :aehnliche_transporte]
  before_action :editor_user, only: [:new, :edit, :create, :update, :destroy, :union, :set_aehnliche_transporte_options, :aehnliche_transporte]
  before_action :set_new_stoff_and_anlage, only: [:new, :edit]

  # Zeigt einen Transport ein. 
  # Funktionalitaeten zur Sortierung von Abschnitten und Umschlaegen sind im Transport-Modell.
  #
  # GET /transporte/1
  # GET /transporte/1.json
  #
  def show
    @abschnitt_umschlag_list = @transport.sort_abschnitte_and_umschlaege
    @orte = @transport.get_known_orte
    @orte_props, @strecken = @transport.get_known_orte_with_props
  end

  # GET /transporte/new
  def new
    @transport = Transport.new
    @stoff = Stoff.new
    if params[:beobachtung_id]
      @beobachtung_id = params[:beobachtung_id].to_i
      @beobachtung = Beobachtung.find(@beobachtung_id) 
      @redirect_params = @beobachtung
    else 
      @redirect_params = transporte_path
    end
  end

  # GET /transporte/1/edit
  def edit
  end
  
  # Zum zusammenfuehren von Transporten suche nach aehnlichen Transporten
  def aehnliche_transporte
    @toleranz_tage = params[:tage] ? params[:tage].to_i : 4
    @transporte = Transport.get_transporte_around(@transport.datum,4)
  end 
  
  # zum zusammen fuehren optionen setzen
  def set_aehnliche_transporte_options
    File.open("log/transport.log","w"){|f| f.puts "set aehnliche Transporte mit #{params}"}
    @toleranz_tage = params[:tage].to_i
    @start = params[:start]=="true" ? @transport.start_anlage : nil
    @ziel = params[:ziel]=="true" ? @transport.ziel_anlage : nil
    @transporte = Transport.get_transporte_around_options(@transport.datum,@toleranz_tage, 
                  @start, @ziel).where("id > ? or id < ?", @transport.id, @transport.id)
    render :partial => "aehnliche", :locals => {:transport => @transport}
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
        flash[:success] = "Transport angelegt."
        format.html { redirect_to redirection }
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
        flash[:success] = "Transport aktualisiert."
        format.html { redirect_to @transport  }
        format.json { render :show, status: :ok, location: @transport }
      else
        flash[:danger] = "Fehler beim Aktualisieren."
        format.html { render :edit }
        format.json { render json: @transport.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transporte/1
  # DELETE /transporte/1.json
  def destroy
    respond_to do |format|
      if @transport.destroy
        flash[:success] = "Transport gelöscht."
        format.html { redirect_to transporte_url }
        format.json { head :no_content }
      else 
        flash[:danger] = 'Der Transport hat noch Abschnitte und Umschläge. Deshalb ist das Löschen nicht möglich.'
        format.html { redirect_to @transport }
        format.json { head :no_content }
      end
    end
  end
  
  # GET transporte/union/:id/:add_transport_id
  #
  def union
    adding_transport = Transport.find(params[:add_transport].to_i)
    if adding_transport 
      @transport.add(adding_transport)
      if @transport.save
        flash[:success] = "Transport #{params[:add_transport]} erfolgreich hinzugefügt und aus der Datenbank gelöscht."
        redirect_to @transport
      else 
        flash[:danger] = "Transport konnte nicht gespeichert werden."
        redirect_to @transport
      end
    else
      redirect_to aehnliche_transporte_transport_path(@transport)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transport
      @transport = Transport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transport_params
      params.require(:transport).permit(:menge_netto, :menge_brutto, :stoff, :stoff_id, :behaelter, :anzahl,
                                 :start_anlage_id, :ziel_anlage_id, :datum, :quelle)
    end
    
    def set_new_stoff_and_anlage
      @stoff = Stoff.new
      @anlage = Anlage.new
      
      @stoffe = Stoff.order(:bezeichnung).all
      @anlagen = Anlage.order(:name).all
      
      if Stoff.find_by_bezeichnung("Unbekannt")
        @stoff_selected_id = Stoff.find_by_bezeichnung("Unbekannt").id
      else
        @stoff_selected_id = @stoffe.first.id
      end
      
      if Anlage.find_by_name("Unbekannt")
        @anlage_selected_id = Anlage.find_by_name("Unbekannt").id
      else
        @anlage_selected = @anlagen.first.id
      end
    end
end
