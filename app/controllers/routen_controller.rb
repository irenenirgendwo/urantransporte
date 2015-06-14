class RoutenController < ApplicationController
  before_action :set_route, only: [:show, :edit, :update, :destroy]

  # GET /routen
  # GET /routen.json
  def index
    @routen = Route.all
  end

  # GET /routen/1
  # GET /routen/1.json
  def show
    
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
        format.html { redirect_to @route, notice: 'Route was successfully created.' }
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
        format.html { redirect_to @route, notice: 'Route was successfully updated.' }
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
      format.html { redirect_to routen_url, notice: 'Route was successfully destroyed.' }
      format.json { head :no_content }
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
