class DurchfahrtsorteController < ApplicationController
  before_action :set_durchfahrtsort, only: [:show, :edit, :update, :destroy]

  include OrteAuswahl

  # GET /durchfahrtsorte/1
  # GET /durchfahrtsorte/1.json
  def show
  end

  # GET /durchfahrtsorte/new
  def new
    @durchfahrtsort = Durchfahrtsort.new
    @ort = Ort.new
    if params[:route] || Route.find(params[:route].to_i).nil?
      @route = Route.find(params[:route].to_i)
      @durchfahrtsort.route = @route
      @last_index = @route.durchfahrtsorte.size + 1
      @durchfahrtsort.index = @last_index
    else 
      redirect_to routen_path, error: "Keine Route zum Erstellen eines Durchfahrtsortes"
    end
  end

  # GET /durchfahrtsorte/1/edit
  def edit
  end

  # POST /durchfahrtsorte
  # POST /durchfahrtsorte.json
  def create
    File.open("log/ort.log","w"){|f| f.puts "create new durchfahrtsort"}
    
    @durchfahrtsort = Durchfahrtsort.new(durchfahrtsort_params)
    File.open("log/ort.log","a"){|f| f.puts "Params #{params}"}
    @route = @durchfahrtsort.route
    if @route
      eindeutig, ort_e = evtl_ortswahl_weiterleitung_und_anzeige(@durchfahrtsort, params[:ortname].to_s, params[:plz], params[:lat], params[:lon], "create")
    
      if eindeutig   
        File.open("log/ort.log","a"){|f| f.puts "Ort #{ort_e}"}

        #@durchfahrtsort.ort = ort_e

        respond_to do |format|
          if @durchfahrtsort.save
            flash[:info] = 'Durchfahrtsort was successfully created.'
            format.html { redirect_to @route }
            format.json { render :show, status: :created, location: @durchfahrtsort }
          else
            format.html { render :new }
            format.json { render json: @durchfahrtsort.errors, status: :unprocessable_entity }
          end
        end
      else 
        flash[:error] = 'Kein passender Ort oder Ort mehrdeutig, nicht gespeichert. Spezifizieren durch Karten-Eingabe.'
        redirect_to edit_durchfahrtsort_path(@durchfahrtsort)
      end
    else
      flash[:error] = "Keine Route zum Anlegen des Durchfahrtsortes"
      redirect_to routen_path
    end
  end

  # PATCH/PUT /durchfahrtsorte/1
  # PATCH/PUT /durchfahrtsorte/1.json
  def update
    respond_to do |format|
      if @durchfahrtsort.update(durchfahrtsort_params)
        format.html { redirect_to @durchfahrtsort, notice: 'Durchfahrtsort was successfully updated.' }
        format.json { render :show, status: :ok, location: @durchfahrtsort }
      else
        format.html { render :edit }
        format.json { render json: @durchfahrtsort.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /durchfahrtsorte/1
  # DELETE /durchfahrtsorte/1.json
  def destroy
    @durchfahrtsort.destroy
    respond_to do |format|
      format.html { redirect_to durchfahrtsorte_url, notice: 'Durchfahrtsort was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_durchfahrtsort
      @durchfahrtsort = Durchfahrtsort.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def durchfahrtsort_params
      params.require(:durchfahrtsort).permit(:index, :route_id)
    end
end
