# encoding: utf-8
class SchiffeController < ApplicationController
  before_action :set_schiff, only: [:show, :edit, :update, :destroy]
  
  def index
    @schiffe = Schiff.paginate(page: params[:page], per_page: 20)
  end
  
  def show
  end
  
  # GET /anlagen/new
  def new
    @schiff= Schiff.new
  end
  
  def edit
  end
  
  # POST /anlagen
  def create
    @schiff = Schiff.new(schiff_params)
    
    if @schiff.save
        redirect_to @schiff
      else
        render :new
      end
  end
  
  def update
    if @schiff.update(schiff_params)
      redirect_to @schiff
    else
      render :edit
    end
  end
  
  def destroy
    @schiff.destroy
    redirect_to schiffe_url
  end
  
  private
  
    def schiff_params
      params.require(:schiff).permit(:name, :imo)
    end
    
    def set_schiff
      @schiff = Schiff.find(params[:id])
    end
  
end