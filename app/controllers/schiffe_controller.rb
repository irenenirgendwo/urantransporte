# encoding: utf-8
class SchiffeController < ApplicationController
  include SchiffeHelper
  
  before_action :set_schiff, only: [:show, :edit, :update, :destroy]
  before_action :editor_user
  
  def index
    @schiffe = Schiff.order(:name).paginate(page: params[:page], per_page: 20)
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
      if @schiff.vesselfinder_url
        storePosition(@schiff)
      end
      redirect_to @schiff
    else
      render :new
    end
  end
  
  def update
    if @schiff.update(schiff_params)
      if @schiff.vesselfinder_url
        storePosition(@schiff)
      end
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
      params.require(:schiff).permit(:name, :imo, :vesselfinder_url, :bild_url, :bild_urheber)
    end
    
    def set_schiff
      @schiff = Schiff.find(params[:id])
    end
  
end