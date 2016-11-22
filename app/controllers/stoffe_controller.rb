# encoding: utf-8
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
    @transporte = Transport.where("stoff_id = ?", @stoff).order(datum: :desc).paginate(page: params[:page], per_page: 20)
  end

  # GET /stoffe/new
  def new
    @stoff = Stoff.new
    flash[:redirect_params] = params[:redirect_params]
  end

  # GET /stoffe/1/edit
  def edit
    @synonyme = @stoff.stoff_synonyms.pluck(:synonym)
  end

  # POST /stoffe
  # POST /stoffe.json
  def create
    @stoff = Stoff.new(stoff_params)
    @redirect_params = (params[:redirect_params].blank?) ? @stoff : params[:redirect_params] 
    
    respond_to do |format|
      if @stoff.save
       # Name als Synonm speichern
        synonym = StoffSynonym.find_by(synonym: @stoff.bezeichnung)
        if synonym.nil?
          synonym = StoffSynonym.new(synonym: @stoff.bezeichnung) 
        end
        synonym.stoff = @stoff if synonym.stoff.nil?
        synonym.save 
        File.open("log/anlagen.log","a"){|f| f.puts "syn #{synonym}"}
        if params[:synonym] && params[:synonym] != @stoff.bezeichnung
          synonym = StoffSynonym.find_by(synonym: params[:synonym])
          if synonym 
            synonym.stoff = @stoff
            synonym.save 
          end
        end
        flash[:success] = "Stoff erstellt."
        format.html { redirect_to  @redirect_params }
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
        format.html { redirect_to @stoff }
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
      flash[:success] = "Stoff gelöscht."
      format.html { redirect_to stoffe_url }
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
