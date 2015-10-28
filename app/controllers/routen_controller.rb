class RoutenController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy, :get_end_orte]

  # GET /routen
  # GET /routen.json
  def index
    @routen = Route.all
  end

  # GET /routen/1
  # GET /routen/1.json
  def show
    @orte = @route.ordered_orte
    @strecken = @route.get_strecken
  end

  # GET /routen/new
  def new
    @route = Route.new
  end

  # GET /routen/1/edit
  def edit
  end

  # POST /routen
  # POST /routen.json
  def create
    @route = Route.new(route_params)

    respond_to do |format|
      if @route.save
        flash[:success] = "Route angelegt."
        format.html { redirect_to @route }
        format.json { render :show, status: :created, location: @route }
      else
        format.html { render :new }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /routen/1
  # PATCH/PUT /routen/1.json
  def update
    respond_to do |format|
      if @route.update(route_params)
        flash[:success] = "Route aktualisiert."
        format.html { redirect_to @route }
        format.json { render :show, status: :ok, location: @route }
      else
        format.html { render :edit }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /routen/1
  # DELETE /routen/1.json
  def destroy
    @route.destroy
    respond_to do |format|
      flash[:success] = "Route gelöscht."
      format.html { redirect_to routen_url }
      format.json { head :no_content }
    end
  end
  
  def get_end_orte
    alle_orte = @route.ordered_orte
    @start_ort = alle_orte.first
    @end_ort = alle_orte.last
    respond_to do |format|
      #format.html 
      format.json 
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_route
      @route = Route.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def route_params
      params.require(:route).permit(:name)
    end
end
