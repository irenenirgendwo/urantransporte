class DurchfahrtsorteController < ApplicationController
  before_action :set_durchfahrtsort, only: [:destroy, :schiebe_hoch, :schiebe_runter]

  include OrteAuswahl

  # GET /durchfahrtsorte/new
  # Route wird gesucht
  # Default-Einfuege-reihung ist am Ende der Route
  #
  def new
    @durchfahrtsort = Durchfahrtsort.new
    @ort = Ort.new
    if params[:route] || Route.find(params[:route].to_i).nil?
      @route = Route.find(params[:route].to_i)
      @durchfahrtsort.route = @route
      @last_reihung = @route.durchfahrtsorte.size + 1
      @durchfahrtsort.reihung = @last_reihung
    else 
      redirect_to routen_path, error: "Keine Route zum Erstellen eines Durchfahrtsortes"
    end
  end

  # POST /durchfahrtsorte
  # POST /durchfahrtsorte.json
  #
  # Beim Erstellen muessen die Indizes der bisherigen Orte entsprechend verschoben werden.
  # Die Route wird eingetragen (sie muss vorhanden sein) und ein Ort gesucht bzw. erstellt.
  #
  def create
    @durchfahrtsort = Durchfahrtsort.new(durchfahrtsort_params)
    @route = @durchfahrtsort.route
    if @route
      eindeutig, ort_e = evtl_ortswahl_weiterleitung_und_anzeige(@durchfahrtsort, params[:ortname].to_s, params[:plz], params[:lat], params[:lon], "create")
      File.open("log/ort.log","a"){|f| f.puts "ort_e #{ort_e}"}

      if eindeutig && ort_e  
        if @route.includes_ort? ort_e.id
          flash[:danger] = 'Ort schon in der Route vorhanden.'
          redirect_to @route
        else
          #Indizes anpassen
          success = @durchfahrtsort.route.erhoehe_durchfahrtsort_indizes(@durchfahrtsort.reihung)
          File.open("log/ort.log","a"){|f| f.puts "indizes angepasst #{success}"}
          
          respond_to do |format|
            if @durchfahrtsort.save
              flash[:success] = 'Durchfahrtsort erfolgreich angelegt.'
              format.html { redirect_to @route }
              format.json { render :show, status: :created, location: @durchfahrtsort }
            
            else 
                format.html { render :new }
                format.json { render json: @durchfahrtsort.errors, status: :unprocessable_entity }
            end
          end
        end
      else 
        respond_to do |format|
          @durchfahrtsort.errors[:base] << 'Kein passender Ort oder Ort mehrdeutig, nicht gespeichert. Spezifizieren durch Karten-Eingabe.'
          @durchfahrtsort.save
          format.html { render :new }
        end
      end
    else
      flash[:danger] = "Keine Route zum Anlegen des Durchfahrtsortes"
      redirect_to routen_path
    end
  end

  # DELETE /durchfahrtsorte/1
  # DELETE /durchfahrtsorte/1.json
  def destroy
    ab_reihung = @durchfahrtsort.reihung + 1
    route = @durchfahrtsort.route
    if route.transportabschnitte.empty? || (@durchfahrtsort.ort != route.start_ort && @durchfahrtsort.ort != route.end_ort)
      @durchfahrtsort.destroy
      route.decrease_indizes(ab_reihung)
      respond_to do |format|
        flash[:success] = 'Durchfahrtsort gelöscht.'
        format.html { redirect_to route }
        format.json { head :no_content }
      end
    else 
     respond_to do |format|
        flash[:danger] = 'Start und Endort dürfen nicht gelöscht werden, weil Transportabschntitte zugeordnet sind.'
        format.html { redirect_to route }
        format.json { head :no_content }
      end
    end 
  end
  
  
  def schiebe_hoch
    @route = @durchfahrtsort.route
    if @route.schiebe_hoch(@durchfahrtsort)
      flash[:success]="Erfolgreich verschoben."
    else 
      flash[:error]="Nicht verschoben."
    end 
    redirect_to @route 
  end 
  
  def schiebe_runter
    @route = @durchfahrtsort.route
    if @route.schiebe_runter(@durchfahrtsort)
      flash[:success]="Erfolgreich verschoben."
    else 
      flash[:error]="Nicht verschoben."
    end 
    redirect_to @route 
  end 

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_durchfahrtsort
      @durchfahrtsort = Durchfahrtsort.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def durchfahrtsort_params
      params.require(:durchfahrtsort).permit(:reihung, :route_id)
    end
end
